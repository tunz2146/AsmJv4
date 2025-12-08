package poly.servlet.client;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import poly.dao.VideoDAO;
import poly.daoimpl.VideoDAOImpl;
import poly.entity.Video;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private VideoDAO videoDAO = new VideoDAOImpl();
    
    // Key để lưu shuffled IDs trong session
    private static final String SESSION_SHUFFLED_IDS = "shuffledVideoIds";
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        try {
            HttpSession session = req.getSession();
            
            // Lấy page hiện tại
            String pageParam = req.getParameter("page");
            int currentPage = 1;
            if (pageParam != null) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) {
                        currentPage = 1;
                    }
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            int pageSize = 6;
            
            // ✅✅✅ BƯỚC 1: Lấy hoặc tạo shuffled IDs list
            @SuppressWarnings("unchecked")
            List<String> shuffledIds = (List<String>) session.getAttribute(SESSION_SHUFFLED_IDS);
            
            if (shuffledIds == null) {
                System.out.println("=== SHUFFLE VIDEO IDS ===");
                
                // Lấy TẤT CẢ video IDs (query siêu nhanh, chỉ lấy ID)
                List<String> allIds = videoDAO.findAllActiveVideoIds();
                
                // Shuffle trong Java
                shuffledIds = new ArrayList<>(allIds);
                Collections.shuffle(shuffledIds);
                
                // Lưu vào session để pagination không đổi thứ tự
                session.setAttribute(SESSION_SHUFFLED_IDS, shuffledIds);
                
                System.out.println("Shuffled " + shuffledIds.size() + " video IDs");
                System.out.println("First 6: " + shuffledIds.subList(0, Math.min(6, shuffledIds.size())));
            } else {
                System.out.println("=== USING CACHED SHUFFLED IDS ===");
                System.out.println("Total: " + shuffledIds.size());
            }
            
            // ✅✅✅ BƯỚC 2: Slice IDs theo page
            int totalVideos = shuffledIds.size();
            int totalPages = (int) Math.ceil((double) totalVideos / pageSize);
            
            if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
            }
            
            int fromIndex = (currentPage - 1) * pageSize;
            int toIndex = Math.min(fromIndex + pageSize, totalVideos);
            
            List<String> pageIds = shuffledIds.subList(fromIndex, toIndex);
            
            System.out.println("Page " + currentPage + ": Loading IDs " + fromIndex + "-" + toIndex);
            System.out.println("IDs: " + pageIds);
            
            // ✅✅✅ BƯỚC 3: Load videos theo IDs (giữ đúng thứ tự)
            List<Video> videos = videoDAO.findByIds(pageIds);
            
            System.out.println("Loaded " + videos.size() + " videos");
            System.out.println("===================");
            
            // Gửi dữ liệu sang JSP
            req.setAttribute("videos", videos);
            req.setAttribute("currentPage", currentPage);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalVideos", totalVideos);
            
            // Forward sang trang home.jsp
            req.getRequestDispatcher("/views/client/home.jsp").forward(req, resp);
            
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("ERROR in HomeServlet: " + e.getMessage());
            req.setAttribute("error", "Lỗi khi tải danh sách video: " + e.getMessage());
            req.getRequestDispatcher("/views/client/home.jsp").forward(req, resp);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String action = req.getParameter("action");
        
        if ("reshuffle".equals(action)) {
            // Xóa cached shuffled IDs để shuffle lại
            HttpSession session = req.getSession();
            session.removeAttribute(SESSION_SHUFFLED_IDS);
            
            System.out.println("=== RESHUFFLED ===");
            
            resp.sendRedirect(req.getContextPath() + "/home");
        } else {
            doGet(req, resp);
        }
    }
}