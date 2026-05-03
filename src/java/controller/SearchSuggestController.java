package controller;

import dao.ProductDAO;
import dto.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/api/search-suggest")
public class SearchSuggestController extends HttpServlet {
    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        String keyword = request.getParameter("q");
        
        if (keyword == null || keyword.trim().isEmpty()) {
            response.getWriter().write("[]");
            return;
        }

        List<Product> products = productDAO.searchProducts(keyword.trim());
        
        // Limit to 5 suggestions
        if(products.size() > 5) {
            products = products.subList(0, 5);
        }

        PrintWriter out = response.getWriter();
        StringBuilder json = new StringBuilder();
        json.append("[");
        for (int i = 0; i < products.size(); i++) {
            Product p = products.get(i);
            json.append("{");
            json.append("\"id\": ").append(p.getProductId()).append(",");
            json.append("\"name\": \"").append(escapeJson(p.getName())).append("\",");
            json.append("\"price\": ").append(p.getPrice()).append(",");
            json.append("\"image\": \"").append(escapeJson(p.getImageUrl())).append("\"");
            json.append("}");
            if (i < products.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");
        
        out.write(json.toString());
    }
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
