package util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailUtil {

// Thiet lap email
    public static final String SENDER_EMAIL = "";
    public static final String SENDER_APP_PASSWORD = "";

    // Named inner class thay cho anonymous class - tránh lỗi EmailUtil$1
    private static class GmailAuth extends Authenticator {
        @Override
        protected PasswordAuthentication getPasswordAuthentication() {
            return new PasswordAuthentication(SENDER_EMAIL, SENDER_APP_PASSWORD);
        }
    }

    public static boolean sendOtpEmail(String toEmail, String otpCode, String userName) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new GmailAuth());

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL, "MochiGo Security"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));

            String subject = "MochiGo - Your OTP Code for Password Reset";
            String htmlContent = "<div style=\"font-family: Arial, sans-serif; max-width: 480px; margin: auto; padding: 24px;"
                    + " border: 1px solid #fbcfe8; border-radius: 10px; background-color: #fdf2f8;\">"
                    + "<h2 style=\"color: #db2777; text-align: center;\">MochiGo - Password Reset</h2>"
                    + "<p>Hello, <b>" + userName + "</b>!</p>"
                    + "<p>We received a request to reset your password. "
                    + "Use the OTP code below to continue. Do not share this code with anyone.</p>"
                    + "<div style=\"background-color: #fce7f3; text-align: center; font-size: 32px;"
                    + " font-weight: bold; letter-spacing: 8px; padding: 16px; border-radius: 8px;"
                    + " color: #be185d; margin: 20px 0;\">" + otpCode + "</div>"
                    + "<p style=\"color: #6b7280; font-size: 13px;\">This OTP will expire in <b>5 minutes</b>. "
                    + "Keep it confidential and do not share it with anyone.</p>"
                    + "<p style=\"color: #6b7280; font-size: 13px;\">If you did not request a password reset, please ignore this email.</p>"
                    + "<br><p>Best regards,<br><b>MochiGo Team</b></p>"
                    + "</div>";

            message.setSubject(subject, "UTF-8");
            message.setText(htmlContent, "UTF-8", "html");

            Transport.send(message);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
