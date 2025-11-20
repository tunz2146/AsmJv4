package poly.servlet.auth;

import poly.entity.User;
import poly.service.AuthService;
import poly.service.EmailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.regex.Pattern;

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private AuthService authService = new AuthService();
    private EmailService emailService = new EmailService();
    
    // Regex patterns
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
        req.getRequestDispatcher("/views/registration.jsp").forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
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
        
        // Validate empty fields
        if (username.isEmpty() || password.isEmpty() || 
            fullname.isEmpty() || email.isEmpty()) {
            setErrorAndForward(req, resp, "Vui lòng điền đầy đủ thông tin!");
            return;
        }
        
        // Validate username format
        if (!USERNAME_PATTERN.matcher(username).matches()) {
            setErrorAndForward(req, resp, 
                "Tên đăng nhập phải từ 3-20 ký tự, chỉ chứa chữ, số, dấu gạch dưới và gạch ngang!");
            return;
        }
        
        // Validate fullname length
        if (fullname.length() < 2 || fullname.length() > 50) {
            setErrorAndForward(req, resp, "Họ tên phải từ 2-50 ký tự!");
            return;
        }
        
        // Validate email format
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            setErrorAndForward(req, resp, "Email không hợp lệ!");
            return;
        }
        
        // Validate password match
        if (!password.equals(confirmPassword)) {
            setErrorAndForward(req, resp, "Mật khẩu xác nhận không khớp!");
            return;
        }
        
        // Validate password strength
        if (!PASSWORD_PATTERN.matcher(password).matches()) {
            setErrorAndForward(req, resp, 
                "Mật khẩu phải có ít nhất 6 ký tự, bao gồm chữ hoa, chữ thường và số!");
            return;
        }
        
        // Check if username exists
        if (authService.isUsernameExists(username)) {
            setErrorAndForward(req, resp, "Tên đăng nhập đã tồn tại!");
            return;
        }
        
        // Check if email exists
        if (authService.isEmailExists(email)) {
            setErrorAndForward(req, resp, "Email đã được sử dụng!");
            return;
        }
        
        try {
            // Hash password
            String hashedPassword = hashPassword(password);
            
            // Tạo user mới
            User newUser = new User();
            newUser.setUsername(username);
            newUser.setPassword(hashedPassword);
            newUser.setFullname(fullname);
            newUser.setEmail(email);
            newUser.setAdmin(false);
            // newUser.setActive(true);
            
            // Lưu vào database
            boolean success = authService.register(newUser);
            
            if (success) {
                // Gửi email chào mừng (không block nếu fail)
                try {
                    emailService.sendWelcomeEmail(email, fullname);
                } catch (Exception emailEx) {
                    // Log lỗi nhưng không ảnh hưởng đến đăng ký
                    System.err.println("Failed to send welcome email: " + emailEx.getMessage());
                }
                
                // Redirect về login với thông báo thành công
                resp.sendRedirect(req.getContextPath() + "/login?message=register_success");
            } else {
                setErrorAndForward(req, resp, "Đăng ký thất bại! Vui lòng thử lại.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            setErrorAndForward(req, resp, "Có lỗi xảy ra: " + e.getMessage());
        }
    }
    
    /**
     * Hash password sử dụng SHA-256
     * @param password Password gốc
     * @return Password đã hash
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
     * Helper method để set error và forward
     */
    private void setErrorAndForward(HttpServletRequest req, HttpServletResponse resp, 
                                    String errorMessage) throws ServletException, IOException {
        req.setAttribute("error", errorMessage);
        
        // Giữ lại các giá trị đã nhập (trừ password)
        req.setAttribute("username", req.getParameter("username"));
        req.setAttribute("fullname", req.getParameter("fullname"));
        req.setAttribute("email", req.getParameter("email"));
        
        req.getRequestDispatcher("/views/registration.jsp").forward(req, resp);
    }
}