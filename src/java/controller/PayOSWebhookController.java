package controller;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.BufferedReader;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet("/api/payos-webhook")
public class PayOSWebhookController extends HttpServlet {
    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        StringBuilder sb = new StringBuilder();
        BufferedReader reader = request.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        String payload = sb.toString();
        
        System.out.println("PayOS Webhook Data received...");

        // Parse orderCode and code/status via regex
        Matcher codeMatcher = Pattern.compile("\"code\"\\s*:\\s*\"([^\"]+)\"").matcher(payload);
        Matcher orderCodeMatcher = Pattern.compile("\"orderCode\"\\s*:\\s*(\\d+)").matcher(payload);
        
        if (orderCodeMatcher.find()) {
            long paymentCode = Long.parseLong(orderCodeMatcher.group(1));
            int orderId = (int)(paymentCode / 1000);
            
            // In PayOS webhook, either code="00" or success=true means it's paid
            if ((codeMatcher.find() && "00".equals(codeMatcher.group(1))) || payload.contains("\"success\":true")) {
                orderDAO.updateOrderStatus(orderId, "PAID");
                System.out.println("PayOS Webhook: Order " + orderId + " updated to PAID (awaiting admin ship confirmation).");
            }
        }
        
        response.setContentType("application/json");
        response.getWriter().write("{\"success\":true}");
    }
}
