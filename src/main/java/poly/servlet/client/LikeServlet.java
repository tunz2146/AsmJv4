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
import com.google.gson.JsonObject;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;

@WebServlet("/like-video")
public class LikeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private FavoriteDAO favoriteDAO = new FavoriteDAOImpl();
    private VideoDAO videoDAO = new VideoDAOImpl();
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        
        JsonObject json = new JsonObject();
        PrintWriter out = resp.getWriter();
        
        try {
            // Kiểm tra đăng nhập
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("currentUser") == null) {
                json.addProperty("success", false);
                json.addProperty("message", "Vui lòng đăng nhập để thích video!");
                out.print(json.toString());
                return;
            }
            
            User currentUser = (User) session.getAttribute("currentUser");
            String videoId = req.getParameter("videoId");
            
            // Validate videoId
            if (videoId == null || videoId.trim().isEmpty()) {
                json.addProperty("success", false);
                json.addProperty("message", "Video ID không hợp lệ!");
                out.print(json.toString());
                return;
            }
            
            // Kiểm tra video tồn tại
            Video video = videoDAO.findById(videoId);
            if (video == null) {
                json.addProperty("success", false);
                json.addProperty("message", "Video không tồn tại!");
                out.print(json.toString());
                return;
            }
            
            // Kiểm tra đã thích chưa
            Favorite existing = favoriteDAO.findByUserAndVideo(
                currentUser.getId(), 
                videoId
            );
            
            if (existing != null) {
                json.addProperty("success", false);
                json.addProperty("message", "Bạn đã thích video này rồi!");
                out.print(json.toString());
                return;
            }
            
            // Tạo favorite mới
            Favorite favorite = new Favorite();
            favorite.setUser(currentUser);
            favorite.setVideo(video);
            favorite.setLikeDate(new Date());
            
            favoriteDAO.create(favorite);
            
            // ✅ Đếm lại số lượng like
            int newLikeCount = favoriteDAO.countByVideoId(videoId);
            
            json.addProperty("success", true);
            json.addProperty("message", "Đã thêm vào danh sách yêu thích!");
            json.addProperty("likeCount", newLikeCount); // ✅ Trả về số mới
            out.print(json.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            json.addProperty("success", false);
            json.addProperty("message", "Lỗi: " + e.getMessage());
            out.print(json.toString());
        } finally {
            out.flush();
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        doPost(req, resp);
    }
}