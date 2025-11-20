package poly.servlet.client;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import poly.dao.FavoriteDAO;
import poly.daoimpl.FavoriteDAOImpl;
import poly.entity.User;
import com.google.gson.JsonObject;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/unlike-video")
public class UnlikeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private FavoriteDAO favoriteDAO = new FavoriteDAOImpl();
    
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
                json.addProperty("message", "Vui lòng đăng nhập!");
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
            
            // Xóa favorite
            favoriteDAO.deleteByUserAndVideo(currentUser.getId(), videoId);
            
            json.addProperty("success", true);
            json.addProperty("message", "Đã bỏ thích video!");
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