package poly.servlet.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        doPost(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // Hủy session
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        // Xóa remember me cookie
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberedUser".equals(cookie.getName())) {
                    cookie.setMaxAge(0);
                    cookie.setPath(req.getContextPath());
                    resp.addCookie(cookie);
                }
            }
        }
        
        // Redirect về trang login với thông báo
        resp.sendRedirect(req.getContextPath() + "/login?message=logout");
    }
}