package filter;

import dto.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length()).replaceAll("[/]+$", "");

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        boolean loggedIn = (user != null);
        boolean isCartOrCheckout = path.equals("/cart.jsp") || path.equals("/cart") || path.equals("/checkout")
                || path.equals("/checkout.jsp") || path.equals("/history") || path.equals("/order-history.jsp");
        boolean isAdminPath = path.startsWith("/admin");

        if (isCartOrCheckout && !loggedIn) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Vui+long+dang+nhap+de+mua+hang");
            return;
        }

        if (isAdminPath) {
            if (!loggedIn) {
                res.sendRedirect(req.getContextPath() + "/login.jsp?error=Vui+long+dang+nhap");
                return;
            } else if (!"ADMIN".equals(user.getRole())) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
