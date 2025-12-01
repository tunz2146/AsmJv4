package poly.servlet.auth;

import poly.entity.User;
import poly.dao.UserDAO;
import poly.daoimpl.UserDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.regex.Pattern;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDAO userDAO = new UserDAOImpl();
    
    // Password pattern: ít nhất 6 ký tự, có chữ hoa, chữ thường, số
    private static final Pattern PASSWORD_PATTERN = Pattern.compile(
        "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,}$"
    );
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // Kiểm tra đã đăng nhập chưa
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login?message=required");
            return;
        }
        
        // Hiển thị trang đổi mật khẩu
        req.getRequestDispatcher("/views/auth/change-password.jsp").forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // Set encoding
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        
        // Kiểm tra đã đăng nhập chưa
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login?message=required");
            return;
        }
        
        User currentUser = (User) session.getAttribute("currentUser");
        
        // Lấy dữ liệu từ form
        String currentPassword = req.getParameter("currentPassword");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");
        
        // Trim inputs
        currentPassword = (currentPassword != null) ? currentPassword.trim() : "";
        newPassword = (newPassword != null) ? newPassword.trim() : "";
        confirmPassword = (confirmPassword != null) ? confirmPassword.trim() : "";
        
        // ========== VALIDATION ==========
        
        // 1. Kiểm tra trống
        if (currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            req.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            req.getRequestDispatcher("/views/auth/change-password.jsp").forward(req, resp);
            return;
        }
        
        // 2. Kiểm tra mật khẩu hiện tại
        if (!currentPassword.equals(currentUser.getPassword())) {
            req.setAttribute("error", "Mật khẩu hiện tại không đúng!");
            req.getRequestDispatcher("/views/auth/change-password.jsp").forward(req, resp);
            return;
        }
        
        // 3. Kiểm tra mật khẩu mới không trùng mật khẩu cũ
        if (newPassword.equals(currentPassword)) {
            req.setAttribute("error", "Mật khẩu mới phải khác mật khẩu hiện tại!");
            req.getRequestDispatcher("/views/auth/change-password.jsp").forward(req, resp);
            return;
        }
        
        // 4. Validate password match
        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            req.getRequestDispatcher("/views/auth/change-password.jsp").forward(req, resp);
            return;
        }
        
        // 5. Validate password strength
        if (!PASSWORD_PATTERN.matcher(newPassword).matches()) {
            req.setAttribute("error", 
                "Mật khẩu phải có ít nhất 6 ký tự, bao gồm chữ hoa, chữ thường và số!");
            req.getRequestDispatcher("/views/auth/change-password.jsp").forward(req, resp);
            return;
        }
        
        try {
            // ========== ĐỔI MẬT KHẨU ==========
            
            // Lấy user mới nhất từ database
            User userToUpdate = userDAO.findById(currentUser.getId());
            
            if (userToUpdate == null) {
                req.setAttribute("error", "Không tìm thấy thông tin người dùng!");
                req.getRequestDispatcher("/views/auth/change-password.jsp").forward(req, resp);
                return;
            }
            
            // Cập nhật mật khẩu mới
            userToUpdate.setPassword(newPassword);
            
            // Lưu vào database
            userDAO.update(userToUpdate);
            
            // Cập nhật lại session
            session.setAttribute("currentUser", userToUpdate);
            
            // ========== THÀNH CÔNG ==========
            
            System.out.println("✅ Đổi mật khẩu thành công: " + currentUser.getId());
            
            req.setAttribute("message", "Đổi mật khẩu thành công!");
            req.getRequestDispatcher("/views/auth/change-password.jsp").forward(req, resp);
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            req.getRequestDispatcher("/views/auth/change-password.jsp").forward(req, resp);
        }
    }
}