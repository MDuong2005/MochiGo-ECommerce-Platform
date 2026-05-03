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
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/voucher-create")
public class AdminVoucherFormController extends HttpServlet {
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
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            try {
                int voucherId = Integer.parseInt(idStr);
                Voucher voucher = voucherDAO.getVoucherById(voucherId);
                request.setAttribute("voucher", voucher);
            } catch(Exception e) {}
        }
        request.getRequestDispatcher("/admin/voucher-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        try {
            Voucher voucher = new Voucher();
            
            String code = request.getParameter("code");
            if (code == null || code.trim().isEmpty()) {
                code = "VOUCHER" + System.currentTimeMillis(); // Auto generate if empty
            }
            voucher.setCode(code.toUpperCase());
            
            voucher.setDiscountType(request.getParameter("discountType"));
            voucher.setDiscountValue(new BigDecimal(request.getParameter("discountValue")));
            
            String minOrderStr = request.getParameter("minOrderValue");
            voucher.setMinOrderValue(minOrderStr != null && !minOrderStr.isEmpty() ? new BigDecimal(minOrderStr) : BigDecimal.ZERO);
            
            String maxDiscountStr = request.getParameter("maxDiscountValue");
            if ("PERCENT".equals(voucher.getDiscountType()) && maxDiscountStr != null && !maxDiscountStr.isEmpty()) {
                voucher.setMaxDiscountValue(new BigDecimal(maxDiscountStr));
            }
            
            voucher.setTotalQuantity(Integer.parseInt(request.getParameter("totalQuantity")));
            voucher.setMaxUsesPerUser(Integer.parseInt(request.getParameter("maxUsesPerUser")));
            voucher.setTargetType(request.getParameter("targetType"));
            
            String targetGroup = request.getParameter("targetGroup");
            if (targetGroup != null && !targetGroup.trim().isEmpty()) {
                voucher.setTargetGroup(targetGroup);
            }
            
            String startDateStr = request.getParameter("startDate").replace("T", " ") + ":00";
            String endDateStr = request.getParameter("endDate").replace("T", " ") + ":00";
            
            voucher.setStartDate(Timestamp.valueOf(startDateStr));
            voucher.setEndDate(Timestamp.valueOf(endDateStr));
            voucher.setActive(true);
            
            List<Integer> userIds = new ArrayList<>();
            if ("SPECIFIC_USER".equals(voucher.getTargetType())) {
                String[] selectedUsers = request.getParameterValues("selectedUsers");
                if (selectedUsers != null) {
                    for (String uid : selectedUsers) {
                        userIds.add(Integer.parseInt(uid));
                    }
                }
            }
            
            String voucherIdStr = request.getParameter("voucherId");
            boolean isUpdate = (voucherIdStr != null && !voucherIdStr.trim().isEmpty());
            
            if (isUpdate) {
                voucher.setVoucherId(Integer.parseInt(voucherIdStr));
            }
            
            boolean success;
            if (isUpdate) {
                success = voucherDAO.updateVoucher(voucher);
                // For simplicity, we skip updating target users for updates in this iteration, 
                // or you'd have to delete them and re-insert. 
            } else {
                success = voucherDAO.insertVoucher(voucher, userIds);
            }
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/vouchers?success=1");
            } else {
                request.setAttribute("error", "Lỗi lưu voucher. Có thể mã bị trùng.");
                request.getRequestDispatcher("/admin/voucher-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid input data: " + e.getMessage());
            request.getRequestDispatcher("/admin/voucher-form.jsp").forward(request, response);
        }
    }
}
