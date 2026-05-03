package dto;

import java.math.BigDecimal;

public class Coupon {
    private int couponId;
    private String code;
    private int discountPercent;
    private BigDecimal maxDiscount;
    private BigDecimal minOrder;
    private boolean active;
    private int userId;
    private boolean used;

    public int getCouponId() { return couponId; }
    public void setCouponId(int couponId) { this.couponId = couponId; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public int getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(int discountPercent) { this.discountPercent = discountPercent; }
    public BigDecimal getMaxDiscount() { return maxDiscount; }
    public void setMaxDiscount(BigDecimal maxDiscount) { this.maxDiscount = maxDiscount; }
    public BigDecimal getMinOrder() { return minOrder; }
    public void setMinOrder(BigDecimal minOrder) { this.minOrder = minOrder; }
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public boolean isUsed() { return used; }
    public void setUsed(boolean used) { this.used = used; }
}
