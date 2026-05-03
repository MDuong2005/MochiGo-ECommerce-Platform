package dao;

import dto.Product;
import util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    public List<Product> getAllProducts() {
        return fetchProducts("SELECT product_id, category_id, name, description, price, stock, image_url, is_active, is_featured, discount_percent, created_at, is_deleted FROM products WHERE is_active = 1 AND is_deleted = 0 ORDER BY product_id DESC");
    }

    public List<Product> getFeaturedProducts() {
        return fetchProducts("SELECT product_id, category_id, name, description, price, stock, image_url, is_active, is_featured, discount_percent, created_at, is_deleted FROM products WHERE is_active = 1 AND is_featured = 1 AND is_deleted = 0 ORDER BY product_id DESC");
    }

    public List<Product> getAllProductsAdmin() {
        return fetchProducts("SELECT product_id, category_id, name, description, price, stock, image_url, is_active, is_featured, discount_percent, created_at, is_deleted FROM products WHERE is_deleted = 0 ORDER BY product_id DESC");
    }

    public List<Product> getProductsByCategory(int categoryId) {
        return fetchProducts("SELECT product_id, category_id, name, description, price, stock, image_url, is_active, is_featured, discount_percent, created_at, is_deleted FROM products WHERE is_active = 1 AND is_deleted = 0 AND category_id = " + categoryId + " ORDER BY product_id DESC");
    }

    public List<Product> getDiscountedProducts() {
        return fetchProducts("SELECT product_id, category_id, name, description, price, stock, image_url, is_active, is_featured, discount_percent, created_at, is_deleted FROM products WHERE is_active = 1 AND is_deleted = 0 AND discount_percent > 0 ORDER BY discount_percent DESC, product_id DESC");
    }

    public List<Product> searchProducts(String keyword) {
        String sql = "SELECT product_id, category_id, name, description, price, stock, image_url, is_active, is_featured, discount_percent, created_at, is_deleted FROM products WHERE is_active = 1 AND is_deleted = 0 AND name LIKE ? ORDER BY product_id DESC";
        List<Product> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToProduct(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Product getProductById(int productId) {
        String sql = "SELECT product_id, category_id, name, description, price, stock, image_url, is_active, is_featured, discount_percent, created_at, is_deleted FROM products WHERE product_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProduct(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertProduct(Product p) {
        String sql = "INSERT INTO products (category_id, name, description, price, stock, image_url, is_active, is_featured, discount_percent) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getCategoryId());
            ps.setString(2, p.getName());
            ps.setString(3, p.getDescription());
            ps.setBigDecimal(4, p.getPrice());
            ps.setInt(5, p.getStock());
            ps.setString(6, p.getImageUrl());
            ps.setBoolean(7, p.isActive());
            ps.setBoolean(8, p.isFeatured());
            ps.setInt(9, p.getDiscountPercent());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateProduct(Product p) {
        String sql = "UPDATE products SET category_id = ?, name = ?, description = ?, price = ?, stock = ?, image_url = ?, is_active = ?, is_featured = ?, discount_percent = ? WHERE product_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getCategoryId());
            ps.setString(2, p.getName());
            ps.setString(3, p.getDescription());
            ps.setBigDecimal(4, p.getPrice());
            ps.setInt(5, p.getStock());
            ps.setString(6, p.getImageUrl());
            ps.setBoolean(7, p.isActive());
            ps.setBoolean(8, p.isFeatured());
            ps.setInt(9, p.getDiscountPercent());
            ps.setInt(10, p.getProductId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteProduct(int productId) {
        String sql = "UPDATE products SET is_deleted = 1 WHERE product_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateProductCategory(int oldCategoryId, int newCategoryId) {
        String sql = "UPDATE products SET category_id = ? WHERE category_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newCategoryId);
            ps.setInt(2, oldCategoryId);
            return ps.executeUpdate() >= 0; // It's okay if 0 rows are updated
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean toggleProductStatus(int productId) {
        String sql = "UPDATE products SET is_active = CASE WHEN is_active = 1 THEN 0 ELSE 1 END WHERE product_id = ? AND is_deleted = 0";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private List<Product> fetchProducts(String sql) {
        List<Product> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private Product mapResultSetToProduct(ResultSet rs) throws Exception {
        Product p = new Product();
        p.setProductId(rs.getInt("product_id"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getBigDecimal("price"));
        p.setStock(rs.getInt("stock"));
        p.setImageUrl(rs.getString("image_url"));
        p.setActive(rs.getBoolean("is_active"));
        p.setFeatured(rs.getBoolean("is_featured"));
        p.setDiscountPercent(rs.getInt("discount_percent"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setDeleted(rs.getBoolean("is_deleted"));
        return p;
    }
}