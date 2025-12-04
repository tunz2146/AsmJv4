// File: src/main/java/poly/service/ReportService.java
package poly.service;

import poly.util.JPAUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Service xử lý các báo cáo thống kê
 */
public class ReportServices {
    
    /**
     * Lấy tổng quan dashboard
     */
    public Map<String, Object> getDashboardOverview() {
        EntityManager em = JPAUtils.getEntityManager();
        Map<String, Object> dashboard = new HashMap<>();
        
        try {
            // Tổng số videos
            Long totalVideos = em.createQuery("SELECT COUNT(v) FROM Video v", Long.class)
                .getSingleResult();
            dashboard.put("totalVideos", totalVideos);
            
            // Tổng số users
            Long totalUsers = em.createQuery("SELECT COUNT(u) FROM User u", Long.class)
                .getSingleResult();
            dashboard.put("totalUsers", totalUsers);
            
            // Tổng số favorites
            Long totalFavorites = em.createQuery("SELECT COUNT(f) FROM Favorite f", Long.class)
                .getSingleResult();
            dashboard.put("totalFavorites", totalFavorites);
            
            // Tổng số shares
            Long totalShares = em.createQuery("SELECT COUNT(s) FROM Share s", Long.class)
                .getSingleResult();
            dashboard.put("totalShares", totalShares);
            
            // Tổng lượt xem
            Long totalViews = em.createQuery("SELECT SUM(v.views) FROM Video v", Long.class)
                .getSingleResult();
            dashboard.put("totalViews", totalViews != null ? totalViews : 0L);
            
            // Số admin
            Long totalAdmins = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.admin = true", Long.class)
                .getSingleResult();
            dashboard.put("totalAdmins", totalAdmins);
            
        } finally {
            JPAUtils.closeEntityManager(em);
        }
        
        return dashboard;
    }
    
