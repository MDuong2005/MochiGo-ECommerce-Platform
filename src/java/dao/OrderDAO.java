package dao;

import dto.Order;
import dto.OrderItem;
import util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public int createOrderTransaction(Order order, List<OrderItem> items, dto.Voucher appliedVoucher) {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // 1. Insert order
            String sqlOrder = "INSERT INTO orders (user_id, receiver_name, receiver_phone, shipping_address, note, payment_method, status, total_amount) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, order.getUserId());
            psOrder.setString(2, order.getReceiverName());
            psOrder.setString(3, order.getReceiverPhone());
            psOrder.setString(4, order.getShippingAddress());
            psOrder.setString(5, order.getNote());
            psOrder.setString(6, order.getPaymentMethod());
            psOrder.setString(7, order.getStatus() != null ? order.getStatus() : "PENDING");
            psOrder.setBigDecimal(8, order.getTotalAmount());

            int affectedRows = psOrder.executeUpdate();
            if (affectedRows == 0) {
                conn.rollback();
                return -1;
            }

            int orderId;
            try (ResultSet generatedKeys = psOrder.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    orderId = generatedKeys.getInt(1);
                } else {
                    conn.rollback();
                    return -1;
                }
            }
            
            // 2. Insert order items & Update stock
            String sqlItem = "INSERT INTO order_items (order_id, product_id, quantity, unit_price, line_total) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement psItem = conn.prepareStatement(sqlItem);
            
            String sqlUpdateStock = "UPDATE products SET stock = stock - ? WHERE product_id = ?";
            PreparedStatement psUpdateStock = conn.prepareStatement(sqlUpdateStock);

            for (OrderItem item : items) {
                psItem.setInt(1, orderId);
                psItem.setInt(2, item.getProductId());
                psItem.setInt(3, item.getQuantity());
                psItem.setBigDecimal(4, item.getUnitPrice());
                psItem.setBigDecimal(5, item.getLineTotal());
                psItem.addBatch();
                
                psUpdateStock.setInt(1, item.getQuantity());
                psUpdateStock.setInt(2, item.getProductId());
                psUpdateStock.addBatch();
            }
            
            psItem.executeBatch();
            psUpdateStock.executeBatch();

            // 3. Record Voucher Usage
            if (appliedVoucher != null && appliedVoucher.getVoucherId() > 0) {
                String sqlIncrementUsage = "UPDATE vouchers SET used_quantity = used_quantity + 1 WHERE voucher_id = ?";
                try (PreparedStatement psUpdateVoucher = conn.prepareStatement(sqlIncrementUsage)) {
                    psUpdateVoucher.setInt(1, appliedVoucher.getVoucherId());
                    psUpdateVoucher.executeUpdate();
                }

                // INSERT voucher_history trong try-catch riêng — nếu thất bại chỉ log, KHÔNG rollback cả đơn
                try {
                    String sqlInsertHistory = "INSERT INTO voucher_history (voucher_id, user_id, order_id, discount_amount) VALUES (?, ?, ?, ?)";
                    try (PreparedStatement psHistory = conn.prepareStatement(sqlInsertHistory)) {
                        psHistory.setInt(1, appliedVoucher.getVoucherId());
                        psHistory.setInt(2, order.getUserId());
                        psHistory.setInt(3, orderId);
                        psHistory.setBigDecimal(4, java.math.BigDecimal.ZERO);
                        psHistory.executeUpdate();
                    }
                } catch (Exception historyEx) {
                    // Chỉ log, không ném lên — đơn hàng vẫn được tạo thành công
                    System.err.println("[WARN] Không ghi được voucher_history: " + historyEx.getMessage());
                }
            }

            conn.commit();
            return orderId;

        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            return -1;
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
    }

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getInt("order_id"));
                    o.setUserId(rs.getInt("user_id"));
                    o.setReceiverName(rs.getString("receiver_name"));
                    o.setReceiverPhone(rs.getString("receiver_phone"));
                    o.setShippingAddress(rs.getString("shipping_address"));
                    o.setNote(rs.getString("note"));
                    o.setPaymentMethod(rs.getString("payment_method"));
                    o.setStatus(rs.getString("status"));
                    o.setTotalAmount(rs.getBigDecimal("total_amount"));
                    o.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(o);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Order getOrderById(int orderId, int userId) {
        String sql = "SELECT * FROM orders WHERE order_id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getInt("order_id"));
                    o.setUserId(rs.getInt("user_id"));
                    o.setReceiverName(rs.getString("receiver_name"));
                    o.setReceiverPhone(rs.getString("receiver_phone"));
                    o.setShippingAddress(rs.getString("shipping_address"));
                    o.setNote(rs.getString("note"));
                    o.setPaymentMethod(rs.getString("payment_method"));
                    o.setStatus(rs.getString("status"));
                    o.setTotalAmount(rs.getBigDecimal("total_amount"));
                    o.setCreatedAt(rs.getTimestamp("created_at"));
                    return o;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<OrderItem> getOrderItemsByOrderId(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT oi.order_item_id, oi.order_id, oi.product_id, oi.quantity, oi.unit_price, oi.line_total, p.name as product_name, p.image_url as product_image FROM order_items oi JOIN products p ON oi.product_id = p.product_id WHERE oi.order_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setOrderItemId(rs.getInt("order_item_id"));
                    item.setOrderId(rs.getInt("order_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getBigDecimal("unit_price"));
                    item.setLineTotal(rs.getBigDecimal("line_total"));
                    item.setProductName(rs.getString("product_name"));
                    item.setProductImage(rs.getString("product_image"));
                    list.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY order_id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getInt("order_id"));
                o.setUserId(rs.getInt("user_id"));
                o.setReceiverName(rs.getString("receiver_name"));
                o.setReceiverPhone(rs.getString("receiver_phone"));
                o.setShippingAddress(rs.getString("shipping_address"));
                o.setNote(rs.getString("note"));
                o.setPaymentMethod(rs.getString("payment_method"));
                o.setStatus(rs.getString("status"));
                o.setTotalAmount(rs.getBigDecimal("total_amount"));
                o.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public java.math.BigDecimal getTotalRevenue() {
        java.math.BigDecimal total = java.math.BigDecimal.ZERO;
        String sql = "SELECT SUM(total_amount) AS revenue FROM orders WHERE status IN ('PAID', 'SHIPPING', 'COMPLETED')";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                java.math.BigDecimal revenue = rs.getBigDecimal("revenue");
                if (revenue != null) {
                    total = revenue;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    public java.util.Map<Integer, java.math.BigDecimal> getMonthlyRevenueForYear(int year) {
        java.util.Map<Integer, java.math.BigDecimal> monthlyRevenue = new java.util.HashMap<>();
        // Initialize all months with zero
        for (int i = 1; i <= 12; i++) {
            monthlyRevenue.put(i, java.math.BigDecimal.ZERO);
        }

        String sql = "SELECT MONTH(created_at) as month, SUM(total_amount) as revenue " +
                     "FROM orders " +
                     "WHERE status IN ('PAID', 'SHIPPING', 'COMPLETED') AND YEAR(created_at) = ? " +
                     "GROUP BY MONTH(created_at) " +
                     "ORDER BY month";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int month = rs.getInt("month");
                    java.math.BigDecimal revenue = rs.getBigDecimal("revenue");
                    monthlyRevenue.put(month, revenue != null ? revenue : java.math.BigDecimal.ZERO);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return monthlyRevenue;
    }

    public int getPendingOrderCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) AS count FROM orders WHERE status IN ('PENDING', 'PAID')";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt("count");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    public Order getLatestPendingOrder() {
        String sql = "SELECT * FROM orders WHERE status IN ('PENDING', 'PAID') ORDER BY created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setMaxRows(1);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getInt("order_id"));
                    o.setUserId(rs.getInt("user_id"));
                    o.setReceiverName(rs.getString("receiver_name"));
                    o.setReceiverPhone(rs.getString("receiver_phone"));
                    o.setShippingAddress(rs.getString("shipping_address"));
                    o.setNote(rs.getString("note"));
                    o.setPaymentMethod(rs.getString("payment_method"));
                    o.setStatus(rs.getString("status"));
                    o.setTotalAmount(rs.getBigDecimal("total_amount"));
                    o.setCreatedAt(rs.getTimestamp("created_at"));
                    return o;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean cancelOrderTransaction(int orderId, int userId) {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. Verify status and ownership
            String checkSql = "SELECT status FROM orders WHERE order_id = ? AND user_id = ?";
            String currentStatus = null;
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, orderId);
                ps.setInt(2, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        currentStatus = rs.getString("status");
                    }
                }
            }

            if (currentStatus == null || !("PENDING".equals(currentStatus) || "PAID".equals(currentStatus))) {
                conn.rollback();
                return false;
            }

            // 2. Update status to CANCELLED
            String updateStatusSql = "UPDATE orders SET status = 'CANCELLED' WHERE order_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateStatusSql)) {
                ps.setInt(1, orderId);
                ps.executeUpdate();
            }

            // 3. Restore Stock
            String itemsSql = "SELECT product_id, quantity FROM order_items WHERE order_id = ?";
            String restoreStockSql = "UPDATE products SET stock = stock + ? WHERE product_id = ?";
            try (PreparedStatement psItems = conn.prepareStatement(itemsSql);
                 PreparedStatement psRestore = conn.prepareStatement(restoreStockSql)) {
                psItems.setInt(1, orderId);
                try (ResultSet rs = psItems.executeQuery()) {
                    while (rs.next()) {
                        psRestore.setInt(1, rs.getInt("quantity"));
                        psRestore.setInt(2, rs.getInt("product_id"));
                        psRestore.addBatch();
                    }
                }
                psRestore.executeBatch();
            }

            // 4. Refund Voucher Usage
            String voucherHistorySql = "SELECT voucher_id FROM voucher_history WHERE order_id = ?";
            int voucherId = -1;
            try (PreparedStatement ps = conn.prepareStatement(voucherHistorySql)) {
                ps.setInt(1, orderId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        voucherId = rs.getInt("voucher_id");
                    }
                }
            }

            if (voucherId != -1) {
                String refundVoucherSql = "UPDATE vouchers SET used_quantity = used_quantity - 1 WHERE voucher_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(refundVoucherSql)) {
                    ps.setInt(1, voucherId);
                    ps.executeUpdate();
                }
                
                String deleteHistorySql = "DELETE FROM voucher_history WHERE order_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(deleteHistorySql)) {
                    ps.setInt(1, orderId);
                    ps.executeUpdate();
                }
            }

            conn.commit();
            return true;
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

    public boolean deleteOrder(int orderId) {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. Delete order items
            String sqlDeleteItems = "DELETE FROM order_items WHERE order_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlDeleteItems)) {
                ps.setInt(1, orderId);
                ps.executeUpdate();
            }

            // 2. Delete voucher history
            String sqlDeleteHistory = "DELETE FROM voucher_history WHERE order_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlDeleteHistory)) {
                ps.setInt(1, orderId);
                ps.executeUpdate();
            }

            // 3. Delete order
            String sqlDeleteOrder = "DELETE FROM orders WHERE order_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlDeleteOrder)) {
                ps.setInt(1, orderId);
                ps.executeUpdate();
            }

            conn.commit();
            return true;
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
}
