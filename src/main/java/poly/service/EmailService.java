package poly.service;

public class EmailService {

    /**
     * Gửi email chào mừng sau khi đăng ký
     * @param email Email người nhận
     * @param fullname Tên người nhận
     */
    public void sendWelcomeEmail(String email, String fullname) throws Exception {
        // Nếu bạn chưa cấu hình SMTP, tạm thời chỉ log ra console
        System.out.println("===== WELCOME EMAIL =====");
        System.out.println("To: " + email);
        System.out.println("Hello " + fullname + ", welcome to our system!");
        System.out.println("=========================");

        // Nếu sau này bạn muốn gửi email thật:
        // - Bật SMTP
        // - Sử dụng JavaMail (Jakarta Mail)
        // - Hoặc API của Gmail / SendGrid
        // Mình có thể viết phiên bản đầy đủ nếu bạn cần.
    }
}
