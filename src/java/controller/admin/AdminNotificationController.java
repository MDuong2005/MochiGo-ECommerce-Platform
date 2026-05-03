package controller.admin;

import dao.OrderDAO;
import dao.ReviewDAO;
import dto.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/notifications")
public class AdminNotificationController extends HttpServlet {
    private OrderDAO orderDAO;
    private ReviewDAO reviewDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
        reviewDAO = new ReviewDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");
        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        int pendingOrders = orderDAO.getPendingOrderCount();
        int unreadReviews = reviewDAO.getUnreadReviewCount();

        dto.Order latestOrder = orderDAO.getLatestPendingOrder();
        dto.Review latestReview = reviewDAO.getLatestUnreadReview();

        String latestOrderCustomer = latestOrder != null ? latestOrder.getReceiverName() : "";
        String latestReviewUser = latestReview != null ? latestReview.getUserName() : "";

        // Return JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"pendingOrders\": ").append(pendingOrders).append(", ");
        json.append("\"unreadReviews\": ").append(unreadReviews).append(", ");
        json.append("\"latestOrderCustomer\": \"").append(latestOrderCustomer.replace("\"", "\\\"")).append("\", ");
        json.append("\"latestReviewUser\": \"").append(latestReviewUser.replace("\"", "\\\"")).append("\"");
        json.append("}");

        response.getWriter().write(json.toString());
    }
}
