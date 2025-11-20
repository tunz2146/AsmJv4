package poly.servlet.client;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import poly.dao.FavoriteDAO;
import poly.dao.ShareDAO;
import poly.dao.VideoDAO;
import poly.daoimpl.FavoriteDAOImpl;
import poly.daoimpl.ShareDAOImpl;
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
    private ShareDAO shareDAO = new ShareDAOImpl();
    
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
            
            // ✅ Đếm số lượng Like từ DATABASE
            int likeCount = favoriteDAO.countByVideoId(videoId);
            
            // ✅ Đếm số lượng Share từ DATABASE
            int shareCount = shareDAO.countByVideoId(videoId);
            
            // Kiểm tra user đã like video này chưa
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
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        doGet(req, resp);
    }
}