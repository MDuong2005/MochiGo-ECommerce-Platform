package controller;

import dao.OrderDAO;
import dto.Order;
import dto.User;
import util.PayOSService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/repay")
public class PayOSRepaymentController extends HttpServlet {
    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr != null) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                
                // Fetch user orders to verify ownership and PENDING status
                List<Order> orders = orderDAO.getOrdersByUserId(user.getUserId());
                Order targetOrder = null;
                for (Order o : orders) {
                    if (o.getOrderId() == orderId) {
                        targetOrder = o;
                        break;
                    }
                }
                
                if (targetOrder != null && "PENDING".equals(targetOrder.getStatus()) && "BANK_TRANSFER".equals(targetOrder.getPaymentMethod())) {
                    // Generate new PayOS link
                    String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
                    String returnUrl = baseUrl + "/order-success.jsp?orderId=" + orderId + "&amount=" + targetOrder.getTotalAmount();
                    String cancelUrl = baseUrl + "/order-history";
                    
                    // Generate a new payment code
                    long paymentCode = Long.parseLong(orderId + String.format("%03d", System.currentTimeMillis() % 1000));
                    String checkoutUrl = PayOSService.createPaymentLink(paymentCode, targetOrder.getTotalAmount().intValue(), returnUrl, cancelUrl);
                    
                    if (checkoutUrl != null && !checkoutUrl.isEmpty()) {
                        response.sendRedirect(checkoutUrl);
                        return;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/order-history");
    }
}
