package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import dao.OrderDAO;
import dao.ReviewDAO;
import dto.Review;

@WebServlet("/admin/dashboard")
public class AdminDashboardController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        OrderDAO orderDAO = new OrderDAO();
        ReviewDAO reviewDAO = new ReviewDAO();
        
        request.setAttribute("totalRevenue", orderDAO.getTotalRevenue());
        request.setAttribute("reviews", reviewDAO.getAllReviews());
        
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
