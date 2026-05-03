package dao;

import dto.User;
import util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    public User findByEmail(String email) {
        String sql = "SELECT user_id, email, password_hash, full_name, phone, role, is_active, created_at FROM users WHERE email = ?";

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("user_id"));
                    u.setEmail(rs.getString("email"));
                    u.setPasswordHash(rs.getString("password_hash"));
                    u.setFullName(rs.getString("full_name"));
                    u.setPhone(rs.getString("phone"));
                    u.setRole(rs.getString("role"));
                    u.setActive(rs.getBoolean("is_active"));
                    u.setCreatedAt(rs.getTimestamp("created_at"));
                    return u;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean insertUser(User user) {
        String sql = "INSERT INTO users(email, password_hash, full_name, phone, role, is_active) VALUES (?, ?, ?, ?, ?, ?)";

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getRole());
            ps.setBoolean(6, user.isActive());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updatePassword(int userId, String newPasswordHash) {
        String sql = "UPDATE users SET password_hash = ? WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPasswordHash);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public java.util.List<User> getAllUsers() {
        java.util.List<User> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setEmail(rs.getString("email"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setFullName(rs.getString("full_name"));
                u.setPhone(rs.getString("phone"));
                u.setRole(rs.getString("role"));
                u.setActive(rs.getBoolean("is_active"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateUserStatus(int userId, boolean isActive) {
        String sql = "UPDATE users SET is_active = ? WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateUserRole(int userId, String role) {
        String sql = "UPDATE users SET role = ? WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteUser(int userId) {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            
            // Mỗi bước có try-catch riêng để bảng không tồn tại không làm hỏng toàn bộ
            // Step 1: wishlists
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM wishlists WHERE user_id = ?")) {
                ps.setInt(1, userId); ps.executeUpdate();
            } catch (Exception e) { System.err.println("[deleteUser] Step1 wishlists: " + e.getMessage()); }

            // Step 2: product_reviews by user
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM product_reviews WHERE user_id = ?")) {
                ps.setInt(1, userId); ps.executeUpdate();
            } catch (Exception e) { System.err.println("[deleteUser] Step2 product_reviews(user): " + e.getMessage()); }

            // Step 3: voucher_users
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM voucher_users WHERE user_id = ?")) {
                ps.setInt(1, userId); ps.executeUpdate();
            } catch (Exception e) { System.err.println("[deleteUser] Step3 voucher_users: " + e.getMessage()); }

            // Step 4: voucher_history by user
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM voucher_history WHERE user_id = ?")) {
                ps.setInt(1, userId); ps.executeUpdate();
            } catch (Exception e) { System.err.println("[deleteUser] Step4 voucher_history(user): " + e.getMessage()); }

            // Step 5: coupons
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM coupons WHERE user_id = ?")) {
                ps.setInt(1, userId); ps.executeUpdate();
            } catch (Exception e) { System.err.println("[deleteUser] Step5 coupons: " + e.getMessage()); }

            // Step 6: cart_items (nếu bảng tồn tại trong DB)
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM cart_items WHERE cart_id IN (SELECT cart_id FROM carts WHERE user_id = ?)")) {
                ps.setInt(1, userId); ps.executeUpdate();
            } catch (Exception e) { System.err.println("[deleteUser] Step6 cart_items (skip if not exists): " + e.getMessage()); }

            // Step 7: carts (nếu bảng tồn tại trong DB)
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM carts WHERE user_id = ?")) {
                ps.setInt(1, userId); ps.executeUpdate();
            } catch (Exception e) { System.err.println("[deleteUser] Step7 carts (skip if not exists): " + e.getMessage()); }

            // Step 8: order_items
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM order_items WHERE order_id IN (SELECT order_id FROM orders WHERE user_id = ?)")) {
                ps.setInt(1, userId); ps.executeUpdate();
            } catch (Exception e) { System.err.println("[deleteUser] Step8 order_items: " + e.getMessage()); }

            // Step 9: voucher_history by order
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM voucher_history WHERE order_id IN (SELECT order_id FROM orders WHERE user_id = ?)")) {
                ps.setInt(1, userId); ps.executeUpdate();
            } catch (Exception e) { System.err.println("[deleteUser] Step9 voucher_history(order): " + e.getMessage()); }

            // Step 10: product_reviews by order
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM product_reviews WHERE order_id IN (SELECT order_id FROM orders WHERE user_id = ?)")) {
                ps.setInt(1, userId); ps.executeUpdate();
            } catch (Exception e) { System.err.println("[deleteUser] Step10 product_reviews(order): " + e.getMessage()); }

            // Step 11: orders
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM orders WHERE user_id = ?")) {
                ps.setInt(1, userId); ps.executeUpdate();
            } catch (Exception e) {
                System.err.println("[deleteUser] Step11 orders FAILED - rolling back: " + e.getMessage());
                conn.rollback();
                return false;
            }

            // Step 12: users (quan trọng nhất)
            int rows;
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM users WHERE user_id = ?")) {
                ps.setInt(1, userId);
                rows = ps.executeUpdate();
            } catch (Exception e) {
                System.err.println("[deleteUser] Step12 users FAILED - rolling back: " + e.getMessage());
                conn.rollback();
                return false;
            }

            conn.commit();
            System.out.println("[deleteUser] SUCCESS: deleted userId=" + userId);
            return rows > 0;

        } catch (Exception e) {
            System.err.println("[deleteUser] OUTER error: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ex) {}
            }
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (Exception ex) {}
            }
        }
    }
}
