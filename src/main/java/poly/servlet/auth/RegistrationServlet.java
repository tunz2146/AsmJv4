package poly.servlet.auth;

import poly.entity.User;
import poly.dao.UserDAO;
import poly.daoimpl.UserDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.regex.Pattern;

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDAO userDAO = new UserDAOImpl();
    
    // Regex patterns cho validation
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
        // Hiển thị trang đăng ký
        req.getRequestDispatcher("/views/auth/registration.jsp").forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // Set encoding
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        
        // Lấy dữ liệu từ form
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String fullname = req.getParameter("fullname");
        String email = req.getParameter("email");
        
        // Trim all inputs
        username = (username != null) ? username.trim() : "";
        password = (password != null) ? password.trim() : "";
        confirmPassword = (confirmPassword != null) ? confirmPassword.trim() : "";
        fullname = (fullname != null) ? fullname.trim() : "";
        email = (email != null) ? email.trim() : "";
        
        // ========== VALIDATION ==========
        
        // 1. Kiểm tra trống
        if (username.isEmpty() || password.isEmpty() || 
            fullname.isEmpty() || email.isEmpty()) {
            setErrorAndForward(req, resp, "Vui lòng điền đầy đủ thông tin!", 
                username, fullname, email);
            return;
        }
        
        // 2. Validate username format
        if (!USERNAME_PATTERN.matcher(username).matches()) {
            setErrorAndForward(req, resp, 
                "Tên đăng nhập phải từ 3-20 ký tự, chỉ chứa chữ, số, gạch dưới và gạch ngang!", 
                username, fullname, email);
            return;
        }
        
        // 3. Validate fullname length
        if (fullname.length() < 2 || fullname.length() > 50) {
            setErrorAndForward(req, resp, 
                "Họ tên phải từ 2-50 ký tự!", 
                username, fullname, email);
            return;
        }
        
        // 4. Validate email format
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            setErrorAndForward(req, resp, 
                "Email không hợp lệ!", 
                username, fullname, email);
            return;
        }
        
        // 5. Validate password match
        if (!password.equals(confirmPassword)) {
            setErrorAndForward(req, resp, 
                "Mật khẩu xác nhận không khớp!", 
                username, fullname, email);
            return;
        }
        
        // 6. Validate password strength
        if (!PASSWORD_PATTERN.matcher(password).matches()) {
            setErrorAndForward(req, resp, 
                "Mật khẩu phải có ít nhất 6 ký tự, bao gồm chữ hoa, chữ thường và số!", 
                username, fullname, email);
            return;
        }
        
        // ========== KIỂM TRA TỒN TẠI ==========
        
        try {
            // 7. Kiểm tra username đã tồn tại
            User existingUser = userDAO.findById(username);
            if (existingUser != null) {
                setErrorAndForward(req, resp, 
                    "Tên đăng nhập đã tồn tại!", 
                    username, fullname, email);
                return;
            }
            
            // 8. Kiểm tra email đã tồn tại
            User existingEmail = userDAO.findByEmail(email);
            if (existingEmail != null) {
                setErrorAndForward(req, resp, 
                    "Email đã được sử dụng!", 
                    username, fullname, email);
                return;
            }
            
            // ========== TẠO USER MỚI ==========
            
            User newUser = new User();
            newUser.setId(username);
            newUser.setPassword(password);  // Lưu plain text (không hash)
            newUser.setFullname(fullname);
            newUser.setEmail(email);
            newUser.setAdmin(false);
            
            // Lưu vào database
            userDAO.create(newUser);
            
            // ========== THÀNH CÔNG ==========
            
            System.out.println("✅ Đăng ký thành công: " + username);
            
            // Redirect về login với thông báo thành công
            resp.sendRedirect(req.getContextPath() + "/login?message=register_success");
            
        } catch (Exception e) {
            e.printStackTrace();
            setErrorAndForward(req, resp, 
                "Có lỗi xảy ra: " + e.getMessage(), 
                username, fullname, email);
        }
    }
    
    /**
     * Helper method để set error và forward
     */
    private void setErrorAndForward(HttpServletRequest req, HttpServletResponse resp, 
                                    String errorMessage, String username, 
                                    String fullname, String email) 
            throws ServletException, IOException {
        
        req.setAttribute("error", errorMessage);
        
        // Giữ lại các giá trị đã nhập (trừ password)
        req.setAttribute("username", username);
        req.setAttribute("fullname", fullname);
        req.setAttribute("email", email);
        
        req.getRequestDispatcher("/views/auth/registration.jsp").forward(req, resp);
    }
}