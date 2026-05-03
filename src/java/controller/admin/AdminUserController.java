package controller.admin;

import dao.UserDAO;
import dto.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/users", "/admin/user-status", "/admin/user-role", "/admin/user-delete"})
public class AdminUserController extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");
        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");
        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String path = request.getServletPath();
        try {
            int targetUserId = Integer.parseInt(request.getParameter("userId"));
            
            // Prevent admin from changing their own role/status from here to avoid locking themselves out completely
            if (targetUserId == admin.getUserId()) {
                response.getWriter().write("error_self");
                return;
            }

            if ("/admin/user-status".equals(path)) {
                boolean isActive = Boolean.parseBoolean(request.getParameter("isActive"));
                boolean success = userDAO.updateUserStatus(targetUserId, isActive);
                if (success) {
                    response.getWriter().write("success");
                } else {
                    response.getWriter().write("error");
                }
            } else if ("/admin/user-role".equals(path)) {
                String role = request.getParameter("role");
                if ("ADMIN".equals(role) || "USER".equals(role)) {
                    boolean success = userDAO.updateUserRole(targetUserId, role);
                    if (success) {
                        response.sendRedirect(request.getContextPath() + "/admin/users?success=1");
                        return;
                    }
                }
                response.sendRedirect(request.getContextPath() + "/admin/users?error=1");
            } else if ("/admin/user-delete".equals(path)) {
                boolean success = userDAO.deleteUser(targetUserId);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/users?success_delete=1");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/users?error_delete=1");
                }
                return;
            }
        } catch (Exception e) {
            if ("/admin/user-status".equals(path)) {
                response.getWriter().write("error");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=1");
            }
        }
    }
}
