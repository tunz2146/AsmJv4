// File: src/main/java/poly/filter/AuthenticationFilter.java
package poly.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import poly.entity.User;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * Filter để kiểm tra authentication
 */
@WebFilter("/*")
public class AuthenticationFilter implements Filter {
    
    // Danh sách các URL không cần login (Public URLs)
    private static final List<String> PUBLIC_URLS = Arrays.asList(
        "/",
        "/home",
        "/login",
        "/logout",
        "/register",
        "/forgot-password",
        "/video-detail",
        "/views/",
        "/resources/",
        "/assets/",
        "/css/",
        "/js/",
        "/images/"
    );
    
    // Danh sách các URL cần login (Protected URLs)
    private static final List<String> PROTECTED_URLS = Arrays.asList(
        "/favorites",
        "/my-favorites",
        "/share",
        "/like-video",
        "/unlike-video",
        "/profile",
        "/change-password"
    );
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        
        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length());
        
        // ===== DEBUG LOG =====
        System.out.println("🔍 AuthenticationFilter - Path: " + path);
        
        // Bỏ qua các resources (css, js, images)
        if (path.startsWith("/resources/") || 
            path.startsWith("/assets/") ||
            path.startsWith("/css/") ||
            path.startsWith("/js/") ||
            path.startsWith("/images/") ||
            path.endsWith(".css") || 
            path.endsWith(".js") || 
            path.endsWith(".png") || 
            path.endsWith(".jpg") ||
            path.endsWith(".ico")) {
            chain.doFilter(request, response);
            return;
        }
        
        // ===== XỬ LÝ ADMIN URLS =====
        if (path.startsWith("/admin/")) {
            System.out.println("   🔐 Admin URL detected");
            
            HttpSession session = req.getSession(false);
            
            // Kiểm tra có session không
            if (session == null || session.getAttribute("currentUser") == null) {
                System.out.println("   ❌ No session/user - Redirect to login");
                resp.sendRedirect(contextPath + "/login?message=required&returnUrl=" + 
                                 java.net.URLEncoder.encode(uri, "UTF-8"));
                return;
            }
            
            // Kiểm tra có phải admin không
            User user = (User) session.getAttribute("currentUser");
            System.out.println("   👤 User: " + user.getId() + " | Admin: " + user.getAdmin());
            
            if (user.getAdmin() == null || !user.getAdmin()) {
                System.out.println("   ❌ User is NOT admin - Redirect to home");
                resp.sendRedirect(contextPath + "/home?error=unauthorized");
                return;
            }
            
            System.out.println("   ✅ Admin access granted!");
            chain.doFilter(request, response);
            return;
        }
        
        // ===== XỬ LÝ PROTECTED URLS =====
        boolean needsAuth = PROTECTED_URLS.stream()
            .anyMatch(url -> path.startsWith(url));
        
        if (needsAuth) {
            System.out.println("   🔐 Protected URL - Checking auth...");
            
            HttpSession session = req.getSession(false);
            
            if (session == null || session.getAttribute("currentUser") == null) {
                System.out.println("   ❌ Not logged in - Redirect to login");
                
                // Lưu URL để redirect sau khi login
                if (session == null) {
                    session = req.getSession(true);
                }
                session.setAttribute("returnUrl", uri);
                
                resp.sendRedirect(contextPath + "/login?message=required");
                return;
            }
            
            System.out.println("   ✅ Auth passed!");
        }
        
        // ===== XỬ LÝ PUBLIC URLS =====
        boolean isPublic = PUBLIC_URLS.stream()
            .anyMatch(url -> path.equals(url) || path.startsWith(url));
        
        if (isPublic) {
            System.out.println("   🌍 Public URL - No auth required");
        }
        
        // Cho phép tiếp tục
        chain.doFilter(request, response);
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("╔═══════════════════════════════════════════════════╗");
        System.out.println("║  AuthenticationFilter initialized                ║");
        System.out.println("╚═══════════════════════════════════════════════════╝");
    }
    
    @Override
    public void destroy() {
        System.out.println("AuthenticationFilter destroyed");
    }
}