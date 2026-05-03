package controller;

import dao.OrderDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import util.DBUtil;

@WebServlet("/api/payos-check")
public class PayOSCheckController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        String orderIdStr = request.getParameter("orderId");
        
        if (orderIdStr == null || orderIdStr.isEmpty()) {
            response.getWriter().write("{\"success\":false}");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            long paymentCode = Long.parseLong(orderIdStr + String.format("%03d", System.currentTimeMillis() % 1000)); // We can't know the exact paymentCode used earlier, so we must just check DB.
            response.getWriter().write("{\"success\":false, \"message\": \"Polling requires Webhook on server\"}");
            return;
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\":false}");
        }
    }
}
