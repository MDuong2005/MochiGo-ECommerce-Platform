package dao;

import dto.Coupon;
import util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CouponDAO {
    
    public Coupon getCouponByCode(String code) {
        String sql = "SELECT * FROM coupons WHERE code = ? AND is_active = 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Coupon c = new Coupon();
                    c.setCouponId(rs.getInt("coupon_id"));
                    c.setCode(rs.getString("code"));
                    c.setDiscountPercent(rs.getInt("discount_percent"));
                    c.setMaxDiscount(rs.getBigDecimal("max_discount"));
                    c.setMinOrder(rs.getBigDecimal("min_order"));
                    c.setActive(rs.getBoolean("is_active"));
                    c.setUserId(rs.getInt("user_id"));
                    c.setUsed(rs.getBoolean("is_used"));
                    return c;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertCoupon(Coupon c) {
        String sql = "INSERT INTO coupons (code, discount_percent, max_discount, min_order, is_active, user_id, is_used) VALUES (?, ?, ?, ?, 1, ?, 0)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getCode());
            ps.setInt(2, c.getDiscountPercent());
            ps.setBigDecimal(3, c.getMaxDiscount());
            ps.setBigDecimal(4, c.getMinOrder());
            if (c.getUserId() > 0) {
                ps.setInt(5, c.getUserId());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean markCouponAsUsed(int couponId) {
        String sql = "UPDATE coupons SET is_used = 1 WHERE coupon_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, couponId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
