package poly.servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import poly.dao.UserDAO;
import poly.daoimpl.UserDAOImpl;
import poly.entity.User;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.List;
import java.util.regex.Pattern;

@WebServlet("/admin/users")
public class UserManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDAO userDAO = new UserDAOImpl();
    
    // Regex patterns for validation
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
        "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$"
    );
    private static final Pattern USERNAME_PATTERN = Pattern.compile(
        "^[a-zA-Z0-9_-]{3,20}$"
    );
    private static final Pattern PASSWORD_PATTERN = Pattern.compile(
        "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,}$"
    );
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // Kiểm tra quyền admin
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        if (currentUser == null || !currentUser.getAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        
        try {
            String action = req.getParameter("action");
            
            // Xử lý edit mode
            if ("edit".equals(action)) {
                String userId = req.getParameter("id");
                if (userId != null && !userId.isEmpty()) {
                    User user = userDAO.findById(userId);
                    if (user != null) {
                        req.setAttribute("user", user);
                        req.setAttribute("mode", "edit");
                    } else {
                        req.setAttribute("error", "Không tìm thấy user!");
                    }
                }
            }
            
            // Lấy tham số phân trang
            String pageParam = req.getParameter("page");
            int currentPage = 1;
            if (pageParam != null) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            int pageSize = 10; // 10 users mỗi trang
            
            // Lấy danh sách users
            List<User> users = userDAO.findWithPagination(currentPage, pageSize);
            int totalUsers = userDAO.countAll();
            int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
            
            // Set attributes
            req.setAttribute("users", users);
            req.setAttribute("currentPage", currentPage);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalUsers", totalUsers);
            
            // Forward to JSP
            req.getRequestDispatcher("/views/admin/user-management.jsp").forward(req, resp);
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi tải danh sách users: " + e.getMessage());
            req.getRequestDispatcher("/views/admin/user-management.jsp").forward(req, resp);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // Kiểm tra quyền admin
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        if (currentUser == null || !currentUser.getAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        
        String action = req.getParameter("action");
        
        try {
            switch (action) {
                case "create":
                    handleCreate(req, resp);
                    break;
                case "update":
                    handleUpdate(req, resp);
                    break;
                case "delete":
                    handleDelete(req, resp);
                    break;
                case "reset":
                    resp.sendRedirect(req.getContextPath() + "/admin/users");
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/admin/users");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            doGet(req, resp);
        }
    }
    
    /**
     * Xử lý tạo user mới
     */
    private void handleCreate(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // Lấy dữ liệu từ form
        String id = req.getParameter("id");
        String password = req.getParameter("password");
        String fullname = req.getParameter("fullname");
        String email = req.getParameter("email");
        String adminStr = req.getParameter("admin");
        
        // Trim inputs
        id = (id != null) ? id.trim() : "";
        password = (password != null) ? password.trim() : "";
        fullname = (fullname != null) ? fullname.trim() : "";
        email = (email != null) ? email.trim() : "";
        
        // Validate
        String errorMsg = validateUserInput(id, password, fullname, email, true);
        if (errorMsg != null) {
            req.setAttribute("error", errorMsg);
            req.setAttribute("user", createUserFromParams(req));
            doGet(req, resp);
            return;
        }
        
        // Kiểm tra username đã tồn tại
        if (userDAO.findById(id) != null) {
            req.setAttribute("error", "Username đã tồn tại!");
            req.setAttribute("user", createUserFromParams(req));
            doGet(req, resp);
            return;
        }
        
        // Kiểm tra email đã tồn tại
        if (userDAO.findByEmail(email) != null) {
            req.setAttribute("error", "Email đã được sử dụng!");
            req.setAttribute("user", createUserFromParams(req));
            doGet(req, resp);
            return;
        }
        
        try {
            // Hash password
            String hashedPassword = hashPassword(password);
            
            // Tạo user mới
            User user = new User();
            user.setId(id);
            user.setPassword(hashedPassword);
            user.setFullname(fullname);
            user.setEmail(email);
            user.setAdmin("on".equals(adminStr));
            
            // Lưu vào database
            userDAO.create(user);
            
            // Redirect với thông báo thành công
            resp.sendRedirect(req.getContextPath() + "/admin/users?success=create");
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi tạo user: " + e.getMessage());
            req.setAttribute("user", createUserFromParams(req));
            doGet(req, resp);
        }
    }
    
    /**
     * Xử lý cập nhật user
     */
    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String id = req.getParameter("id");
        String password = req.getParameter("password");
        String fullname = req.getParameter("fullname");
        String email = req.getParameter("email");
        String adminStr = req.getParameter("admin");
        
        // Trim
        id = (id != null) ? id.trim() : "";
        password = (password != null) ? password.trim() : "";
        fullname = (fullname != null) ? fullname.trim() : "";
        email = (email != null) ? email.trim() : "";
        
        // Validate (password optional khi update)
        String errorMsg = validateUserInput(id, password, fullname, email, false);
        if (errorMsg != null) {
            req.setAttribute("error", errorMsg);
            req.setAttribute("user", createUserFromParams(req));
            req.setAttribute("mode", "edit");
            doGet(req, resp);
            return;
        }
        
        try {
            // Tìm user hiện tại
            User user = userDAO.findById(id);
            if (user == null) {
                req.setAttribute("error", "Không tìm thấy user!");
                doGet(req, resp);
                return;
            }
            
            // Kiểm tra email trùng (trừ email của chính user này)
            User existingUser = userDAO.findByEmail(email);
            if (existingUser != null && !existingUser.getId().equals(id)) {
                req.setAttribute("error", "Email đã được sử dụng bởi user khác!");
                req.setAttribute("user", createUserFromParams(req));
                req.setAttribute("mode", "edit");
                doGet(req, resp);
                return;
            }
            
            // Update thông tin
            user.setFullname(fullname);
            user.setEmail(email);
            user.setAdmin("on".equals(adminStr));
            
            // Chỉ update password nếu nhập mới
            if (password != null && !password.isEmpty()) {
                String hashedPassword = hashPassword(password);
                user.setPassword(hashedPassword);
            }
            
            // Lưu vào database
            userDAO.update(user);
            
            // Redirect với thông báo thành công
            resp.sendRedirect(req.getContextPath() + "/admin/users?success=update");
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi cập nhật user: " + e.getMessage());
            req.setAttribute("user", createUserFromParams(req));
            req.setAttribute("mode", "edit");
            doGet(req, resp);
        }
    }
    
    /**
     * Xử lý xóa user
     */
    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String id = req.getParameter("id");
        
        try {
            // Không cho phép xóa chính mình
            User currentUser = (User) req.getSession().getAttribute("currentUser");
            if (currentUser.getId().equals(id)) {
                req.setAttribute("error", "Không thể xóa tài khoản đang đăng nhập!");
                doGet(req, resp);
                return;
            }
            
            // Xóa user
            userDAO.deleteById(id);
            
            // Redirect với thông báo thành công
            resp.sendRedirect(req.getContextPath() + "/admin/users?success=delete");
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi xóa user: " + e.getMessage());
            doGet(req, resp);
        }
    }
    
    /**
     * Validate user input
     */
    private String validateUserInput(String id, String password, String fullname, 
                                     String email, boolean isCreate) {
        
        // Validate empty fields
        if (id.isEmpty() || fullname.isEmpty() || email.isEmpty()) {
            return "Vui lòng điền đầy đủ thông tin!";
        }
        
        // Validate password (required khi create)
        if (isCreate && password.isEmpty()) {
            return "Vui lòng nhập mật khẩu!";
        }
        
        // Validate username format
        if (!USERNAME_PATTERN.matcher(id).matches()) {
            return "Username phải từ 3-20 ký tự, chỉ chữ, số, dấu gạch dưới và gạch ngang!";
        }
        
        // Validate fullname length
        if (fullname.length() < 2 || fullname.length() > 50) {
            return "Họ tên phải từ 2-50 ký tự!";
        }
        
        // Validate email format
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            return "Email không hợp lệ!";
        }
        
        // Validate password strength (nếu có nhập)
        if (!password.isEmpty() && !PASSWORD_PATTERN.matcher(password).matches()) {
            return "Mật khẩu phải có ít nhất 6 ký tự, bao gồm chữ hoa, chữ thường và số!";
        }
        
        return null; // No error
    }
    
    /**
     * Hash password using SHA-256
     */
    private String hashPassword(String password) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes());
        StringBuilder hexString = new StringBuilder();
        
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }
        
        return hexString.toString();
    }
    
    /**
     * Tạo User object từ request parameters (để giữ lại dữ liệu khi có lỗi)
     */
    private User createUserFromParams(HttpServletRequest req) {
        User user = new User();
        user.setId(req.getParameter("id"));
        user.setFullname(req.getParameter("fullname"));
        user.setEmail(req.getParameter("email"));
        user.setAdmin("on".equals(req.getParameter("admin")));
        return user;
    }
}