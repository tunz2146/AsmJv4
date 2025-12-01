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
    
    private UserDAO userDAO;
    
    // Password pattern: ít nhất 6 ký tự, có chữ hoa, chữ thường và số
    private static final Pattern PASSWORD_PATTERN = Pattern.compile(
        "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,}$"
    );
    
    @Override
    public void init() throws ServletException {
        super.init();
        try {
            userDAO = new UserDAOImpl();
            System.out.println("✅ ChangePasswordServlet initialized successfully");
        } catch (Exception e) {
            System.err.println("❌ Error initializing ChangePasswordServlet: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        try {
            // Kiểm tra đăng nhập
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("currentUser") == null) {
                System.out.println("⚠️ User not logged in, redirecting to login");
                resp.sendRedirect(req.getContextPath() + "/login?message=required");
                return;
            }
            
            User currentUser = (User) session.getAttribute("currentUser");
            System.out.println("✅ ChangePassword GET: User = " + currentUser.getId());
            
            // Hiển thị trang đổi mật khẩu
            req.getRequestDispatcher("/views/auth/change-password.jsp").forward(req, resp);
            
        } catch (Exception e) {
            System.err.println("❌ Error in ChangePasswordServlet.doGet: " + e.getMessage());
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Có lỗi xảy ra: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        try {
            // Set encoding
            req.setCharacterEncoding("UTF-8");
            resp.setCharacterEncoding("UTF-8");
            
            // Kiểm tra đăng nhập
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("currentUser") == null) {
                System.out.println("⚠️ User not logged in (POST), redirecting to login");
                resp.sendRedirect(req.getContextPath() + "/login?message=required");
                return;
            }
            
            User currentUser = (User) session.getAttribute("currentUser");
            System.out.println("✅ ChangePassword POST: User = " + currentUser.getId());
            
            // Lấy dữ liệu từ form
            String currentPassword = req.getParameter("currentPassword");
            String newPassword = req.getParameter("newPassword");
            String confirmPassword = req.getParameter("confirmPassword");
            
            System.out.println("🔑 Current password provided: " + (currentPassword != null && !currentPassword.isEmpty()));
            System.out.println("🔑 New password provided: " + (newPassword != null && !newPassword.isEmpty()));
            
            // Trim inputs
            currentPassword = (currentPassword != null) ? currentPassword.trim() : "";
            newPassword = (newPassword != null) ? newPassword.trim() : "";
            confirmPassword = (confirmPassword != null) ? confirmPassword.trim() : "";
            
            // ========== VALIDATION ==========
            
            // 1. Kiểm tra trống
            if (currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
                System.out.println("⚠️ Empty password fields");
                req.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
                req.getRequestDispatcher("/views/auth/change-password.jsp").forward(req, resp);
                return;
            }
            
            // 2. Kiểm tra mật khẩu hiện tại đúng không
            if (!currentUser.getPassword().equals(currentPassword)) {
                System.out.println("⚠️ Current password incorrect");
                req.setAttribute("error", "Mật khẩu hiện tại không đúng!");
                req.getRequestDispatcher("/views/auth/change-password.jsp").forward(req, resp);
                return;
            }
            
            // 3. Kiểm tra mật khẩu mới khớp
            if (!newPassword.equals(confirmPassword)) {
                System.out.println("⚠️ New passwords don't match");
                req.setAttribute("error", "Mật khẩu mới không khớp!");
                req.getRequestDispatcher("/views/auth/change-password.jsp").forward(req, resp);
                return;
            }
            
            // 4. Validate mật khẩu mới
            if (!PASSWORD_PATTERN.matcher(newPassword).matches()) {
                System.out.println("⚠️ New password doesn't meet requirements");
                req.setAttribute("error", 
                    "Mật khẩu mới phải có ít nhất 6 ký tự, bao gồm chữ hoa, chữ thường và số!");
                req.getRequestDispatcher("/views/auth/change-password.jsp").forward(req, resp);
                return;
            }
            
            // 5. Kiểm tra mật khẩu mới khác mật khẩu cũ
            if (newPassword.equals(currentPassword)) {
                System.out.println("⚠️ New password same as current");
                req.setAttribute("error", "Mật khẩu mới phải khác mật khẩu hiện tại!");
                req.getRequestDispatcher("/views/auth/change-password.jsp").forward(req, resp);
                return;
            }
            
            // ========== ĐỔI MẬT KHẨU ==========
            
            if (userDAO == null) {
                System.err.println("❌ userDAO is null!");
                req.setAttribute("error", "Lỗi hệ thống: UserDAO chưa khởi tạo!");
                req.getRequestDispatcher("/views/auth/change-password.jsp").forward(req, resp);
                return;
            }
            
            currentUser.setPassword(newPassword);
            userDAO.update(currentUser);
            
            // Cập nhật session
            session.setAttribute("currentUser", currentUser);
            
            System.out.println("✅ Đổi mật khẩu thành công: " + currentUser.getId());
            
            // Thông báo thành công
            req.setAttribute("message", "Đổi mật khẩu thành công!");
            req.getRequestDispatcher("/views/auth/change-password.jsp").forward(req, resp);
            
        } catch (Exception e) {
            System.err.println("❌ Error in ChangePasswordServlet.doPost: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            try {
                req.getRequestDispatcher("/views/auth/change-password.jsp").forward(req, resp);
            } catch (Exception ex) {
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                    "Lỗi nghiêm trọng: " + ex.getMessage());
            }
        }
    }
}