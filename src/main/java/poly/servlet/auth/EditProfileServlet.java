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

@WebServlet("/profile")
public class EditProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDAO userDAO;
    
    // Email validation pattern
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
        "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$"
    );
    
    @Override
    public void init() throws ServletException {
        super.init();
        try {
            userDAO = new UserDAOImpl();
            System.out.println("✅ EditProfileServlet initialized successfully");
        } catch (Exception e) {
            System.err.println("❌ Error initializing EditProfileServlet: " + e.getMessage());
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
            System.out.println("✅ EditProfile GET: User = " + currentUser.getId());
            
            // Hiển thị trang cập nhật thông tin
            req.getRequestDispatcher("/views/auth/edit-profile.jsp").forward(req, resp);
            
        } catch (Exception e) {
            System.err.println("❌ Error in EditProfileServlet.doGet: " + e.getMessage());
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
            System.out.println("✅ EditProfile POST: User = " + currentUser.getId());
            
            // Lấy dữ liệu từ form
            String fullname = req.getParameter("fullname");
            String email = req.getParameter("email");
            
            System.out.println("📝 Fullname: " + fullname);
            System.out.println("📧 Email: " + email);
            
            // Trim inputs
            fullname = (fullname != null) ? fullname.trim() : "";
            email = (email != null) ? email.trim() : "";
            
            // ========== VALIDATION ==========
            
            // 1. Kiểm tra trống
            if (fullname.isEmpty() || email.isEmpty()) {
                System.out.println("⚠️ Empty fields");
                req.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
                req.getRequestDispatcher("/views/auth/edit-profile.jsp").forward(req, resp);
                return;
            }
            
            // 2. Validate fullname length
            if (fullname.length() < 2 || fullname.length() > 50) {
                System.out.println("⚠️ Invalid fullname length: " + fullname.length());
                req.setAttribute("error", "Họ tên phải từ 2-50 ký tự!");
                req.getRequestDispatcher("/views/auth/edit-profile.jsp").forward(req, resp);
                return;
            }
            
            // 3. Validate email format
            if (!EMAIL_PATTERN.matcher(email).matches()) {
                System.out.println("⚠️ Invalid email format: " + email);
                req.setAttribute("error", "Email không hợp lệ!");
                req.getRequestDispatcher("/views/auth/edit-profile.jsp").forward(req, resp);
                return;
            }
            
            // 4. Kiểm tra email đã tồn tại (trừ email của chính user)
            if (userDAO == null) {
                System.err.println("❌ userDAO is null!");
                req.setAttribute("error", "Lỗi hệ thống: UserDAO chưa khởi tạo!");
                req.getRequestDispatcher("/views/auth/edit-profile.jsp").forward(req, resp);
                return;
            }
            
            User existingEmail = userDAO.findByEmail(email);
            if (existingEmail != null && !existingEmail.getId().equals(currentUser.getId())) {
                System.out.println("⚠️ Email already exists: " + email);
                req.setAttribute("error", "Email đã được sử dụng bởi tài khoản khác!");
                req.getRequestDispatcher("/views/auth/edit-profile.jsp").forward(req, resp);
                return;
            }
            
            // ========== CẬP NHẬT USER ==========
            
            currentUser.setFullname(fullname);
            currentUser.setEmail(email);
            
            // Lưu vào database
            userDAO.update(currentUser);
            
            // Cập nhật lại session
            session.setAttribute("currentUser", currentUser);
            
            System.out.println("✅ Cập nhật thông tin thành công: " + currentUser.getId());
            
            // Redirect với thông báo thành công
            req.setAttribute("message", "Cập nhật thông tin thành công!");
            req.getRequestDispatcher("/views/auth/edit-profile.jsp").forward(req, resp);
            
        } catch (Exception e) {
            System.err.println("❌ Error in EditProfileServlet.doPost: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            try {
                req.getRequestDispatcher("/views/auth/edit-profile.jsp").forward(req, resp);
            } catch (Exception ex) {
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                    "Lỗi nghiêm trọng: " + ex.getMessage());
            }
        }
    }
}