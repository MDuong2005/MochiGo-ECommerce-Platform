package controller;

import dao.OrderDAO;
import dao.ProductDAO;
import dto.Order;
import dto.OrderItem;
import dto.Product;
import dto.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/checkout")
public class OrderController extends HttpServlet {
    private ProductDAO productDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Just forward to checkout page
        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        String receiverName = request.getParameter("receiverName");
        String receiverPhone = request.getParameter("receiverPhone");
        String shippingAddress = request.getParameter("shippingAddress");
        String note = request.getParameter("note");
        String paymentMethod = request.getParameter("paymentMethod");

        List<OrderItem> items = new ArrayList<>();
        BigDecimal totalAmount = BigDecimal.ZERO;

        for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
            Product p = productDAO.getProductById(entry.getKey());
            if (p != null) {
                OrderItem item = new OrderItem();
                item.setProductId(p.getProductId());
                item.setQuantity(entry.getValue());
                item.setUnitPrice(p.getDiscountedPrice());
                
                BigDecimal lineTotal = p.getDiscountedPrice().multiply(new BigDecimal(entry.getValue()));
                item.setLineTotal(lineTotal);
                items.add(item);
                
                totalAmount = totalAmount.add(lineTotal);
            }
        }

        dto.Voucher sessionVoucher = (dto.Voucher) session.getAttribute("appliedVoucher");
        dto.Voucher appliedVoucher = null;
        String voucherRemovedMsg = null; // thông báo nếu voucher bị bỏ tự động

        if (sessionVoucher != null) {
            dao.VoucherDAO vDao = new dao.VoucherDAO();
            appliedVoucher = vDao.getValidVoucherByCodeForUser(sessionVoucher.getCode(), user.getUserId());

            if (appliedVoucher == null) {
                // Voucher không còn hợp lệ → xóa khỏi session nhưng VẪN tiếp tục đặt hàng ở giá gốc
                session.removeAttribute("appliedVoucher");
                // Chẩn đoán lý do để thông báo chính xác
                dto.Voucher freshInfo = vDao.getVoucherByCodeRaw(sessionVoucher.getCode());
                if (freshInfo != null && freshInfo.isExpired()) {
                    voucherRemovedMsg = "⚠️ Mã giảm giá \"" + sessionVoucher.getCode() + "\" đã hết hạn. Đơn hàng được đặt theo giá gốc.";
                } else if (freshInfo != null && freshInfo.isUsedUp()) {
                    voucherRemovedMsg = "⚠️ Mã giảm giá \"" + sessionVoucher.getCode() + "\" đã hết lượt sử dụng. Đơn hàng được đặt theo giá gốc.";
                } else {
                    voucherRemovedMsg = "⚠️ Mã giảm giá \"" + sessionVoucher.getCode() + "\" không còn hợp lệ. Đơn hàng được đặt theo giá gốc.";
                }
                // appliedVoucher vẫn là null → không áp dụng discount bên dưới
            } else {
                // Voucher còn hợp lệ → tính giảm giá
                BigDecimal minOrder = appliedVoucher.getMinOrderValue();
                if (minOrder == null || totalAmount.compareTo(minOrder) >= 0) {
                    BigDecimal discount = BigDecimal.ZERO;
                    if ("PERCENT".equals(appliedVoucher.getDiscountType())) {
                        discount = totalAmount.multiply(appliedVoucher.getDiscountValue())
                                .divide(new BigDecimal(100), 0, java.math.RoundingMode.HALF_UP);
                        if (appliedVoucher.getMaxDiscountValue() != null && discount.compareTo(appliedVoucher.getMaxDiscountValue()) > 0) {
                            discount = appliedVoucher.getMaxDiscountValue().setScale(0, java.math.RoundingMode.HALF_UP);
                        }
                    } else if ("FIXED".equals(appliedVoucher.getDiscountType())) {
                        discount = appliedVoucher.getDiscountValue().setScale(0, java.math.RoundingMode.HALF_UP);
                    }

                    if (discount.compareTo(totalAmount) > 0) {
                        discount = totalAmount;
                    }

                    totalAmount = totalAmount.subtract(discount);
                }
            }
        }
        
        // Ensure totalAmount has no decimal places (rounding half up)
        totalAmount = totalAmount.setScale(0, java.math.RoundingMode.HALF_UP);

        Order order = new Order();
        order.setUserId(user.getUserId());
        order.setReceiverName(receiverName);
        order.setReceiverPhone(receiverPhone);
        order.setShippingAddress(shippingAddress);
        order.setNote(note);
        order.setPaymentMethod(paymentMethod != null ? paymentMethod : "COD");
        order.setStatus("PENDING");
        order.setTotalAmount(totalAmount);

        int orderId = orderDAO.createOrderTransaction(order, items, appliedVoucher);

        if (orderId > 0) {
            session.removeAttribute("cart");
            session.removeAttribute("appliedVoucher");
            session.removeAttribute("couponSuccess");

            // Nếu voucher bị bỏ tự động, lưu thông báo cho user
            if (voucherRemovedMsg != null) {
                session.setAttribute("voucherRemovedMsg", voucherRemovedMsg);
            }
            
            // Generate PayOS Checkout URL
            if ("BANK_TRANSFER".equals(order.getPaymentMethod())) {
                String baseUrl = getBaseUrl(request);
                String returnUrl = baseUrl + "/order-success.jsp?orderId=" + orderId + "&amount=" + totalAmount;
                String cancelUrl = baseUrl + "/checkout";
                
                long paymentCode = Long.parseLong(orderId + String.format("%03d", System.currentTimeMillis() % 1000));
                String checkoutUrl = util.PayOSService.createPaymentLink(paymentCode, totalAmount.intValue(), returnUrl, cancelUrl);
                
                if (checkoutUrl != null && !checkoutUrl.isEmpty()) {
                    response.sendRedirect(checkoutUrl);
                    return;
                }
            }

            request.setAttribute("orderId", orderId);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("paymentMethod", paymentMethod != null ? paymentMethod : "COD");
            request.setAttribute("voucherRemovedMsg", voucherRemovedMsg);
            request.getRequestDispatcher("/order-success.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Lỗi tạo đơn hàng. Vui lòng thử lại.");
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
        }
    }

    private String getBaseUrl(HttpServletRequest request) {
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String contextPath = request.getContextPath();
        
        StringBuilder url = new StringBuilder();
        url.append(scheme).append("://").append(serverName);
        if (serverPort != 80 && serverPort != 443) {
            url.append(":").append(serverPort);
        }
        url.append(contextPath);
        return url.toString();
    }
}
