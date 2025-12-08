// File: src/main/java/poly/daoimpl/VideoDAOImpl.java
package poly.daoimpl;

import poly.dao.VideoDAO;
import poly.entity.Video;
import poly.util.JPAUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;
import java.util.ArrayList;

public class VideoDAOImpl implements VideoDAO {
    
    @Override
    public List<Video> findAll() {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            TypedQuery<Video> query = em.createQuery(
                "SELECT v FROM Video v WHERE v.active = true ORDER BY v.id", 
                Video.class
            );
            return query.getResultList();
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
    
    @Override
    public Video findById(String id) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            return em.find(Video.class, id);
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
    
    @Override
    public void create(Video video) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(video);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
    
    @Override
    public void update(Video video) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(video);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
    
    @Override
    public void deleteById(String id) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            Video video = em.find(Video.class, id);
            if (video != null) {
                em.remove(video);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
    
    @Override
    public int countAll() {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            Long count = em.createQuery(
                "SELECT COUNT(v) FROM Video v WHERE v.active = true", 
                Long.class
            ).getSingleResult();
            return count.intValue();
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
    
    @Override
    public void incrementViews(String videoId) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            Video video = em.find(Video.class, videoId);
            if (video != null) {
                video.setViews(video.getViews() + 1);
                em.merge(video);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
    
    @Override
    public List<Video> findTop6ByViews() {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            TypedQuery<Video> query = em.createQuery(
                "SELECT v FROM Video v WHERE v.active = true ORDER BY v.views DESC", 
                Video.class
            );
            query.setMaxResults(6);
            return query.getResultList();
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
    
    @Override
    public List<Video> findWithPagination(int page, int size) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            TypedQuery<Video> query = em.createQuery(
                "SELECT v FROM Video v WHERE v.active = true ORDER BY v.views DESC", 
                Video.class
            );
            query.setFirstResult((page - 1) * size);
            query.setMaxResults(size);
            return query.getResultList();
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
    
    @Override
    public List<Video> findWithPaginationNoSort(int page, int size) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            TypedQuery<Video> query = em.createQuery(
                "SELECT v FROM Video v WHERE v.active = true ORDER BY v.id", 
                Video.class
            );
            query.setFirstResult((page - 1) * size);
            query.setMaxResults(size);
            return query.getResultList();
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
    
    @Override
    public List<Video> findSuggestedVideos(String excludeVideoId, int limit) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            TypedQuery<Video> query = em.createQuery(
                "SELECT v FROM Video v WHERE v.active = true AND v.id != :excludeId ORDER BY v.id", 
                Video.class
            );
            query.setParameter("excludeId", excludeVideoId);
            query.setMaxResults(limit);
            return query.getResultList();
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
    
    // ===== METHODS TỐI ƯU - CHỈ LẤY IDs =====
    
    /**
     * ✅ Lấy TẤT CẢ video IDs (CHỈ ID, KHÔNG load video)
     * Query này SIÊU NHANH vì chỉ lấy 1 cột
     */
    @Override
    public List<String> findAllActiveVideoIds() {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            TypedQuery<String> query = em.createQuery(
                "SELECT v.id FROM Video v WHERE v.active = true", 
                String.class
            );
            List<String> ids = query.getResultList();
            
            System.out.println("=== findAllActiveVideoIds ===");
            System.out.println("Total IDs: " + ids.size());
            
            return ids;
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
    
    /**
     * ✅ Tìm videos theo danh sách IDs
     * Giữ ĐÚNG THỨ TỰ của danh sách IDs truyền vào
     */
    @Override
    public List<Video> findByIds(List<String> ids) {
        if (ids == null || ids.isEmpty()) {
            return new ArrayList<>();
        }
        
        EntityManager em = JPAUtils.getEntityManager();
        try {
            // Query videos với IN clause
            TypedQuery<Video> query = em.createQuery(
                "SELECT v FROM Video v WHERE v.id IN :ids", 
                Video.class
            );
            query.setParameter("ids", ids);
            List<Video> videos = query.getResultList();
            
            // ⚠️ QUAN TRỌNG: IN clause KHÔNG giữ thứ tự
            // Phải sắp xếp lại theo thứ tự IDs
            List<Video> orderedVideos = new ArrayList<>();
            for (String id : ids) {
                for (Video video : videos) {
                    if (video.getId().equals(id)) {
                        orderedVideos.add(video);
                        break;
                    }
                }
            }
            
            System.out.println("=== findByIds ===");
            System.out.println("Requested: " + ids.size() + " IDs");
            System.out.println("Found: " + orderedVideos.size() + " videos");
            
            return orderedVideos;
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
}