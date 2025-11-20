// File: src/main/java/poly/daoimpl/FavoriteDAOImpl.java
package poly.daoimpl;

import poly.dao.FavoriteDAO;
import poly.entity.Favorite;
import poly.util.JPAUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;

public class FavoriteDAOImpl implements FavoriteDAO {
    
    @Override
    public List<Favorite> findAll() {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            TypedQuery<Favorite> query = em.createQuery(
                "SELECT DISTINCT f FROM Favorite f " +
                "JOIN FETCH f.user " +
                "JOIN FETCH f.video " +
                "ORDER BY f.likeDate DESC", 
                Favorite.class
            );
            return query.getResultList();
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
    
    @Override
    public Favorite findById(Long id) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            TypedQuery<Favorite> query = em.createQuery(
                "SELECT f FROM Favorite f " +
                "JOIN FETCH f.user " +
                "JOIN FETCH f.video " +
                "WHERE f.id = :id", 
                Favorite.class
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
    public void create(Favorite favorite) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(favorite);
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
    public void update(Favorite favorite) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(favorite);
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
    public void deleteById(Long id) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            Favorite favorite = em.find(Favorite.class, id);
            if (favorite != null) {
                em.remove(favorite);
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
    public List<Favorite> findByUserId(String userId) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            TypedQuery<Favorite> query = em.createQuery(
                "SELECT f FROM Favorite f " +
                "JOIN FETCH f.user u " +
                "JOIN FETCH f.video v " +
                "WHERE u.id = :userId " +
                "ORDER BY f.likeDate DESC", 
                Favorite.class
            );
            query.setParameter("userId", userId);
            return query.getResultList();
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
    
    @Override
    public Favorite findByUserAndVideo(String userId, String videoId) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            TypedQuery<Favorite> query = em.createQuery(
                "SELECT f FROM Favorite f " +
                "WHERE f.user.id = :userId AND f.video.id = :videoId", 
                Favorite.class
            );
            query.setParameter("userId", userId);
            query.setParameter("videoId", videoId);
            return query.getSingleResult();
        } catch (Exception e) {
            return null;
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
    
    @Override
    public void deleteByUserAndVideo(String userId, String videoId) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            int deleted = em.createQuery(
                "DELETE FROM Favorite f " +
                "WHERE f.user.id = :userId AND f.video.id = :videoId"
            )
            .setParameter("userId", userId)
            .setParameter("videoId", videoId)
            .executeUpdate();
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
    
    // ✅ METHOD MỚI: Đếm số lượng like theo videoId
    @Override
    public int countByVideoId(String videoId) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            Long count = em.createQuery(
                "SELECT COUNT(f) FROM Favorite f WHERE f.video.id = :videoId", 
                Long.class
            )
            .setParameter("videoId", videoId)
            .getSingleResult();
            return count.intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
}