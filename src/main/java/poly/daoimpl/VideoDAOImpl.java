// File: src/main/java/poly/daoimpl/VideoDAOImpl.java
package poly.daoimpl;

import poly.dao.VideoDAO;
import poly.entity.Video;
import poly.util.JPAUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;

public class VideoDAOImpl implements VideoDAO {
    
    // ==================== CRUD CƠ BẢN ====================
    
    @Override
    public List<Video> findAll() {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            TypedQuery<Video> query = em.createQuery(
                "SELECT v FROM Video v WHERE v.active = true ORDER BY v.id DESC", 
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
            
            // Set default values nếu null
            if (video.getViews() == null) {
                video.setViews(0);
            }
            if (video.getActive() == null) {
                video.setActive(true);
            }
            
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
    
    // ==================== PHÂN TRANG ====================
    
    @Override
    public List<Video> findWithPagination(int page, int size) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            TypedQuery<Video> query = em.createQuery(
                "SELECT v FROM Video v WHERE v.active = true " +
                "ORDER BY v.id DESC, v.views DESC", 
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
    
    // ==================== VIDEO VIEWS ====================
    
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
                "SELECT v FROM Video v WHERE v.active = true " +
                "ORDER BY v.views DESC, v.id DESC", 
                Video.class
            );
            query.setMaxResults(6);
            return query.getResultList();
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
    
    // ==================== VIDEO ĐỀ CỬ ====================
    
    @Override
    public List<Video> findSuggestedVideos(String currentVideoId, int limit) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            // Query lấy video đề cử:
            // 1. Loại trừ video hiện tại
            // 2. Chỉ lấy video active
            // 3. Sắp xếp: video mới nhất (ID DESC) → nhiều views nhất
            TypedQuery<Video> query = em.createQuery(
                "SELECT v FROM Video v " +
                "WHERE v.active = true AND v.id != :currentId " +
                "ORDER BY v.id DESC, v.views DESC", 
                Video.class
            );
            query.setParameter("currentId", currentVideoId);
            query.setMaxResults(limit);
            return query.getResultList();
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
}