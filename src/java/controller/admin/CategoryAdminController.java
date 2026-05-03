package controller.admin;

import dao.CategoryDAO;
import dao.ProductDAO;
import dto.Category;
import dto.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/categories")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 1024 * 1024 * 10,  // 10MB
    maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class CategoryAdminController extends HttpServlet {
    private CategoryDAO categoryDAO;
    private ProductDAO productDAO;

    @Override
    public void init() {
        categoryDAO = new CategoryDAO();
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String action = request.getParameter("action");
        if ("edit".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Category category = categoryDAO.getCategoryById(id);
                if (category != null) {
                    request.setAttribute("category", category);
                    request.getRequestDispatcher("/admin/category-form.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/categories");
                }
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/admin/categories");
            }
        } else if ("new".equals(action)) {
            request.getRequestDispatcher("/admin/category-form.jsp").forward(request, response);
        } else {
            List<Category> categories = categoryDAO.getAllCategoriesAdmin();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/admin/categories.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("insert".equals(action) || "update".equals(action)) {
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                boolean isActive = request.getParameter("isActive") != null;

                Category category = new Category();
                category.setName(name);
                category.setDescription(description);
                category.setActive(isActive);

                // Handle Image Upload
                String imageUrl = request.getParameter("imageUrl");
                try {
                    Part filePart = request.getPart("imageFile");
                    if (filePart != null && filePart.getSize() > 0) {
                        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                        fileName = System.currentTimeMillis() + "_" + fileName;
                        
                        String uploadPath = getServletContext().getRealPath("/") + "images";
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) uploadDir.mkdir();
                        
                        String filePath = uploadPath + File.separator + fileName;
                        filePart.write(filePath);
                        imageUrl = "images/" + fileName;
                    }
                } catch (Exception e) {
                    System.err.println("Category image upload error: " + e.getMessage());
                }
                category.setImageUrl(imageUrl);

                if ("update".equals(action)) {
                    int id = Integer.parseInt(request.getParameter("categoryId"));
                    category.setCategoryId(id);
                    categoryDAO.updateCategory(category);
                } else {
                    categoryDAO.insertCategory(category);
                }
            } else if ("delete".equals(action)) {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    
                    // Reassign products to another category if any exist
                    List<Category> allCategories = categoryDAO.getAllCategoriesAdmin();
                    int targetCategoryId = -1;
                    for (Category c : allCategories) {
                        if (c.getCategoryId() != id && !c.isDeleted()) {
                            targetCategoryId = c.getCategoryId();
                            break;
                        }
                    }
                    
                    if (targetCategoryId != -1) {
                        productDAO.updateProductCategory(id, targetCategoryId);
                        boolean success = categoryDAO.deleteCategory(id);
                        if (success) {
                            session.setAttribute("message", "Xóa danh mục thành công! Các sản phẩm đã được chuyển sang danh mục khác.");
                        } else {
                            session.setAttribute("error", "Không thể xóa danh mục này.");
                        }
                    } else {
                        session.setAttribute("error", "Không thể xóa danh mục cuối cùng. Vui lòng tạo danh mục khác trước.");
                    }
                } catch (Exception e) {
                    session.setAttribute("error", "Lỗi: " + e.getMessage());
                }
            } else if ("toggleStatus".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                categoryDAO.toggleCategoryStatus(id);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }
}
