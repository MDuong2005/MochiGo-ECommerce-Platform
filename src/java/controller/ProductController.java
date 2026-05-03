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

@WebServlet("/products")
public class ProductController extends HttpServlet {
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("detail".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Product product = productDAO.getProductById(id);
                if (product == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
                    return;
                }
                dao.ReviewDAO reviewDAO = new dao.ReviewDAO();
                request.setAttribute("reviews", reviewDAO.getReviewsByProduct(id));
                request.setAttribute("avgRating", reviewDAO.getAverageRating(id));
                request.setAttribute("totalReviews", reviewDAO.getTotalReviews(id));
                
                request.setAttribute("product", product);
                request.getRequestDispatcher("/product-detail.jsp").forward(request, response);
            } else {
                String categoryIdParams = request.getParameter("categoryId");
                String keyword = request.getParameter("search");
                List<Product> products;

                if (keyword != null && !keyword.trim().isEmpty()) {
                    products = productDAO.searchProducts(keyword);
                } else if ("sale".equals(action)) {
                    products = productDAO.getDiscountedProducts();
                    request.setAttribute("isSalePage", true);
                } else if (categoryIdParams != null && !categoryIdParams.trim().isEmpty()) {
                    int categoryId = Integer.parseInt(categoryIdParams);
                    products = productDAO.getProductsByCategory(categoryId);
                    request.setAttribute("currentCategory", categoryId);
                } else {
                    products = productDAO.getAllProducts();
                }

                List<Category> categories = categoryDAO.getAllCategories();

                request.setAttribute("products", products);
                request.setAttribute("categories", categories);

                jakarta.servlet.http.HttpSession session = request.getSession();
                if (session.getAttribute("user") != null) {
                    User user = (User) session.getAttribute("user");
                    List<Integer> likedIds = new dao.WishlistDAO().getWishlistProductIds(user.getUserId());
                    request.setAttribute("likedIds", likedIds);
                }

                request.getRequestDispatcher("/products.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid format");
        }
    }
}
