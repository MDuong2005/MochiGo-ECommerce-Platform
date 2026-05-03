package controller;

import dao.VoucherDAO;
import dto.Voucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/apply-coupon")
public class CouponController extends HttpServlet {
    private VoucherDAO voucherDAO = new VoucherDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("couponCode");
        String returnUrl = request.getParameter("returnUrl");
        if (returnUrl == null || returnUrl.isEmpty()) {
            returnUrl = request.getContextPath() + "/cart"; // changed to /cart
        }

        HttpSession session = request.getSession();
        
        if (code == null || code.trim().isEmpty()) {
            session.removeAttribute("appliedVoucher");
            session.setAttribute("couponMsg", "Đã hủy mã giảm giá hiện tại.");
            response.sendRedirect(returnUrl);
            return;
        }

        dto.User user = (dto.User) session.getAttribute("user");
        if (user == null) {
            session.removeAttribute("appliedVoucher");
            session.setAttribute("couponError", "Bạn cần đăng nhập để áp dụng mã giảm giá.");
            response.sendRedirect(returnUrl);
            return;
        }

        Voucher v = voucherDAO.getValidVoucherByCodeForUser(code.trim().toUpperCase(), user.getUserId());
        if (v != null) {
            session.setAttribute("appliedVoucher", v);
            session.setAttribute("couponSuccess", "Áp dụng mã " + v.getCode() + " thành công!");
        } else {
            session.removeAttribute("appliedVoucher");
            session.setAttribute("couponError", "Mã giảm giá không hợp lệ, không áp dụng cho bạn, hoặc đã hết hạn.");
        }
        response.sendRedirect(returnUrl);
    }
}
