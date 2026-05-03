package controller;

import dao.OrderDAO;
import dto.Order;
import dto.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/history")
public class HistoryController extends HttpServlet {
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

        String action = request.getParameter("action");
        if ("detail".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("id"));
                Order order = orderDAO.getOrderById(orderId, user.getUserId());
                if (order == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
                    return;
                }
                
                java.util.List<dto.OrderItem> orderItems = orderDAO.getOrderItemsByOrderId(orderId);
                dao.ReviewDAO reviewDAO = new dao.ReviewDAO();
                java.util.Map<Integer, Boolean> reviewedMap = new java.util.HashMap<>();
                for (dto.OrderItem item : orderItems) {
                    boolean isReviewed = reviewDAO.hasUserReviewedProductInOrder(user.getUserId(), item.getProductId(), orderId);
                    reviewedMap.put(item.getProductId(), isReviewed);
                }
                
                request.setAttribute("order", order);
                request.setAttribute("orderItems", orderItems);
                request.setAttribute("reviewedMap", reviewedMap);
                request.getRequestDispatcher("/order-detail.jsp").forward(request, response);
                return;
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
        }

        List<Order> orders = orderDAO.getOrdersByUserId(user.getUserId());
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/order-history.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("cancel".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("id"));
                boolean success = orderDAO.cancelOrderTransaction(orderId, user.getUserId());
                if (success) {
                    session.setAttribute("message", "Đã hủy đơn hàng #" + orderId + " thành công và hoàn lại kho!");
                } else {
                    session.setAttribute("error", "Không thể hủy đơn hàng. Đơn hàng có thể đã được giao hoặc không tồn tại.");
                }
            } catch (Exception e) {
                session.setAttribute("error", "Lỗi: " + e.getMessage());
            }
        }
        response.sendRedirect(request.getContextPath() + "/history");
    }
}
