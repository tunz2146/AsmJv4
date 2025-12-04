// File: src/main/java/poly/util/JPAUtils.java
package poly.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JPAUtils {
    
    private static EntityManagerFactory emf;
    private static final Object lock = new Object();
    
    static {
        initializeEntityManagerFactory();
    }
    
    /**
     * Khởi tạo EntityManagerFactory
     */
    private static void initializeEntityManagerFactory() {
        try {
            System.out.println("=== Initializing EntityManagerFactory ===");
            emf = Persistence.createEntityManagerFactory("PolyOE_PU");
            System.out.println("=== EntityManagerFactory initialized successfully! ===");
            
            // Shutdown hook
            Runtime.getRuntime().addShutdownHook(new Thread(() -> {
                System.out.println("=== Shutdown hook triggered ===");
                closeEntityManagerFactory();
            }));
            
        } catch (Exception e) {
            System.err.println("!!! Failed to initialize EntityManagerFactory !!!");
            e.printStackTrace();
        }
    }
    
    /**
     * Lấy EntityManager - Thread-safe với lazy re-initialization
     */
    public static EntityManager getEntityManager() {
        synchronized (lock) {
            // Kiểm tra và tái tạo nếu EMF bị null hoặc đã đóng
            if (emf == null || !emf.isOpen()) {
                System.out.println("=== EntityManagerFactory is closed or null, reinitializing... ===");
                initializeEntityManagerFactory();
            }
            
            try {
                return emf.createEntityManager();
            } catch (IllegalStateException e) {
                // Nếu vẫn lỗi, thử tái tạo một lần nữa
                System.err.println("!!! Error creating EntityManager, attempting to reinitialize EMF !!!");
                e.printStackTrace();
                
                closeEntityManagerFactory();
                initializeEntityManagerFactory();
                
                return emf.createEntityManager();
            }
        }
    }
    
    /**
     * Đóng EntityManagerFactory
     */
    public static void close() {
        closeEntityManagerFactory();
    }
    
    /**
     * Đóng EntityManagerFactory một cách an toàn
     */
    private static void closeEntityManagerFactory() {
        synchronized (lock) {
            if (emf != null && emf.isOpen()) {
                try {
                    System.out.println("=== Closing EntityManagerFactory... ===");
                    emf.close();
                    System.out.println("=== EntityManagerFactory closed successfully! ===");
                } catch (Exception e) {
                    System.err.println("!!! Error closing EntityManagerFactory !!!");
                    e.printStackTrace();
                } finally {
                    emf = null;
                }
            }
        }
    }
    
    /**
     * Đóng EntityManager
     */
    public static void closeEntityManager(EntityManager em) {
        if (em != null && em.isOpen()) {
            try {
                // Rollback transaction nếu đang active
                if (em.getTransaction() != null && em.getTransaction().isActive()) {
                    em.getTransaction().rollback();
                }
                em.close();
            } catch (Exception e) {
                System.err.println("!!! Error closing EntityManager !!!");
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Kiểm tra EntityManagerFactory có đang hoạt động không
     */
    public static boolean isEntityManagerFactoryOpen() {
        return emf != null && emf.isOpen();
    }
}