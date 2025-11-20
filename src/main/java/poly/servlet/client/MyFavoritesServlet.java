package poly.servlet.client;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import poly.dao.FavoriteDAO;
import poly.daoimpl.FavoriteDAOImpl;
import poly.entity.Favorite;
import poly.entity.User;

import java.io.IOException;
import java.util.List;

@WebServlet("/favorites")
public class MyFavoritesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private FavoriteDAO favoriteDAO = new FavoriteDAOImpl();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        try {
            // Kiểm tra đăng nhập
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("currentUser") == null) {
                resp.sendRedirect(req.getContextPath() + "/login?message=required");
                return;
            }
            
            User currentUser = (User) session.getAttribute("currentUser");
            
            // Lấy danh sách favorites của user
            List<Favorite> favorites = favoriteDAO.findByUserId(currentUser.getId());
            
            // Gửi sang JSP
            req.setAttribute("favorites", favorites);
            req.getRequestDispatcher("/views/client/my-favorites.jsp").forward(req, resp);
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi tải danh sách yêu thích: " + e.getMessage());
            req.getRequestDispatcher("/views/client/my-favorites.jsp").forward(req, resp);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        doGet(req, resp);
    }
}