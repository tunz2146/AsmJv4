// File: src/main/java/poly/servlet/admin/VideoManagementServlet.java
package poly.servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import poly.dao.UserDAO;
import poly.dao.VideoDAO;
import poly.daoimpl.UserDAOImpl;
import poly.daoimpl.VideoDAOImpl;
import poly.entity.User;
import poly.entity.Video;

import java.io.IOException;
import java.net.URL;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet("/admin/videos")
public class VideoManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private VideoDAO videoDAO = new VideoDAOImpl();
    private UserDAO userDAO = new UserDAOImpl();
    
    // Regex để extract YouTube Video ID
    private static final Pattern YOUTUBE_PATTERN = Pattern.compile(
        "(?:youtube\\.com/watch\\?v=|youtu\\.be/)([a-zA-Z0-9_-]{11})"
    );
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // Kiểm tra quyền admin
        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        
        try {
            String action = req.getParameter("action");
            
            // Lấy pagination parameters
            String pageParam = req.getParameter("page");
            int currentPage = 1;
            if (pageParam != null) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            int pageSize = 10; // Admin xem 10 video/page
            
            // Lấy danh sách video với phân trang
            List<Video> videos = videoDAO.findWithPagination(currentPage, pageSize);
            
            // Tính tổng số trang
            int totalVideos = videoDAO.countAll();
            int totalPages = (int) Math.ceil((double) totalVideos / pageSize);
            
            // Gửi dữ liệu sang JSP
            req.setAttribute("videos", videos);
            req.setAttribute("currentPage", currentPage);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalVideos", totalVideos);
            
            // Xử lý action EDIT
            if ("edit".equals(action)) {
                String videoId = req.getParameter("id");
                if (videoId != null && !videoId.isEmpty()) {
                    Video video = videoDAO.findById(videoId);
                    if (video != null) {
                        req.setAttribute("video", video);
                        req.setAttribute("mode", "edit");
                    }
                }
            }
            
            // Forward sang JSP
            req.getRequestDispatcher("/views/admin/video-management.jsp").forward(req, resp);
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi: " + e.getMessage());
            req.getRequestDispatcher("/views/admin/video-management.jsp").forward(req, resp);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // Kiểm tra quyền admin
        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        
        String action = req.getParameter("action");
        
        try {
            switch (action) {
                case "create":
                    handleCreate(req, resp);
                    break;
                case "update":
                    handleUpdate(req, resp);
                    break;
                case "delete":
                    handleDelete(req, resp);
                    break;
                case "reset":
                    // Reset form - chỉ redirect về trang chính
                    resp.sendRedirect(req.getContextPath() + "/admin/videos");
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/admin/videos");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi: " + e.getMessage());
            doGet(req, resp);
        }
    }
    
    /**
     * Xử lý tạo video mới
     */
    private void handleCreate(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        try {
            // Lấy dữ liệu từ form
            String id = req.getParameter("id");
            String title = req.getParameter("title");
            String videoUrl = req.getParameter("videoUrl");
            String description = req.getParameter("description");
            String activeStr = req.getParameter("active");
            
            // Validate
            if (id == null || title == null || videoUrl == null ||
                id.trim().isEmpty() || title.trim().isEmpty() || videoUrl.trim().isEmpty()) {
                req.setAttribute("error", "Vui lòng nhập đầy đủ thông tin bắt buộc!");
                doGet(req, resp);
                return;
            }
            
            // Kiểm tra ID đã tồn tại chưa
            Video existing = videoDAO.findById(id.trim());
            if (existing != null) {
                req.setAttribute("error", "Video ID đã tồn tại!");
                doGet(req, resp);
                return;
            }
            
            // Extract YouTube Video ID
            String youtubeId = extractYouTubeId(videoUrl);
            if (youtubeId == null) {
                req.setAttribute("error", "URL YouTube không hợp lệ!");
                doGet(req, resp);
                return;
            }
            
            // Tạo video mới
            Video video = new Video();
            video.setId(id.trim());
            video.setTitle(title.trim());
            video.setVideoUrl(videoUrl.trim());
            video.setVideoId(youtubeId);
            video.setDescription(description != null ? description.trim() : "");
            video.setActive("on".equals(activeStr));
            video.setViews(0);
            video.setCreatedDate(new Date());
            
            // Set poster từ YouTube thumbnail
            video.setPoster("https://img.youtube.com/vi/" + youtubeId + "/maxresdefault.jpg");
            
            // Set creator là admin hiện tại
            HttpSession session = req.getSession();
            User currentUser = (User) session.getAttribute("currentUser");
            video.setCreatedBy(currentUser);
            
            // Lưu vào database
            videoDAO.create(video);
            
            // Redirect với thông báo thành công
            resp.sendRedirect(req.getContextPath() + "/admin/videos?success=create");
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi tạo video: " + e.getMessage());
            doGet(req, resp);
        }
    }
    
    /**
     * Xử lý cập nhật video
     */
    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        try {
            // Lấy dữ liệu từ form
            String id = req.getParameter("id");
            String title = req.getParameter("title");
            String videoUrl = req.getParameter("videoUrl");
            String description = req.getParameter("description");
            String activeStr = req.getParameter("active");
            
            // Validate
            if (id == null || id.trim().isEmpty()) {
                req.setAttribute("error", "Video ID không hợp lệ!");
                doGet(req, resp);
                return;
            }
            
            // Tìm video
            Video video = videoDAO.findById(id.trim());
            if (video == null) {
                req.setAttribute("error", "Video không tồn tại!");
                doGet(req, resp);
                return;
            }
            
            // Cập nhật thông tin
            if (title != null && !title.trim().isEmpty()) {
                video.setTitle(title.trim());
            }
            
            if (videoUrl != null && !videoUrl.trim().isEmpty()) {
                String youtubeId = extractYouTubeId(videoUrl);
                if (youtubeId != null) {
                    video.setVideoUrl(videoUrl.trim());
                    video.setVideoId(youtubeId);
                    video.setPoster("https://img.youtube.com/vi/" + youtubeId + "/maxresdefault.jpg");
                }
            }
            
            video.setDescription(description != null ? description.trim() : "");
            video.setActive("on".equals(activeStr));
            
            // Lưu vào database
            videoDAO.update(video);
            
            // Redirect với thông báo thành công
            resp.sendRedirect(req.getContextPath() + "/admin/videos?success=update");
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi cập nhật video: " + e.getMessage());
            doGet(req, resp);
        }
    }
    
    /**
     * Xử lý xóa video
     */
    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        try {
            String id = req.getParameter("id");
            
            if (id == null || id.trim().isEmpty()) {
                req.setAttribute("error", "Video ID không hợp lệ!");
                doGet(req, resp);
                return;
            }
            
            // Xóa video
            videoDAO.deleteById(id.trim());
            
            // Redirect với thông báo thành công
            resp.sendRedirect(req.getContextPath() + "/admin/videos?success=delete");
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi xóa video: " + e.getMessage());
            doGet(req, resp);
        }
    }
    
    /**
     * Extract YouTube Video ID từ URL
     */
    private String extractYouTubeId(String url) {
        if (url == null || url.isEmpty()) {
            return null;
        }
        
        Matcher matcher = YOUTUBE_PATTERN.matcher(url);
        if (matcher.find()) {
            return matcher.group(1);
        }
        
        // Nếu không match, kiểm tra xem có phải là ID thuần không
        if (url.matches("^[a-zA-Z0-9_-]{11}$")) {
            return url;
        }
        
        return null;
    }
    
    /**
     * Kiểm tra user có phải admin không
     */
    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            return false;
        }
        
        User user = (User) session.getAttribute("currentUser");
        return user != null && user.getAdmin() != null && user.getAdmin();
    }
}