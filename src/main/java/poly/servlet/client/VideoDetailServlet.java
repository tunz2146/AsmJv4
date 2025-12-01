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
            
            // Reload lại video để lấy số views mới
            video = videoDAO.findById(videoId);
            
            // ✅✅✅ QUAN TRỌNG: DÙNG METHOD MỚI - LẤY VIDEO ĐỀ XUẤT
            System.out.println("=== VIDEO DETAIL SERVLET ===");
            System.out.println("Current Video: " + videoId);
            System.out.println("Calling findSuggestedVideos()...");
            
            List<Video> suggestedVideos = videoDAO.findSuggestedVideos(videoId, 5);
            
            System.out.println("Suggested videos received: " + (suggestedVideos != null ? suggestedVideos.size() : 0));
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