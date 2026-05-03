package controller;

import dao.UserDAO;
import dto.User;
import util.EmailUtil;
import util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Random;

@WebServlet("/forgot-password")
public class ForgotPasswordController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("reset".equals(action)) {
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("verify_otp".equals(action)) {
            // Bước 2: Kiểm tra OTP và lưu mật khẩu mới
            String inputOtp = request.getParameter("otp");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            String expectedOtp = (String) session.getAttribute("reset_otp");
            String email = (String) session.getAttribute("reset_email");
            Long otpTime = (Long) session.getAttribute("reset_time");

            if (email == null || expectedOtp == null || otpTime == null) {
                request.setAttribute("error", "Phiên thay đổi mật khẩu không hợp lệ. Vui lòng quay lại từ đầu.");
                request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
                return;
            }

            // Kiểm tra hết hạn 5 phút
            if (System.currentTimeMillis() - otpTime > 5 * 60 * 1000) {
                request.setAttribute("error", "Mã OTP đã hết hạn sau 5 phút. Vui lòng quay lại màn hình nhập Email để gửi lại mã mới.");
                request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
                return;
            }

            if (!inputOtp.equals(expectedOtp)) {
                request.setAttribute("error", "Mã OTP không chính xác. Vui lòng kiểm tra lại Email của bạn.");
                request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Hai mật khẩu đổi mới không khớp nhau. Vui lòng gõ cẩn thận.");
                request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
                return;
            }

            // OTP đúng -> tiến hành update DB
            User user = userDAO.findByEmail(email);
            if (user != null) {
                boolean updated = userDAO.updatePassword(user.getUserId(), PasswordUtil.hashPassword(newPassword));
                if (updated) {
                    session.removeAttribute("reset_otp");
                    session.removeAttribute("reset_email");
                    session.removeAttribute("reset_time");

                    request.setAttribute("success", "Lấy lại mật khẩu thành công! Bạn có thể Đăng nhập ngay.");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Đã xảy ra lỗi từ cơ sở dữ liệu. Vui lòng thử lại sau.");
                    request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
                }
            }

        } else {
            // Bước 1: Nhận Email, sinh OTP và gửi vào GMAIL
            String email = request.getParameter("email");
            if (email == null || email.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập Email.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            User user = userDAO.findByEmail(email);
            if (user != null) {
                // Tạo OTP ngẫu nhiên 6 số
                Random rnd = new Random();
                int number = rnd.nextInt(999999);
                String otpCode = String.format("%06d", number);

                // Gửi OTP vào Email khách qua Gmail SMTP API
                System.out.println("Dang gui Email OTP cho: " + email);
                boolean isSent = EmailUtil.sendOtpEmail(user.getEmail(), otpCode, user.getFullName());

                if (isSent) {
                    // Lưu OTP vào Session chờ verify
                    session.setAttribute("reset_otp", otpCode);
                    session.setAttribute("reset_email", email);
                    session.setAttribute("reset_time", System.currentTimeMillis());

                    // Đẩy sang trang nhập thiết lập Pass mới + OTP
                    response.sendRedirect(request.getContextPath() + "/forgot-password?action=reset");
                } else {
                    request.setAttribute("error", "Hệ thống MochiGo gửi mail thất bại. Vui lòng báo Admin kiểm tra mật khẩu ứng dụng EmailUtil.java!");
                    request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Email chưa được liên kết với tài khoản MochiGo nào.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            }
        }
    }
}
