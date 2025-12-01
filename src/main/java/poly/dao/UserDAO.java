// File: src/main/java/poly/dao/UserDAO.java
package poly.dao;

import poly.entity.User;
import java.util.List;

public interface UserDAO {
    
    // ==================== CRUD CƠ BẢN ====================
    
    /**
     * Lấy tất cả users
     */
    List<User> findAll();
    
    /**
     * Tìm user theo ID (username)
     */
    User findById(String id);
    
    /**
     * Tạo user mới
     */
    void create(User user);
    
    /**
     * Cập nhật user
     */
    void update(User user);
    
    /**
     * Xóa user theo ID
     */
    void deleteById(String id);
    
    // ==================== SEARCH & FILTER ====================
    
    /**
     * Tìm user theo email
     */
    User findByEmail(String email);
    
    /**
     * Lấy users với phân trang
     */
    List<User> findWithPagination(int page, int size);
    
    /**
     * Đếm tổng số users
     */
    int countAll();
}