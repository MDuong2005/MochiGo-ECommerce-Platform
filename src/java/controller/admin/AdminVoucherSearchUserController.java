package controller.admin;

import dao.VoucherDAO;
import dto.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/admin/voucher-search-users")
public class AdminVoucherSearchUserController extends HttpServlet {
    private VoucherDAO voucherDAO;

    @Override
    public void init() {
        voucherDAO = new VoucherDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String keyword = request.getParameter("q");
        if (keyword == null) keyword = "";
        
        List<User> users = voucherDAO.searchUsers(keyword);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < users.size(); i++) {
            User u = users.get(i);
            json.append("{")
                .append("\"id\": ").append(u.getUserId()).append(", ")
                .append("\"text\": \"").append(u.getEmail()).append(" - ").append(u.getFullName()).append("\"")
                .append("}");
            if (i < users.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");
        out.write(json.toString());
    }
}
