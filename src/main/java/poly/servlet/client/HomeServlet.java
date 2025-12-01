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

@WebServlet({"/home", "/"})
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private VideoDAO videoDAO = new VideoDAOImpl();
    
    // Số video mỗi trang
    private static final int PAGE_SIZE = 6;
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        try {
            // Lấy page hiện tại từ parameter (mặc định là 1)
            String pageParam = req.getParameter("page");
            int currentPage = 1;
            
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) {
                        currentPage = 1;
                    }
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            // ✅ SỬA LẠI: Dùng findWithPagination thay vì findWithPaginationNoSort
            List<Video> videos = videoDAO.findWithPagination(currentPage, PAGE_SIZE);
            
            // Tính tổng số trang
            int totalVideos = videoDAO.countAll();
            int totalPages = (int) Math.ceil((double) totalVideos / PAGE_SIZE);
            
            // Đảm bảo currentPage không vượt quá totalPages
            if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
                videos = videoDAO.findWithPagination(currentPage, PAGE_SIZE);
            }
            
            // Gửi dữ liệu sang JSP
            req.setAttribute("videos", videos);
            req.setAttribute("currentPage", currentPage);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalVideos", totalVideos);
            req.setAttribute("pageSize", PAGE_SIZE);
            
            // Forward sang trang home.jsp
            req.getRequestDispatcher("/views/client/home.jsp").forward(req, resp);
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi tải danh sách video: " + e.getMessage());
            req.getRequestDispatcher("/views/client/home.jsp").forward(req, resp);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        doGet(req, resp);
    }
}