package dao;

import dto.Voucher;
import dto.User;
import util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class VoucherDAO {

    public List<Voucher> getAllVouchers() {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT * FROM vouchers ORDER BY created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Voucher v = new Voucher();
                v.setVoucherId(rs.getInt("voucher_id"));
                v.setCode(rs.getString("code"));
                v.setDiscountType(rs.getString("discount_type"));
                v.setDiscountValue(rs.getBigDecimal("discount_value"));
                v.setMinOrderValue(rs.getBigDecimal("min_order_value"));
                v.setMaxDiscountValue(rs.getBigDecimal("max_discount_value"));
                v.setTotalQuantity(rs.getInt("total_quantity"));
                v.setUsedQuantity(rs.getInt("used_quantity"));
                v.setMaxUsesPerUser(rs.getInt("max_uses_per_user"));
                v.setTargetType(rs.getString("target_type"));
                v.setTargetGroup(rs.getString("target_group"));
                v.setStartDate(rs.getTimestamp("start_date"));
                v.setEndDate(rs.getTimestamp("end_date"));
                v.setActive(rs.getBoolean("is_active"));
                v.setCreatedAt(rs.getTimestamp("created_at"));
                v.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insertVoucher(Voucher v, List<Integer> userIds) {
        String sql = "INSERT INTO vouchers (code, discount_type, discount_value, min_order_value, max_discount_value, " +
                     "total_quantity, max_uses_per_user, target_type, target_group, start_date, end_date, is_active) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, v.getCode());
                ps.setString(2, v.getDiscountType());
                ps.setBigDecimal(3, v.getDiscountValue());
                ps.setBigDecimal(4, v.getMinOrderValue());
                if (v.getMaxDiscountValue() != null) {
                    ps.setBigDecimal(5, v.getMaxDiscountValue());
                } else {
                    ps.setNull(5, java.sql.Types.DECIMAL);
                }
                ps.setInt(6, v.getTotalQuantity());
                ps.setInt(7, v.getMaxUsesPerUser());
                ps.setString(8, v.getTargetType());
                ps.setString(9, v.getTargetGroup());
                ps.setTimestamp(10, v.getStartDate());
                ps.setTimestamp(11, v.getEndDate());
                ps.setBoolean(12, v.isActive());
                
                int affectedRows = ps.executeUpdate();
                if (affectedRows == 0) {
                    conn.rollback();
                    return false;
                }
                
                if ("SPECIFIC_USER".equals(v.getTargetType()) && userIds != null && !userIds.isEmpty()) {
                    try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            int voucherId = generatedKeys.getInt(1);
                            String sqlUser = "INSERT INTO voucher_users (voucher_id, user_id) VALUES (?, ?)";
                            try (PreparedStatement psUser = conn.prepareStatement(sqlUser)) {
                                for (Integer uid : userIds) {
                                    psUser.setInt(1, voucherId);
                                    psUser.setInt(2, uid);
                                    psUser.addBatch();
                                }
                                psUser.executeBatch();
                            }
                        }
                    }
                }
                
                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }

    public boolean updateVoucherStatus(int id, boolean status) {
        String sql = "UPDATE vouchers SET is_active = ?, updated_at = GETDATE() WHERE voucher_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<User> searchUsers(String keyword) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE (email LIKE ? OR full_name LIKE ?) AND is_active = 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("user_id"));
                    u.setEmail(rs.getString("email"));
                    u.setFullName(rs.getString("full_name"));
                    u.setPhone(rs.getString("phone"));
                    list.add(u);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Voucher> getVouchersForUser(User user) {
        List<Voucher> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT DISTINCT v.* FROM vouchers v ");
        sql.append("LEFT JOIN voucher_users vu ON v.voucher_id = vu.voucher_id ");
        sql.append("WHERE v.is_active = 1 ");
        sql.append("AND v.start_date <= GETDATE() ");
        sql.append("AND v.end_date >= GETDATE() ");
        sql.append("AND v.used_quantity < v.total_quantity ");
        
        if (user == null) {
            sql.append("AND v.target_type = 'PUBLIC' ");
            sql.append("AND v.max_uses_per_user > (SELECT COUNT(*) FROM voucher_history vh WHERE vh.voucher_id = v.voucher_id AND vh.user_id = 0) ");
        } else {
            sql.append("AND (v.target_type = 'PUBLIC' OR (v.target_type = 'SPECIFIC_USER' AND vu.user_id = ?)) ");
            sql.append("AND v.max_uses_per_user > (SELECT COUNT(*) FROM voucher_history vh WHERE vh.voucher_id = v.voucher_id AND vh.user_id = ?) ");
        }
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
             
            if (user != null) {
                ps.setInt(1, user.getUserId());
                ps.setInt(2, user.getUserId());
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Voucher v = new Voucher();
                    v.setVoucherId(rs.getInt("voucher_id"));
                    v.setCode(rs.getString("code"));
                    v.setDiscountType(rs.getString("discount_type"));
                    v.setDiscountValue(rs.getBigDecimal("discount_value"));
                    v.setMinOrderValue(rs.getBigDecimal("min_order_value"));
                    v.setMaxDiscountValue(rs.getBigDecimal("max_discount_value"));
                    v.setTotalQuantity(rs.getInt("total_quantity"));
                    v.setUsedQuantity(rs.getInt("used_quantity"));
                    v.setMaxUsesPerUser(rs.getInt("max_uses_per_user"));
                    v.setTargetType(rs.getString("target_type"));
                    v.setTargetGroup(rs.getString("target_group"));
                    v.setStartDate(rs.getTimestamp("start_date"));
                    v.setEndDate(rs.getTimestamp("end_date"));
                    v.setActive(rs.getBoolean("is_active"));
                    v.setCreatedAt(rs.getTimestamp("created_at"));
                    v.setUpdatedAt(rs.getTimestamp("updated_at"));
                    list.add(v);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Voucher getVoucherByCode(String code) {
        String sql = "SELECT * FROM vouchers WHERE code = ? AND is_active = 1 AND start_date <= GETDATE() AND end_date >= GETDATE() AND used_quantity < total_quantity";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Voucher v = new Voucher();
                    v.setVoucherId(rs.getInt("voucher_id"));
                    v.setCode(rs.getString("code"));
                    v.setDiscountType(rs.getString("discount_type"));
                    v.setDiscountValue(rs.getBigDecimal("discount_value"));
                    v.setMinOrderValue(rs.getBigDecimal("min_order_value"));
                    v.setMaxDiscountValue(rs.getBigDecimal("max_discount_value"));
                    v.setTotalQuantity(rs.getInt("total_quantity"));
                    v.setUsedQuantity(rs.getInt("used_quantity"));
                    v.setMaxUsesPerUser(rs.getInt("max_uses_per_user"));
                    v.setTargetType(rs.getString("target_type"));
                    v.setTargetGroup(rs.getString("target_group"));
                    v.setStartDate(rs.getTimestamp("start_date"));
                    v.setEndDate(rs.getTimestamp("end_date"));
                    v.setActive(rs.getBoolean("is_active"));
                    v.setCreatedAt(rs.getTimestamp("created_at"));
                    v.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return v;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Voucher getValidVoucherByCodeForUser(String code, int userId) {
        StringBuilder sql = new StringBuilder("SELECT DISTINCT v.* FROM vouchers v ");
        sql.append("LEFT JOIN voucher_users vu ON v.voucher_id = vu.voucher_id ");
        sql.append("WHERE v.code = ? AND v.is_active = 1 ");
        sql.append("AND v.start_date <= GETDATE() ");
        sql.append("AND v.end_date >= GETDATE() ");
        sql.append("AND v.used_quantity < v.total_quantity ");
        sql.append("AND (v.target_type = 'PUBLIC' OR (v.target_type = 'SPECIFIC_USER' AND vu.user_id = ?)) ");
        sql.append("AND v.max_uses_per_user > (SELECT COUNT(*) FROM voucher_history vh WHERE vh.voucher_id = v.voucher_id AND vh.user_id = ?) ");
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setString(1, code);
            ps.setInt(2, userId);
            ps.setInt(3, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Voucher v = new Voucher();
                    v.setVoucherId(rs.getInt("voucher_id"));
                    v.setCode(rs.getString("code"));
                    v.setDiscountType(rs.getString("discount_type"));
                    v.setDiscountValue(rs.getBigDecimal("discount_value"));
                    v.setMinOrderValue(rs.getBigDecimal("min_order_value"));
                    v.setMaxDiscountValue(rs.getBigDecimal("max_discount_value"));
                    v.setTotalQuantity(rs.getInt("total_quantity"));
                    v.setUsedQuantity(rs.getInt("used_quantity"));
                    v.setMaxUsesPerUser(rs.getInt("max_uses_per_user"));
                    v.setTargetType(rs.getString("target_type"));
                    v.setTargetGroup(rs.getString("target_group"));
                    v.setStartDate(rs.getTimestamp("start_date"));
                    v.setEndDate(rs.getTimestamp("end_date"));
                    v.setActive(rs.getBoolean("is_active"));
                    v.setCreatedAt(rs.getTimestamp("created_at"));
                    v.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return v;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy voucher theo code mà KHÔNG lọc hết hạn/hết lượt — dùng để chẩn đoán lý do không hợp lệ.
     */
    public Voucher getVoucherByCodeRaw(String code) {
        String sql = "SELECT * FROM vouchers WHERE code = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Voucher v = new Voucher();
                    v.setVoucherId(rs.getInt("voucher_id"));
                    v.setCode(rs.getString("code"));
                    v.setDiscountType(rs.getString("discount_type"));
                    v.setDiscountValue(rs.getBigDecimal("discount_value"));
                    v.setMinOrderValue(rs.getBigDecimal("min_order_value"));
                    v.setMaxDiscountValue(rs.getBigDecimal("max_discount_value"));
                    v.setTotalQuantity(rs.getInt("total_quantity"));
                    v.setUsedQuantity(rs.getInt("used_quantity"));
                    v.setMaxUsesPerUser(rs.getInt("max_uses_per_user"));
                    v.setTargetType(rs.getString("target_type"));
                    v.setTargetGroup(rs.getString("target_group"));
                    v.setStartDate(rs.getTimestamp("start_date"));
                    v.setEndDate(rs.getTimestamp("end_date"));
                    v.setActive(rs.getBoolean("is_active"));
                    v.setCreatedAt(rs.getTimestamp("created_at"));
                    v.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return v;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Voucher getVoucherById(int voucherId) {
        String sql = "SELECT * FROM vouchers WHERE voucher_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Voucher v = new Voucher();
                    v.setVoucherId(rs.getInt("voucher_id"));
                    v.setCode(rs.getString("code"));
                    v.setDiscountType(rs.getString("discount_type"));
                    v.setDiscountValue(rs.getBigDecimal("discount_value"));
                    v.setMinOrderValue(rs.getBigDecimal("min_order_value"));
                    v.setMaxDiscountValue(rs.getBigDecimal("max_discount_value"));
                    v.setTotalQuantity(rs.getInt("total_quantity"));
                    v.setUsedQuantity(rs.getInt("used_quantity"));
                    v.setMaxUsesPerUser(rs.getInt("max_uses_per_user"));
                    v.setTargetType(rs.getString("target_type"));
                    v.setTargetGroup(rs.getString("target_group"));
                    v.setStartDate(rs.getTimestamp("start_date"));
                    v.setEndDate(rs.getTimestamp("end_date"));
                    v.setActive(rs.getBoolean("is_active"));
                    v.setCreatedAt(rs.getTimestamp("created_at"));
                    v.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return v;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean deleteVoucher(int voucherId) {
        String deleteUsers = "DELETE FROM voucher_users WHERE voucher_id = ?";
        String deleteVoucher = "DELETE FROM vouchers WHERE voucher_id = ?";
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            
            try (PreparedStatement psUser = conn.prepareStatement(deleteUsers)) {
                psUser.setInt(1, voucherId);
                psUser.executeUpdate();
            }
            
            int rows;
            try (PreparedStatement psVoucher = conn.prepareStatement(deleteVoucher)) {
                psVoucher.setInt(1, voucherId);
                rows = psVoucher.executeUpdate();
            }
            
            conn.commit();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ex) {}
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (Exception ex) {}
            }
        }
    }

    public boolean updateVoucher(Voucher v) {
        String sql = "UPDATE vouchers SET code=?, discount_type=?, discount_value=?, min_order_value=?, max_discount_value=?, " +
                     "total_quantity=?, max_uses_per_user=?, target_type=?, target_group=?, start_date=?, end_date=?, is_active=?, updated_at=GETDATE() " +
                     "WHERE voucher_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getCode());
            ps.setString(2, v.getDiscountType());
            ps.setBigDecimal(3, v.getDiscountValue());
            ps.setBigDecimal(4, v.getMinOrderValue());
            if (v.getMaxDiscountValue() != null) {
                ps.setBigDecimal(5, v.getMaxDiscountValue());
            } else {
                ps.setNull(5, java.sql.Types.DECIMAL);
            }
            ps.setInt(6, v.getTotalQuantity());
            ps.setInt(7, v.getMaxUsesPerUser());
            ps.setString(8, v.getTargetType());
            ps.setString(9, v.getTargetGroup());
            ps.setTimestamp(10, v.getStartDate());
            ps.setTimestamp(11, v.getEndDate());
            ps.setBoolean(12, v.isActive());
            ps.setInt(13, v.getVoucherId());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