    /**
     * Top Videos được yêu thích nhiều nhất
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getTopFavoriteVideos(int limit) {
        EntityManager em = JPAUtils.getEntityManager();
        List<Map<String, Object>> results = new ArrayList<>();
        
        try {
            String sql = "SELECT v.Id, v.Title, v.Poster, v.Views, COUNT(f.Id) as LikeCount " +
                        "FROM Videos v " +
                        "LEFT JOIN Favorites f ON v.Id = f.VideoId " +
                        "GROUP BY v.Id, v.Title, v.Poster, v.Views " +
                        "ORDER BY LikeCount DESC";
            
            Query query = em.createNativeQuery(sql);
            query.setMaxResults(limit);
            
            List<Object[]> rows = query.getResultList();
            
            for (Object[] row : rows) {
                Map<String, Object> map = new HashMap<>();
                map.put("videoId", row[0]);
                map.put("title", row[1]);
                map.put("poster", row[2]);
                map.put("views", row[3]);
                map.put("likeCount", row[4]);
                results.add(map);
            }
            
        } finally {
            JPAUtils.closeEntityManager(em);
        }
        
        return results;
    }
    
    /**
     * Top Videos được xem nhiều nhất
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getTopViewedVideos(int limit) {
        EntityManager em = JPAUtils.getEntityManager();
        List<Map<String, Object>> results = new ArrayList<>();
        
        try {
            String sql = "SELECT v.Id, v.Title, v.Poster, v.Views, " +
                        "(SELECT COUNT(*) FROM Favorites f WHERE f.VideoId = v.Id) as LikeCount " +
                        "FROM Videos v " +
                        "WHERE v.Active = 1 " +
                        "ORDER BY v.Views DESC";
            
            Query query = em.createNativeQuery(sql);
            query.setMaxResults(limit);
            
            List<Object[]> rows = query.getResultList();
            
            for (Object[] row : rows) {
                Map<String, Object> map = new HashMap<>();
                map.put("videoId", row[0]);
                map.put("title", row[1]);
                map.put("poster", row[2]);
                map.put("views", row[3]);
                map.put("likeCount", row[4]);
                results.add(map);
            }
            
        } finally {
            JPAUtils.closeEntityManager(em);
        }
        
        return results;
    }
    
    /**
     * Top Users hoạt động tích cực nhất
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getTopActiveUsers(int limit) {
        EntityManager em = JPAUtils.getEntityManager();
        List<Map<String, Object>> results = new ArrayList<>();
        
        try {
            String sql = "SELECT u.Id, u.Fullname, u.Email, " +
                        "COUNT(DISTINCT f.Id) as FavoriteCount, " +
                        "COUNT(DISTINCT s.Id) as ShareCount " +
                        "FROM Users u " +
                        "LEFT JOIN Favorites f ON u.Id = f.UserId " +
                        "LEFT JOIN Shares s ON u.Id = s.UserId " +
                        "GROUP BY u.Id, u.Fullname, u.Email " +
                        "ORDER BY (COUNT(DISTINCT f.Id) + COUNT(DISTINCT s.Id)) DESC";
            
            Query query = em.createNativeQuery(sql);
            query.setMaxResults(limit);
            
            List<Object[]> rows = query.getResultList();
            
            for (Object[] row : rows) {
                Map<String, Object> map = new HashMap<>();
                map.put("userId", row[0]);
                map.put("fullname", row[1]);
                map.put("email", row[2]);
                map.put("favoriteCount", row[3]);
                map.put("shareCount", row[4]);
                map.put("totalActivity", ((Number)row[3]).intValue() + ((Number)row[4]).intValue());
                results.add(map);
            }
            
        } finally {
            JPAUtils.closeEntityManager(em);
        }
        
        return results;
    }
    
    /**
     * Videos được share nhiều nhất
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getTopSharedVideos(int limit) {
        EntityManager em = JPAUtils.getEntityManager();
        List<Map<String, Object>> results = new ArrayList<>();
        
        try {
            String sql = "SELECT v.Id, v.Title, v.Poster, COUNT(s.Id) as ShareCount " +
                        "FROM Videos v " +
                        "LEFT JOIN Shares s ON v.Id = s.VideoId " +
                        "GROUP BY v.Id, v.Title, v.Poster " +
                        "HAVING COUNT(s.Id) > 0 " +
                        "ORDER BY ShareCount DESC";
            
            Query query = em.createNativeQuery(sql);
            query.setMaxResults(limit);
            
            List<Object[]> rows = query.getResultList();
            
            for (Object[] row : rows) {
                Map<String, Object> map = new HashMap<>();
                map.put("videoId", row[0]);
                map.put("title", row[1]);
                map.put("poster", row[2]);
                map.put("shareCount", row[3]);
                results.add(map);
            }
            
        } finally {
            JPAUtils.closeEntityManager(em);
        }
        
        return results;
    }
    
    /**
     * Users chia sẻ nhiều nhất
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getTopSharingUsers(int limit) {
        EntityManager em = JPAUtils.getEntityManager();
        List<Map<String, Object>> results = new ArrayList<>();
        
        try {
            String sql = "SELECT u.Id, u.Fullname, u.Email, COUNT(s.Id) as ShareCount " +
                        "FROM Users u " +
                        "LEFT JOIN Shares s ON u.Id = s.UserId " +
                        "GROUP BY u.Id, u.Fullname, u.Email " +
                        "HAVING COUNT(s.Id) > 0 " +
                        "ORDER BY ShareCount DESC";
            
            Query query = em.createNativeQuery(sql);
            query.setMaxResults(limit);
            
            List<Object[]> rows = query.getResultList();
            
            for (Object[] row : rows) {
                Map<String, Object> map = new HashMap<>();
                map.put("userId", row[0]);
                map.put("fullname", row[1]);
                map.put("email", row[2]);
                map.put("shareCount", row[3]);
                results.add(map);
            }
            
        } finally {
            JPAUtils.closeEntityManager(em);
        }
        
        return results;
    }
    
    /**
     * Thống kê Favorites theo tháng (năm hiện tại)
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getFavoritesByMonth() {
        EntityManager em = JPAUtils.getEntityManager();
        List<Map<String, Object>> results = new ArrayList<>();
        
        try {
            String sql = "SELECT MONTH(LikeDate) as Month, COUNT(*) as Total " +
                        "FROM Favorites " +
                        "WHERE YEAR(LikeDate) = YEAR(GETDATE()) " +
                        "GROUP BY MONTH(LikeDate) " +
                        "ORDER BY Month";
            
            Query query = em.createNativeQuery(sql);
            List<Object[]> rows = query.getResultList();
            
            // Khởi tạo 12 tháng với giá trị 0
            for (int i = 1; i <= 12; i++) {
                Map<String, Object> map = new HashMap<>();
                map.put("month", i);
                map.put("total", 0);
                results.add(map);
            }
            
            // Fill dữ liệu thực tế
            for (Object[] row : rows) {
                int month = ((Number)row[0]).intValue();
                int total = ((Number)row[1]).intValue();
                results.get(month - 1).put("total", total);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            // Nếu lỗi, trả về 12 tháng với giá trị 0
            for (int i = 1; i <= 12; i++) {
                Map<String, Object> map = new HashMap<>();
                map.put("month", i);
                map.put("total", 0);
                results.add(map);
            }
        } finally {
            JPAUtils.closeEntityManager(em);
        }
        
        return results;
    }
    
    /**
     * Thống kê Shares theo tháng (năm hiện tại)
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getSharesByMonth() {
        EntityManager em = JPAUtils.getEntityManager();
        List<Map<String, Object>> results = new ArrayList<>();
        
        try {
            String sql = "SELECT MONTH(ShareDate) as Month, COUNT(*) as Total " +
                        "FROM Shares " +
                        "WHERE YEAR(ShareDate) = YEAR(GETDATE()) " +
                        "GROUP BY MONTH(ShareDate) " +
                        "ORDER BY Month";
            
            Query query = em.createNativeQuery(sql);
            List<Object[]> rows = query.getResultList();
            
            // Khởi tạo 12 tháng với giá trị 0
            for (int i = 1; i <= 12; i++) {
                Map<String, Object> map = new HashMap<>();
                map.put("month", i);
                map.put("total", 0);
                results.add(map);
            }
            
            // Fill dữ liệu thực tế
            for (Object[] row : rows) {
                int month = ((Number)row[0]).intValue();
                int total = ((Number)row[1]).intValue();
                results.get(month - 1).put("total", total);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            // Nếu lỗi, trả về 12 tháng với giá trị 0
            for (int i = 1; i <= 12; i++) {
                Map<String, Object> map = new HashMap<>();
                map.put("month", i);
                map.put("total", 0);
                results.add(map);
            }
        } finally {
            JPAUtils.closeEntityManager(em);
        }
        
        return results;
    }
    
    /**
     * Videos chưa được like
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getUnlikedVideos() {
        EntityManager em = JPAUtils.getEntityManager();
        List<Map<String, Object>> results = new ArrayList<>();
        
        try {
            String sql = "SELECT v.Id, v.Title, v.Poster, v.Views " +
                        "FROM Videos v " +
                        "WHERE NOT EXISTS (SELECT 1 FROM Favorites f WHERE f.VideoId = v.Id) " +
                        "AND v.Active = 1 " +
                        "ORDER BY v.Views DESC";
            
            Query query = em.createNativeQuery(sql);
            List<Object[]> rows = query.getResultList();
            
            for (Object[] row : rows) {
                Map<String, Object> map = new HashMap<>();
                map.put("videoId", row[0]);
                map.put("title", row[1]);
                map.put("poster", row[2]);
                map.put("views", row[3]);
                results.add(map);
            }
            
        } finally {
            JPAUtils.closeEntityManager(em);
        }
        
        return results;
    }
    
    /**
     * Users không hoạt động (chưa like và share)
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getInactiveUsers() {
        EntityManager em = JPAUtils.getEntityManager();
        List<Map<String, Object>> results = new ArrayList<>();
        
        try {
            String sql = "SELECT u.Id, u.Fullname, u.Email " +
                        "FROM Users u " +
                        "WHERE NOT EXISTS (SELECT 1 FROM Favorites f WHERE f.UserId = u.Id) " +
                        "AND NOT EXISTS (SELECT 1 FROM Shares s WHERE s.UserId = u.Id) " +
                        "ORDER BY u.Id";
            
            Query query = em.createNativeQuery(sql);
            List<Object[]> rows = query.getResultList();
            
            for (Object[] row : rows) {
                Map<String, Object> map = new HashMap<>();
                map.put("userId", row[0]);
                map.put("fullname", row[1]);
                map.put("email", row[2]);
                results.add(map);
            }
            
        } finally {
            JPAUtils.closeEntityManager(em);
        }
        
        return results;
    }
}