package controller;

import dao.ProductDAO;
import dao.VoucherDAO;
import dto.Product;
import dto.User;
import dto.Voucher;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/cart")
public class CartController extends HttpServlet {
    private ProductDAO productDAO;
    private VoucherDAO voucherDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        voucherDAO = new VoucherDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
        }

        List<CartItemView> cartItems = new ArrayList<>();
        double total = 0;

        for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
            Product p = productDAO.getProductById(entry.getKey());
            if (p != null) {
                CartItemView item = new CartItemView(p, entry.getValue());
                cartItems.add(item);
                total += p.getDiscountedPrice().doubleValue() * entry.getValue();
            }
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", total);
        
        // Re-validate voucher đang trong session — nếu hết hạn/hết lượt/đã dùng thì tự xóa
        Voucher sessionVoucher = (Voucher) session.getAttribute("appliedVoucher");
        if (sessionVoucher != null) {
            User vUser = (User) session.getAttribute("user");
            Voucher revalidated = (vUser != null)
                    ? voucherDAO.getValidVoucherByCodeForUser(sessionVoucher.getCode(), vUser.getUserId())
                    : null;
            if (revalidated == null) {
                session.removeAttribute("appliedVoucher");
                // Xác định lý do để thông báo rõ ràng
                Voucher freshInfo = voucherDAO.getVoucherByCodeRaw(sessionVoucher.getCode());
                if (freshInfo != null && freshInfo.isExpired()) {
                    session.setAttribute("couponMsg", "⚠️ Mã giảm giá \"" + sessionVoucher.getCode() + "\" đã hết hạn và bị gỡ khỏi đơn hàng.");
                } else if (freshInfo != null && freshInfo.isUsedUp()) {
                    session.setAttribute("couponMsg", "⚠️ Mã giảm giá \"" + sessionVoucher.getCode() + "\" đã hết lượt sử dụng và bị gỡ khỏi đơn hàng.");
                } else {
                    session.setAttribute("couponMsg", "⚠️ Mã giảm giá \"" + sessionVoucher.getCode() + "\" không còn hợp lệ và đã bị gỡ khỏi đơn hàng.");
                }
            }
        }
        
        // Fetch available vouchers
        User user = (User) session.getAttribute("user");
        List<Voucher> availableVouchers = voucherDAO.getVouchersForUser(user);
        request.setAttribute("availableVouchers", availableVouchers);
        
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            HttpSession session = request.getSession();
            Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
            if (cart == null) {
                cart = new HashMap<>();
            }

            if ("add".equals(action)) {
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                int currentQty = cart.getOrDefault(productId, 0);
                
                // Kiem tra ton kho (Check stock)
                Product p = productDAO.getProductById(productId);
                if (p != null && (currentQty + quantity) <= p.getStock()) {
                    cart.put(productId, currentQty + quantity);
                } else {
                    request.getSession().setAttribute("errorMsg", "Vượt quá số lượng tồn kho!");
                }
            } else if ("update".equals(action)) {
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                if (quantity > 0) {
                     Product p = productDAO.getProductById(productId);
                     if (p != null && quantity <= p.getStock()) {
                         cart.put(productId, quantity);
                     } else {
                         request.getSession().setAttribute("errorMsg", "Vượt quá số lượng tồn kho!");
                     }
                } else {
                    cart.remove(productId);
                }
            } else if ("remove".equals(action)) {
                cart.remove(productId);
            }

            session.setAttribute("cart", cart);
            
            if ("add".equals(action)) {
                String referer = request.getHeader("Referer");
                if (referer != null && !referer.contains("/cart")) {
                    session.setAttribute("successMsg", "Đã thêm sản phẩm vào giỏ hàng!");
                    response.sendRedirect(referer);
                    return;
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/cart");
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input");
        }
    }

    // A helper class to pass info to JSP
    public static class CartItemView {
        private Product product;
        private int quantity;

        public CartItemView(Product product, int quantity) {
            this.product = product;
            this.quantity = quantity;
        }

        public Product getProduct() { return product; }
        public int getQuantity() { return quantity; }
        public double getLineTotal() { return product.getDiscountedPrice().doubleValue() * quantity; }
    }
}
