// File: src/main/java/poly/servlet/admin/ReportServlet.java
package poly.servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import poly.entity.User;
import poly.service.ReportService;
import com.google.gson.Gson;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/reports")
public class ReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private ReportService reportService = new ReportService();
    private Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // ===== DEBUG LOG =====
        System.out.println("╔════════════════════════════════════════════════════════════╗");
        System.out.println("║  ReportServlet.doGet() CALLED!                            ║");
        System.out.println("╠════════════════════════════════════════════════════════════╣");
        System.out.println("  Request URI: " + req.getRequestURI());
        System.out.println("  Context Path: " + req.getContextPath());
        System.out.println("  Servlet Path: " + req.getServletPath());
        System.out.println("  Query String: " + req.getQueryString());
        
        // Kiểm tra session
        HttpSession session = req.getSession(false);
        System.out.println("  Session exists: " + (session != null));
        
        if (session != null) {
            User currentUser = (User) session.getAttribute("currentUser");
            System.out.println("  User in session: " + (currentUser != null ? currentUser.getId() : "null"));
            System.out.println("  Is Admin: " + (currentUser != null ? currentUser.getAdmin() : "N/A"));
        }
        System.out.println("╚════════════════════════════════════════════════════════════╝");
        // ===== END DEBUG =====
        
        // Kiểm tra session
        HttpSession session2 = req.getSession(false);
        if (session2 == null) {
            System.out.println("❌ No session found! Redirecting to login...");
            resp.sendRedirect(req.getContextPath() + "/login?message=required");
            return;
        }
        
        // Kiểm tra user
        User currentUser = (User) session2.getAttribute("currentUser");
        if (currentUser == null) {
            System.out.println("❌ No user in session! Redirecting to login...");
            resp.sendRedirect(req.getContextPath() + "/login?message=required");
            return;
        }
        
        // Kiểm tra quyền admin
        if (currentUser.getAdmin() == null || !currentUser.getAdmin()) {
            System.out.println("❌ User is not admin! Redirecting to home...");
            System.out.println("   User ID: " + currentUser.getId());
            System.out.println("   Admin status: " + currentUser.getAdmin());
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        
        System.out.println("✅ Admin check passed! Loading reports...");
        
        try {
            String action = req.getParameter("action");
            
            // Nếu là AJAX request để lấy chart data
            if ("chartData".equals(action)) {
                System.out.println("📊 Handling chart data request...");
                handleChartData(req, resp);
                return;
            }
            
            System.out.println("📊 Loading all report data...");
            
            // Lấy tất cả dữ liệu báo cáo
            Map<String, Object> dashboard = reportService.getDashboardOverview();
            System.out.println("   ✓ Dashboard loaded");
            
            List<Map<String, Object>> topFavoriteVideos = reportService.getTopFavoriteVideos(10);
            System.out.println("   ✓ Top favorite videos loaded: " + topFavoriteVideos.size());
            
            List<Map<String, Object>> topViewedVideos = reportService.getTopViewedVideos(10);
            System.out.println("   ✓ Top viewed videos loaded: " + topViewedVideos.size());
            
            List<Map<String, Object>> topActiveUsers = reportService.getTopActiveUsers(10);
            System.out.println("   ✓ Top active users loaded: " + topActiveUsers.size());
            
            List<Map<String, Object>> topSharedVideos = reportService.getTopSharedVideos(10);
            System.out.println("   ✓ Top shared videos loaded: " + topSharedVideos.size());
            
            List<Map<String, Object>> topSharingUsers = reportService.getTopSharingUsers(10);
            System.out.println("   ✓ Top sharing users loaded: " + topSharingUsers.size());
            
            List<Map<String, Object>> unlikedVideos = reportService.getUnlikedVideos();
            System.out.println("   ✓ Unliked videos loaded: " + unlikedVideos.size());
            
            List<Map<String, Object>> inactiveUsers = reportService.getInactiveUsers();
            System.out.println("   ✓ Inactive users loaded: " + inactiveUsers.size());
            
            // Set attributes
            req.setAttribute("dashboard", dashboard);
            req.setAttribute("topFavoriteVideos", topFavoriteVideos);
            req.setAttribute("topViewedVideos", topViewedVideos);
            req.setAttribute("topActiveUsers", topActiveUsers);
            req.setAttribute("topSharedVideos", topSharedVideos);
            req.setAttribute("topSharingUsers", topSharingUsers);
            req.setAttribute("unlikedVideos", unlikedVideos);
            req.setAttribute("inactiveUsers", inactiveUsers);
            
            System.out.println("✅ All data loaded successfully! Forwarding to JSP...");
            
            // Forward to JSP
            req.getRequestDispatcher("/views/admin/reports.jsp").forward(req, resp);
            
            System.out.println("✅ Forward completed!");
            
        } catch (Exception e) {
            System.err.println("❌ ERROR in ReportServlet:");
            e.printStackTrace();
            
            req.setAttribute("error", "Lỗi khi tải báo cáo: " + e.getMessage());
            req.getRequestDispatcher("/views/admin/reports.jsp").forward(req, resp);
        }
    }
    
    /**
     * Xử lý AJAX request để lấy dữ liệu chart
     */
    private void handleChartData(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException {
        
        String chartType = req.getParameter("type");
        System.out.println("   Chart type: " + chartType);
        
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        
        try {
            if ("favorites".equals(chartType)) {
                List<Map<String, Object>> data = reportService.getFavoritesByMonth();
                resp.getWriter().write(gson.toJson(data));
                System.out.println("   ✓ Favorites chart data sent");
            } else if ("shares".equals(chartType)) {
                List<Map<String, Object>> data = reportService.getSharesByMonth();
                resp.getWriter().write(gson.toJson(data));
                System.out.println("   ✓ Shares chart data sent");
            } else {
                resp.getWriter().write("{\"error\": \"Invalid chart type\"}");
                System.out.println("   ✗ Invalid chart type: " + chartType);
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        doGet(req, resp);
    }
}