// File: src/main/java/poly/daoimpl/VideoDAOImpl.java
package poly.daoimpl;

import poly.dao.VideoDAO;
import poly.entity.Video;
import poly.util.JPAUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;

public class VideoDAOImpl implements VideoDAO {
    
    @Override
    public List<Video> findAll() {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            TypedQuery<Video> query = em.createQuery(
                "SELECT v FROM Video v ORDER BY v.views DESC", 
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
            // ✅ JOIN FETCH để load createdBy cùng lúc
            TypedQuery<Video> query = em.createQuery(
                "SELECT v FROM Video v LEFT JOIN FETCH v.createdBy WHERE v.id = :id", 
                Video.class
            );
            query.setParameter("id", id);
            return query.getSingleResult();
        } catch (Exception e) {
            return null;
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
    
    // ===== METHODS MỚI CHO ASSIGNMENT =====
    
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
}