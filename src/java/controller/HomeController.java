package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import dto.Category;
import dto.Product;
import dto.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/home", ""})
public class HomeController extends HttpServlet {
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Product> products = productDAO.getFeaturedProducts();
        List<Category> categories = categoryDAO.getAllCategories();
        
        // Just send a sublist if too many, to show on home
        if (products.size() > 8) {
            products = products.subList(0, 8);
        }

        request.setAttribute("featuredProducts", products);
        request.setAttribute("categories", categories);

        jakarta.servlet.http.HttpSession session = request.getSession();
        if (session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            List<Integer> likedIds = new dao.WishlistDAO().getWishlistProductIds(user.getUserId());
            request.setAttribute("likedIds", likedIds);
        }
        
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
