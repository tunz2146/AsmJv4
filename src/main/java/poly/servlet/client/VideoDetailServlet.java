package poly.servlet.client;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import poly.dao.VideoDAO;
import poly.daoimpl.VideoDAOImpl;
import poly.entity.Video;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@WebServlet("/video-detail")
public class VideoDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private VideoDAO videoDAO = new VideoDAOImpl();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        try {
            // Lấy video ID từ parameter
            String videoId = req.getParameter("id");
            
            if (videoId == null || videoId.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/home");
                return;
            }
            
            // Tìm video theo ID
            Video video = videoDAO.findById(videoId);
            
            if (video == null) {
                req.setAttribute("error", "Không tìm thấy video!");
                req.getRequestDispatcher("/views/client/home.jsp").forward(req, resp);
                return;
            }
            
            // Tăng lượt xem (increment views)
            videoDAO.incrementViews(videoId);
            
//         // ============================================
//            // ✅ ĐẾM LIKE VÀ SHARE
//            // ============================================
//            int likeCount = FavoriteDAO.countByVideoId(videoId);
//            int shareCount = ShareDAO.countByVideoId(videoId);
//
//            // ============================================
//            // ✅ KIỂM TRA USER ĐÃ LIKE CHƯA
//            // ============================================
//            boolean isLiked = false;
//            HttpSession session = req.getSession(false);
//            if (session != null && session.getAttribute("currentUser") != null) {
//                User currentUser = (User) session.getAttribute("currentUser");
//                Favorite favorite = FavoriteDAO.findByUserAndVideo(currentUser.getId(), videoId);
//                isLiked = (favorite != null);
//            }
            
            // Reload lại video để lấy số views mới
            video = videoDAO.findById(videoId);
            
            // ✅✅✅ LẤY VIDEO ĐỀ XUẤT NGẪU NHIÊN
            System.out.println("=== VIDEO DETAIL SERVLET ===");
            System.out.println("Current Video: " + videoId);
            
            // Bước 1: Lấy TẤT CẢ video IDs (trừ video hiện tại)
            List<String> allIds = videoDAO.findAllActiveVideoIds();
            allIds.remove(videoId); // Loại bỏ video hiện tại
            
            System.out.println("Available videos: " + allIds.size());
            
            // Bước 2: Shuffle ngẫu nhiên
            List<String> shuffledIds = new ArrayList<>(allIds);
            Collections.shuffle(shuffledIds);
            
            // Bước 3: Lấy 5 video đầu tiên
            int limit = Math.min(5, shuffledIds.size());
            List<String> suggestedIds = shuffledIds.subList(0, limit);
            
            System.out.println("Suggested IDs: " + suggestedIds);
            
            // Bước 4: Load videos theo IDs
            List<Video> suggestedVideos = videoDAO.findByIds(suggestedIds);
            
            System.out.println("Loaded " + suggestedVideos.size() + " suggested videos");
            System.out.println("===========================");
            
            // Gửi dữ liệu sang JSP
            req.setAttribute("video", video);
            req.setAttribute("suggestedVideos", suggestedVideos);
            
            // Forward sang trang chi tiết
            req.getRequestDispatcher("/views/client/video-detail.jsp").forward(req, resp);
            
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("ERROR in VideoDetailServlet: " + e.getMessage());
            req.setAttribute("error", "Lỗi khi tải video: " + e.getMessage());
            req.getRequestDispatcher("/views/client/home.jsp").forward(req, resp);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        doGet(req, resp);
    }
}