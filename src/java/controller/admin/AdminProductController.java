package controller.admin;

import dao.CategoryDAO;
import dao.ProductDAO;
import dto.Category;
import dto.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import jakarta.servlet.annotation.MultipartConfig;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.io.File;
import java.nio.file.Paths;

@WebServlet("/admin/products")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 1024 * 1024 * 10,  // 10MB
    maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class AdminProductController extends HttpServlet {
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
        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Product product = productDAO.getProductById(id);
            request.setAttribute("product", product);
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
        } else if ("new".equals(action)) {
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
        } else if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean success = productDAO.deleteProduct(id);
                if (success) {
                    request.getSession().setAttribute("message", "Xóa sản phẩm thành công!");
                } else {
                    request.getSession().setAttribute("error", "Không thể xóa sản phẩm này (có thể do ràng buộc dữ liệu).");
                }
            } catch (Exception e) {
                request.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/admin/products");
        } else if ("toggleStatus".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            productDAO.toggleProductStatus(id);
            response.sendRedirect(request.getContextPath() + "/admin/products");
        } else {
            List<Product> products = productDAO.getAllProductsAdmin(); // all products including inactive
            request.setAttribute("products", products);
            request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            Product p = new Product();
            p.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
            p.setName(request.getParameter("name"));
            p.setDescription(request.getParameter("description"));
            p.setPrice(new BigDecimal(request.getParameter("price")));
            p.setStock(Integer.parseInt(request.getParameter("stock")));
            p.setActive(request.getParameter("isActive") != null);
            p.setFeatured(request.getParameter("isFeatured") != null);
            
            String discountStr = request.getParameter("discountPercent");
            p.setDiscountPercent(discountStr != null && !discountStr.trim().isEmpty() ? Integer.parseInt(discountStr) : 0);
            
            // Handle Image Upload
            String imageUrl = request.getParameter("imageUrl"); // default to manual URL
            Part filePart = request.getPart("imageFile");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                // Avoid filename collisions by adding timestamp
                fileName = System.currentTimeMillis() + "_" + fileName;
                
                String uploadPath = getServletContext().getRealPath("/") + "images";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                
                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);
                imageUrl = "images/" + fileName;
                System.out.println("Image uploaded to: " + filePath);
            }
            p.setImageUrl(imageUrl);
            
            if ("update".equals(action)) {
                p.setProductId(Integer.parseInt(request.getParameter("productId")));
                productDAO.updateProduct(p);
            } else if ("insert".equals(action)) {
                productDAO.insertProduct(p);
            }
            response.sendRedirect(request.getContextPath() + "/admin/products");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input");
        }
    }
}
