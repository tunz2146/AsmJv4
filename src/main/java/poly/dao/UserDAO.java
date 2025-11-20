// File: src/main/java/poly/dao/UserDAO.java
package poly.dao;

import poly.entity.User;
import java.util.List;

public interface UserDAO {
    // CRUD cơ bản
    List<User> findAll();
    User findById(String id);
    void create(User user);
    void update(User user);
    void deleteById(String id);
    
    // Methods hiện có
    User findByEmail(String email);
    
    // Methods mới cho Assignment
    List<User> findWithPagination(int page, int size);
    int countAll();
}