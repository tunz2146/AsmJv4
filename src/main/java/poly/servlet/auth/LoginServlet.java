package poly.servlet.auth;

import poly.entity.User;
import poly.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private AuthService authService = new AuthService();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // Kiểm tra nếu đã đăng nhập rồi thì redirect về home
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        
        // ✅ Kiểm tra Remember Me Cookie
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberedUser".equals(cookie.getName())) {
                    String username = cookie.getValue();
                    
                    // Tự động điền username vào form
                    req.setAttribute("username", username);
                    req.setAttribute("rememberChecked", true);
                    break;
                }
            }
        }
        
        // Hiển thị trang login
        req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // Lấy dữ liệu từ form
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String remember = req.getParameter("remember");
        
        // Validate input
        if (username == null || password == null || 
            username.trim().isEmpty() || password.trim().isEmpty()) {
            
            req.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            req.setAttribute("username", username);
            req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
            return;
        }
        
        try {
            // ❗ Không hash password
            User user = authService.authenticate(username.trim(), password.trim());
            
            if (user != null) {

                // Lưu session
                HttpSession session = req.getSession(true);
                session.setAttribute("currentUser", user);
                session.setMaxInactiveInterval(30 * 60); // 30 phút
                
                // ✅ Xử lý Remember me
                if ("on".equals(remember)) {
                    Cookie cookie = new Cookie("rememberedUser", username);
                    cookie.setMaxAge(7 * 24 * 60 * 60); // 7 ngày
                    cookie.setPath(req.getContextPath());
                    resp.addCookie(cookie);
                } else {
                    // ✅ Nếu không check "Ghi nhớ", xóa cookie cũ
                    Cookie[] cookies = req.getCookies();
                    if (cookies != null) {
                        for (Cookie c : cookies) {
                            if ("rememberedUser".equals(c.getName())) {
                                c.setMaxAge(0);
                                c.setPath(req.getContextPath());
                                resp.addCookie(c);
                            }
                        }
                    }
                }
                
                // Redirect
                String returnUrl = req.getParameter("returnUrl");
                if (returnUrl != null && !returnUrl.isEmpty()) {
                    resp.sendRedirect(returnUrl);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/home");
                }
                
            } else {
                // Sai username hoặc mật khẩu
                req.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng!");
                req.setAttribute("username", username);
                req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            req.setAttribute("username", username);
            req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
        }
    }
}