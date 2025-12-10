package poly.servlet.client;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import poly.dao.ShareDAO;
import poly.dao.VideoDAO;
import poly.daoimpl.ShareDAOImpl;
import poly.daoimpl.VideoDAOImpl;
import poly.entity.Share;
import poly.entity.User;
import poly.entity.Video;
import poly.service.EmailService;

import java.io.IOException;
import java.util.Date;

@WebServlet("/share")
public class ShareServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private Video videoDAO = new VideoDAOImpl();
    private ShareDAO shareDAO = new ShareDAOImpl();
    private EmailService emailService = new EmailService();
    
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
            
            String videoId = req.getParameter("videoId");
            
            if (videoId == null || videoId.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/home");
                return;
            }
            
            // Lấy thông tin video
            Video video = videoDAO.findById(videoId);
            
            if (video == null) {
                req.setAttribute("error", "Video không tồn tại!");
                resp.sendRedirect(req.getContextPath() + "/home");
                return;
            }
            
            // Gửi video sang JSP
            req.setAttribute("video", video);
            req.getRequestDispatcher("/views/client/share.jsp").forward(req, resp);
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi: " + e.getMessage());
            req.getRequestDispatcher("/views/client/share.jsp").forward(req, resp);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        try {
            // Kiểm tra đăng nhập
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("currentUser") == null) {
                resp.sendRedirect(req.getContextPath() + "/login?message=required");
                return;
            }
            
            User currentUser = (User) session.getAttribute("currentUser");
            
            String videoId = req.getParameter("videoId");
            String emailsStr = req.getParameter("emails");
            String message = req.getParameter("message");
            
            // Validate
            if (videoId == null || emailsStr == null || 
                videoId.trim().isEmpty() || emailsStr.trim().isEmpty()) {
                req.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
                doGet(req, resp);
                return;
            }
            
            // Lấy video
            Video video = videoDAO.findById(videoId);
            if (video == null) {
                req.setAttribute("error", "Video không tồn tại!");
                resp.sendRedirect(req.getContextPath() + "/home");
                return;
            }
            
            // Tách danh sách email (phân cách bằng dấu phẩy hoặc chấm phẩy)
            String[] emails = emailsStr.split("[,;]");
            int successCount = 0;
            
            for (String email : emails) {
                email = email.trim();
                
                if (email.isEmpty()) continue;
                
                // Validate email format
                if (!email.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$")) {
                    continue;
                }
                
                try {
                    // Lưu vào database
                    Share share = new Share();
                    share.setUser(currentUser);
                    share.setVideo(video);
                    share.setEmail(email);
                    share.setShareDate(new Date());
                    
                    shareDAO.create(share);
                    
                    // Gửi email (optional - có thể bỏ qua nếu chưa config SMTP)
                    try {
                        sendShareEmail(email, currentUser, video, message, req);
                    } catch (Exception emailEx) {
                        System.err.println("Failed to send email to " + email + ": " + emailEx.getMessage());
                    }
                    
                    successCount++;
                    
                } catch (Exception e) {
                    System.err.println("Failed to share to " + email + ": " + e.getMessage());
                }
            }
            
            if (successCount > 0) {
                req.setAttribute("message", "Đã chia sẻ video tới " + successCount + " email!");
            } else {
                req.setAttribute("error", "Không thể chia sẻ video. Vui lòng kiểm tra lại email!");
            }
            
            req.setAttribute("video", video);
            req.getRequestDispatcher("/views/client/share.jsp").forward(req, resp);
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi: " + e.getMessage());
            doGet(req, resp);
        }
    }
    
    /**
     * Gửi email chia sẻ video
     */
    private void sendShareEmail(String toEmail, User fromUser, Video video, 
                                String message, HttpServletRequest req) throws Exception {
        
        String videoUrl = req.getScheme() + "://" + 
                         req.getServerName() + ":" + 
                         req.getServerPort() + 
                         req.getContextPath() + 
                         "/video-detail?id=" + video.getId();
        
        // Log ra console (thay thế bằng gửi email thật nếu có SMTP)
        System.out.println("===== SHARE EMAIL =====");
        System.out.println("From: " + fromUser.getFullname() + " (" + fromUser.getEmail() + ")");
        System.out.println("To: " + toEmail);
        System.out.println("Video: " + video.getTitle());
        System.out.println("URL: " + videoUrl);
        if (message != null && !message.isEmpty()) {
            System.out.println("Message: " + message);
        }
        System.out.println("======================");
    }
}