package controller;

import dao.WishlistDAO;
import dto.Product;
import dto.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/wishlist")
public class WishlistController extends HttpServlet {
    private WishlistDAO wishlistDAO;

    @Override
    public void init() {
        wishlistDAO = new WishlistDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            try {
                int productId = Integer.parseInt(request.getParameter("id"));
                wishlistDAO.addWishlist(user.getUserId(), productId);
            } catch (Exception e) {}
            String referer = request.getHeader("referer");
            response.sendRedirect(referer != null ? referer : request.getContextPath() + "/products");
        } else if ("remove".equals(action)) {
            try {
                int productId = Integer.parseInt(request.getParameter("id"));
                wishlistDAO.removeWishlist(user.getUserId(), productId);
            } catch (Exception e) {}
            String referer = request.getHeader("referer");
            response.sendRedirect(referer != null ? referer : request.getContextPath() + "/wishlist");
        } else {
            List<Product> wishlist = wishlistDAO.getWishlistByUserId(user.getUserId());
            request.setAttribute("wishlist", wishlist);
            
            // Also supply likedIds so the hearts can light up red inside the wishlist page if they want removing logic inline
            List<Integer> likedIds = wishlistDAO.getWishlistProductIds(user.getUserId());
            request.setAttribute("likedIds", likedIds);
            
            request.getRequestDispatcher("/wishlist.jsp").forward(request, response);
        }
    }
}
