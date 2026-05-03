package controller.admin;

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

@WebServlet("/admin/orders")
public class OrderAdminController extends HttpServlet {
    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        List<Order> orders = orderDAO.getAllOrders();
        for (Order o : orders) {
            o.setItems(orderDAO.getOrderItemsByOrderId(o.getOrderId()));
        }
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String action = request.getParameter("action");
        String orderIdStr = request.getParameter("orderId");

        if (action != null && orderIdStr != null) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                String newStatus = "PENDING";
                
                if ("approve".equals(action)) {
                    newStatus = "SHIPPING";
                    orderDAO.updateOrderStatus(orderId, newStatus);
                } else if ("complete".equals(action)) {
                    newStatus = "COMPLETED";
                    orderDAO.updateOrderStatus(orderId, newStatus);
                } else if ("cancel".equals(action)) {
                    newStatus = "CANCELLED";
                    orderDAO.updateOrderStatus(orderId, newStatus);
                } else if ("delete".equals(action)) {
                    orderDAO.deleteOrder(orderId);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}
