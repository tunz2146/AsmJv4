package poly.servlet.client;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import poly.dao.FavoriteDAO;
import poly.dao.VideoDAO;
import poly.daoimpl.FavoriteDAOImpl;
import poly.daoimpl.VideoDAOImpl;
import poly.entity.Favorite;
import poly.entity.User;
import poly.entity.Video;

import java.io.IOException;

@WebServlet("/video-detail")
public class VideoDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private VideoDAO videoDAO = new VideoDAOImpl();
    private FavoriteDAO favoriteDAO = new FavoriteDAOImpl();
    
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
            
            // Reload lại video để lấy số views mới
            video = videoDAO.findById(videoId);
            
            // ✅ Đếm số lượng Like (Favorites)
            int likeCount = countLikes(videoId);
            
            // ✅ Đếm số lượng Share
            int shareCount = countShares(videoId);
            
            // ✅ Kiểm tra user đã like video này chưa
            boolean isLiked = false;
            HttpSession session = req.getSession(false);
            if (session != null && session.getAttribute("currentUser") != null) {
                User currentUser = (User) session.getAttribute("currentUser");
                Favorite favorite = favoriteDAO.findByUserAndVideo(currentUser.getId(), videoId);
                isLiked = (favorite != null);
            }
            
            // Gửi video sang JSP
            req.setAttribute("video", video);
            req.setAttribute("likeCount", likeCount);
            req.setAttribute("shareCount", shareCount);
            req.setAttribute("isLiked", isLiked);
            
            // Forward sang trang chi tiết
            req.getRequestDispatcher("/views/client/video-detail.jsp").forward(req, resp);
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi tải video: " + e.getMessage());
            req.getRequestDispatcher("/views/client/home.jsp").forward(req, resp);
        }
    }
    
    /**
     * Đếm số lượng Like của video
     */
    private int countLikes(String videoId) {
        try {
            return favoriteDAO.findAll().stream()
                .filter(f -> f.getVideo() != null && f.getVideo().getId().equals(videoId))
                .mapToInt(f -> 1)
                .sum();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
    
    /**
     * Đếm số lượng Share của video
     */
    private int countShares(String videoId) {
        try {
            // Bạn có thể implement ShareDAO.countByVideoId() để tối ưu hơn
            // Tạm thời dùng cách này
            return videoDAO.findById(videoId).getShares() != null 
                ? videoDAO.findById(videoId).getShares().size() 
                : 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        doGet(req, resp);
    }
}