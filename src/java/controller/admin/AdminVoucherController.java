package controller.admin;

import dao.VoucherDAO;
import dto.User;
import dto.Voucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(urlPatterns = {"/admin/vouchers", "/admin/voucher-status", "/admin/voucher-delete"})
public class AdminVoucherController extends HttpServlet {
    private VoucherDAO voucherDAO;

    @Override
    public void init() {
        voucherDAO = new VoucherDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Auth check
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        List<Voucher> vouchers = voucherDAO.getAllVouchers();
        
        // Filter logic
        String statusFilter = request.getParameter("status");
        if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("ALL")) {
            long now = System.currentTimeMillis();
            if ("HAPPENING".equals(statusFilter)) {
                vouchers = vouchers.stream()
                        .filter(v -> v.getStartDate().getTime() <= now && v.getEndDate().getTime() >= now)
                        .collect(Collectors.toList());
            } else if ("EXPIRED".equals(statusFilter)) {
                vouchers = vouchers.stream()
                        .filter(v -> v.getEndDate().getTime() < now)
                        .collect(Collectors.toList());
            } else if ("UPCOMING".equals(statusFilter)) {
                vouchers = vouchers.stream()
                        .filter(v -> v.getStartDate().getTime() > now)
                        .collect(Collectors.toList());
            }
        }

        request.setAttribute("vouchers", vouchers);
        request.setAttribute("statusFilter", statusFilter == null ? "ALL" : statusFilter);
        request.getRequestDispatcher("/admin/vouchers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        if ("/admin/voucher-status".equals(path)) {
            try {
                int voucherId = Integer.parseInt(request.getParameter("voucherId"));
                boolean isActive = Boolean.parseBoolean(request.getParameter("isActive"));
                voucherDAO.updateVoucherStatus(voucherId, isActive);
                response.getWriter().write("success");
            } catch (Exception e) {
                response.getWriter().write("error");
            }
        } else if ("/admin/voucher-delete".equals(path)) {
            try {
                int voucherId = Integer.parseInt(request.getParameter("voucherId"));
                voucherDAO.deleteVoucher(voucherId);
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/admin/vouchers");
        }
    }
}
