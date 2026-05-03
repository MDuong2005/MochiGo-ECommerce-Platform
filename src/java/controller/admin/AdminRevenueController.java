package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import dao.OrderDAO;

@WebServlet("/admin/revenue")
public class AdminRevenueController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        OrderDAO orderDAO = new OrderDAO();
        
        java.util.Calendar cal = java.util.Calendar.getInstance();
        int currentYear = cal.get(java.util.Calendar.YEAR);
        
        request.setAttribute("monthlyRevenue", orderDAO.getMonthlyRevenueForYear(currentYear));
        request.setAttribute("currentYear", currentYear);
        
        request.getRequestDispatcher("/admin/revenue_report.jsp").forward(request, response);
    }
}
