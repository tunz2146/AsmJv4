// File: src/main/java/poly/service/AuthService.java
package poly.service;

import poly.dao.UserDAO;
import poly.daoimpl.UserDAOImpl;
import poly.entity.User;

/**
 * Service xử lý authentication
 */
public class AuthService {
    
    private UserDAO userDAO = new UserDAOImpl();
    
    /**
     * Xác thực user với username và password
     * @param username User ID
     * @param password Password
     * @return User object nếu đăng nhập thành công, null nếu thất bại
     */
    public User authenticate(String username, String password) {
        if (username == null || password == null || 
            username.trim().isEmpty() || password.trim().isEmpty()) {
            return null;
        }
        
        try {
            User user = userDAO.findById(username.trim());
            
            if (user != null && user.getPassword().equals(password)) {
                return user;
            }
            
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Kiểm tra user có phải admin không
     * @param user User object
     * @return true nếu là admin
     */
    public boolean isAdmin(User user) {
        return user != null && user.getAdmin() != null && user.getAdmin();
    }
    
    /**
     * Đổi password
     * @param userId User ID
     * @param oldPassword Password cũ
     * @param newPassword Password mới
     * @return true nếu đổi thành công
     */
    public boolean changePassword(String userId, String oldPassword, String newPassword) {
        try {
            User user = authenticate(userId, oldPassword);
            if (user != null) {
                user.setPassword(newPassword);
                userDAO.update(user);
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Đăng ký user mới
     * @param user User object
     * @return true nếu đăng ký thành công
     */
    public boolean register(User user) {
        try {
            userDAO.create(user);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Kiểm tra username đã tồn tại chưa
     * @param username Username cần kiểm tra
     * @return true nếu username đã tồn tại
     */
    public boolean isUsernameExists(String username) {
        try {
            User user = userDAO.findById(username);
            return user != null;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Kiểm tra email đã tồn tại chưa
     * @param email Email cần kiểm tra
     * @return true nếu email đã tồn tại
     */
    public boolean isEmailExists(String email) {
        try {
            User user = userDAO.findByEmail(email);
            return user != null;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}