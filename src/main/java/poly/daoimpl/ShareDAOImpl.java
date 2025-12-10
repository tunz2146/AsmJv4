// File: src/main/java/poly/daoimpl/ShareDAOImpl.java
package poly.daoimpl;

import poly.dao.ShareDAO;
import poly.entity.Share;
import poly.util.JPAUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;

public class ShareDAOImpl implements ShareDAO {
    
    @Override
    public List<Share> findAll() {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            TypedQuery<Share> query = em.createQuery(
                "SELECT DISTINCT s FROM Share s " +
                "JOIN FETCH s.user " +
                "JOIN FETCH s.video " +
                "ORDER BY s.shareDate DESC", 
                Share.class
            );
            return query.getResultList();
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
    
    @Override
    public Share findById(Long id) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            TypedQuery<Share> query = em.createQuery(
                "SELECT s FROM Share s " +
                "JOIN FETCH s.user " +
                "JOIN FETCH s.video " +
                "WHERE s.id = :id", 
                Share.class
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
    public void create(Share share) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(share);
            em.getTransaction().commit();
            
            System.out.println("✅ Created share: User=" + share.getUser().getId() + 
                             ", Video=" + share.getVideo().getId() + 
                             ", Email=" + share.getEmail());
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
    
    @Override
    public void update(Share share) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(share);
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
            Share share = em.find(Share.class, id);
            if (share != null) {
                em.remove(share);
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
    
    // ✅✅✅ METHOD QUAN TRỌNG - ĐẾM SỐ SHARE ✅✅✅
    @Override
    public int countByVideoId(String videoId) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            Long count = em.createQuery(
                "SELECT COUNT(s) FROM Share s WHERE s.video.id = :videoId", 
                Long.class
            )
            .setParameter("videoId", videoId)
            .getSingleResult();
            
            int result = count.intValue();
            System.out.println("🔢 countByVideoId(" + videoId + ") = " + result);
            
            return result;
        } catch (Exception e) {
            System.err.println("❌ Error counting shares for video " + videoId);
            e.printStackTrace();
            return 0;
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
}