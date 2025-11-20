// File: src/main/java/poly/listener/AppContextListener.java
package poly.listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import poly.util.JPAUtils;

/**
 * Listener để quản lý lifecycle của EntityManagerFactory
 * Tránh memory leak khi webapp shutdown
 */
@WebListener
public class AppContextListener implements ServletContextListener {
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("=== PolyOE Application Started ===");
        // Không khởi tạo EntityManagerFactory ở đây
        // Để lazy initialization khi servlet đầu tiên gọi
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("=== PolyOE Application Shutting Down ===");
        System.out.println("Closing EntityManagerFactory...");
        
        try {
            JPAUtils.close();
            System.out.println("EntityManagerFactory closed successfully!");
        } catch (Exception e) {
            System.err.println("Error closing EntityManagerFactory: " + e.getMessage());
        }
    }
}