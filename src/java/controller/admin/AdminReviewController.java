package controller.admin;

import dao.ReviewDAO;
import dto.Review;
import dto.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/reviews")
public class AdminReviewController extends HttpServlet {
    private ReviewDAO reviewDAO;

    @Override
    public void init() {
        reviewDAO = new ReviewDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");
        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Fetch all reviews
        List<Review> reviews = reviewDAO.getAllReviews();
        
        // Mark all as read when admin visits the page
        reviewDAO.markAllReviewsAsRead();

        request.setAttribute("reviews", reviews);
        request.getRequestDispatcher("/admin/reviews.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");
        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            try {
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                boolean success = reviewDAO.deleteReview(reviewId);
                if (success) {
                    session.setAttribute("message", "Đã xóa đánh giá thành công.");
                } else {
                    session.setAttribute("error", "Lỗi: Không thể xóa đánh giá.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Lỗi: ID đánh giá không hợp lệ.");
            }
        }
        
        // Redirect back to reviews page
        response.sendRedirect(request.getContextPath() + "/admin/reviews");
    }
}
