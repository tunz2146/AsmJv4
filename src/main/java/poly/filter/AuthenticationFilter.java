// File: src/main/java/poly/filter/AuthenticationFilter.java
package poly.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * Filter để kiểm tra authentication
 * Chỉ cho phép truy cập các trang cần login nếu đã đăng nhập
 */
@WebFilter("/*")
public class AuthenticationFilter implements Filter {
    
    // Danh sách các URL không cần login
    private static final List<String> PUBLIC_URLS = Arrays.asList(
        "/login",
        "/logout",
        "/",
        "/index.jsp"
    );
    
    // Danh sách các URL cần login
    private static final List<String> PROTECTED_URLS = Arrays.asList(
        "/user-favorites",
        "/all-favorites",
        "/shares",
        "/share-statistics"
    );
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        
        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length());
        
        // Bỏ qua các resources (css, js, images)
        if (path.startsWith("/resources/") || 
            path.endsWith(".css") || 
            path.endsWith(".js") || 
            path.endsWith(".png") || 
            path.endsWith(".jpg")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Kiểm tra xem URL có cần authentication không
        boolean needsAuth = PROTECTED_URLS.stream()
            .anyMatch(url -> path.startsWith(url));
        
        if (needsAuth) {
            HttpSession session = req.getSession(false);
            
            if (session == null || session.getAttribute("currentUser") == null) {
                // Chưa login - lưu URL để redirect sau khi login
                if (session == null) {
                    session = req.getSession(true);
                }
                session.setAttribute("returnUrl", req.getRequestURI());
                
                resp.sendRedirect(contextPath + "/login?message=required");
                return;
            }
        }
        
        // Cho phép tiếp tục
        chain.doFilter(request, response);
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization
    }
    
    @Override
    public void destroy() {
        // Cleanup
    }
}