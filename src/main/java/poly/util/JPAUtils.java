// File: src/main/java/poly/util/JPAUtils.java
package poly.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JPAUtils {
    
    private static EntityManagerFactory emf;
    
    static {
        try {
            System.out.println("Initializing EntityManagerFactory...");
            emf = Persistence.createEntityManagerFactory("PolyOE_PU");
            System.out.println("EntityManagerFactory initialized successfully!");
            
            // Đăng ký shutdown hook để đóng EMF khi webapp dừng
            Runtime.getRuntime().addShutdownHook(new Thread(() -> {
                if (emf != null && emf.isOpen()) {
                    emf.close();
                    System.out.println("EntityManagerFactory closed by shutdown hook");
                }
            }));
            
        } catch (Exception e) {
            System.err.println("Failed to initialize EntityManagerFactory: " + e.getMessage());
            e.printStackTrace();
            // Không throw exception để webapp vẫn có thể start
            // Sẽ báo lỗi khi sử dụng thực tế
        }
    }
    
    public static EntityManager getEntityManager() {
        if (emf == null || !emf.isOpen()) {
            emf = Persistence.createEntityManagerFactory("PolyOE_PU");
        }
        return emf.createEntityManager();
    }
    
    public static void close() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
    
    public static void closeEntityManager(EntityManager em) {
        if (em != null && em.isOpen()) {
            em.close();
        }
    }
}