// File: src/main/java/poly/servlet/client/UserVideoServlet.java
package poly.servlet.client;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import poly.dao.VideoDAO;
import poly.daoimpl.VideoDAOImpl;
import poly.entity.User;
import poly.entity.Video;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@WebServlet("/my-videos")
public class UserVideoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private VideoDAO videoDAO = new VideoDAOImpl();
    
    // Regex để extract YouTube Video ID
    private static final Pattern YOUTUBE_PATTERN = Pattern.compile(
        "(?:youtube\\.com/watch\\?v=|youtu\\.be/)([a-zA-Z0-9_-]{11})"
    );
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // Kiểm tra đăng nhập
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login?message=required");
            return;
        }
        
        User currentUser = (User) session.getAttribute("currentUser");
        
        try {
            String action = req.getParameter("action");
            
            // Lấy danh sách video CỦA USER NÀY
            List<Video> allVideos = videoDAO.findAll();
            List<Video> myVideos = allVideos.stream()
                .filter(v -> v.getCreatedBy() != null && 
                           v.getCreatedBy().getId().equals(currentUser.getId()))
                .collect(Collectors.toList());
            
            req.setAttribute("videos", myVideos);
            req.setAttribute("totalVideos", myVideos.size());
            
            // Xử lý action EDIT
            if ("edit".equals(action)) {
                String videoId = req.getParameter("id");
                if (videoId != null && !videoId.isEmpty()) {
                    Video video = videoDAO.findById(videoId);
                    
                    // Kiểm tra quyền sở hữu
                    if (video != null && video.getCreatedBy() != null && 
                        video.getCreatedBy().getId().equals(currentUser.getId())) {
                        req.setAttribute("video", video);
                        req.setAttribute("mode", "edit");
                    } else {
                        req.setAttribute("error", "Bạn không có quyền chỉnh sửa video này!");
                    }
                }
            }
            
            // Forward sang JSP
            req.getRequestDispatcher("/views/client/my-videos.jsp").forward(req, resp);
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi: " + e.getMessage());
            req.getRequestDispatcher("/views/client/my-videos.jsp").forward(req, resp);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // Kiểm tra đăng nhập
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login?message=required");
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
                    resp.sendRedirect(req.getContextPath() + "/my-videos");
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/my-videos");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi: " + e.getMessage());
            doGet(req, resp);
        }
    }
    
    /**
     * Xử lý tạo video mới (USER)
     */
    private void handleCreate(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        try {
            // Lấy dữ liệu từ form
            String id = req.getParameter("id");
            String title = req.getParameter("title");
            String videoUrl = req.getParameter("videoUrl");
            String description = req.getParameter("description");
            
            // Validate
            if (id == null || title == null || videoUrl == null ||
                id.trim().isEmpty() || title.trim().isEmpty() || videoUrl.trim().isEmpty()) {
                req.setAttribute("error", "Vui lòng nhập đầy đủ thông tin bắt buộc!");
                doGet(req, resp);
                return;
            }
            
            // Validate Video ID format (chỉ cho phép chữ, số, gạch dưới, gạch ngang)
            if (!id.matches("^[a-zA-Z0-9_-]{3,20}$")) {
                req.setAttribute("error", "Video ID phải từ 3-20 ký tự, chỉ chứa chữ, số, gạch dưới và gạch ngang!");
                doGet(req, resp);
                return;
            }
            
            // Kiểm tra ID đã tồn tại chưa
            Video existing = videoDAO.findById(id.trim());
            if (existing != null) {
                req.setAttribute("error", "Video ID đã tồn tại! Vui lòng chọn ID khác.");
                doGet(req, resp);
                return;
            }
            
            // Extract YouTube Video ID
            String youtubeId = extractYouTubeId(videoUrl);
            if (youtubeId == null) {
                req.setAttribute("error", "URL YouTube không hợp lệ! Vui lòng nhập link YouTube đúng định dạng.");
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
            video.setActive(true); // User đăng video mặc định active
            video.setViews(0);
            video.setCreatedDate(new Date());
            
            // Set poster từ YouTube thumbnail
            video.setPoster("https://img.youtube.com/vi/" + youtubeId + "/maxresdefault.jpg");
            
            // ✅ Set creator là user hiện tại
            video.setCreatedBy(currentUser);
            
            // Lưu vào database
            videoDAO.create(video);
            
            // Redirect với thông báo thành công
            resp.sendRedirect(req.getContextPath() + "/my-videos?success=create");
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi tạo video: " + e.getMessage());
            doGet(req, resp);
        }
    }
    
    /**
     * Xử lý cập nhật video (CHỈ VIDEO CỦA MÌNH)
     */
    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        try {
            String id = req.getParameter("id");
            String title = req.getParameter("title");
            String videoUrl = req.getParameter("videoUrl");
            String description = req.getParameter("description");
            
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
            
            // ✅ KIỂM TRA QUYỀN SỞ HỮU
            if (video.getCreatedBy() == null || 
                !video.getCreatedBy().getId().equals(currentUser.getId())) {
                req.setAttribute("error", "Bạn không có quyền chỉnh sửa video này!");
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
            
            // Lưu vào database
            videoDAO.update(video);
            
            resp.sendRedirect(req.getContextPath() + "/my-videos?success=update");
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi cập nhật video: " + e.getMessage());
            doGet(req, resp);
        }
    }
    
    /**
     * Xử lý xóa video (CHỈ VIDEO CỦA MÌNH)
     */
    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        try {
            String id = req.getParameter("id");
            
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
            
            // ✅ KIỂM TRA QUYỀN SỞ HỮU
            if (video.getCreatedBy() == null || 
                !video.getCreatedBy().getId().equals(currentUser.getId())) {
                req.setAttribute("error", "Bạn không có quyền xóa video này!");
                doGet(req, resp);
                return;
            }
            
            // Xóa video
            videoDAO.deleteById(id.trim());
            
            resp.sendRedirect(req.getContextPath() + "/my-videos?success=delete");
            
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
}