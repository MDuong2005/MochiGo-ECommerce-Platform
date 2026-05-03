package controller;

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

@WebServlet("/review")
public class ReviewController extends HttpServlet {
    private ReviewDAO reviewDAO;

    @Override
    public void init() {
        reviewDAO = new ReviewDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            if (rating < 1 || rating > 5) rating = 5;

            // Check if already reviewed
            if (!reviewDAO.hasUserReviewedProductInOrder(user.getUserId(), productId, orderId)) {
                Review r = new Review();
                r.setProductId(productId);
                r.setOrderId(orderId);
                r.setUserId(user.getUserId());
                r.setRating(rating);
                r.setComment(comment);
                
                reviewDAO.addReview(r);
                session.setAttribute("successMessage", "Cảm ơn bạn đã đánh giá sản phẩm!");
            } else {
                session.setAttribute("errorMessage", "Bạn đã đánh giá sản phẩm này trong đơn hàng này rồi.");
            }
            
            response.sendRedirect(request.getContextPath() + "/history?action=detail&id=" + orderId);
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Đã xảy ra lỗi khi gửi đánh giá.");
            response.sendRedirect(request.getContextPath() + "/history");
        }
    }
}
