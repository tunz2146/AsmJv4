// File: src/main/java/poly/daoimpl/UserDAOImpl.java
package poly.daoimpl;

import poly.dao.UserDAO;
import poly.entity.User;
import poly.util.JPAUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;

public class UserDAOImpl implements UserDAO {
    
    @Override
    public List<User> findAll() {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            TypedQuery<User> query = em.createQuery(
                "SELECT u FROM User u ORDER BY u.id", 
                User.class
            );
            return query.getResultList();
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
    
    @Override
    public User findById(String id) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            return em.find(User.class, id);
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
    
    @Override
    public void create(User user) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(user);
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
    public void update(User user) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(user);
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
            User user = em.find(User.class, id);
            if (user != null) {
                em.remove(user);
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
    public User findByEmail(String email) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            TypedQuery<User> query = em.createQuery(
                "SELECT u FROM User u WHERE u.email = :email", 
                User.class
            );
            query.setParameter("email", email);
            return query.getSingleResult();
        } catch (Exception e) {
            return null;
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
    
    // ===== METHODS MỚI CHO ASSIGNMENT =====
    
    @Override
    public List<User> findWithPagination(int page, int size) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            TypedQuery<User> query = em.createQuery(
                "SELECT u FROM User u ORDER BY u.id", 
                User.class
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
                "SELECT COUNT(u) FROM User u", 
                Long.class
            ).getSingleResult();
            return count.intValue();
        } finally {
            JPAUtils.closeEntityManager(em);
        }
    }
}