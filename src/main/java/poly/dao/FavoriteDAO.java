// File: src/main/java/poly/dao/FavoriteDAO.java
package poly.dao;

import poly.entity.Favorite;
import java.util.List;

public interface FavoriteDAO {
    // CRUD cơ bản
    List<Favorite> findAll();
    Favorite findById(Long id);
    void create(Favorite favorite);
    void update(Favorite favorite);
    void deleteById(Long id);
    
    // Methods hiện có
    List<Favorite> findByUserId(String userId);
    Favorite findByUserAndVideo(String userId, String videoId);
    void deleteByUserAndVideo(String userId, String videoId);
    
    // ✅ THÊM MỚI: Đếm số lượng like của video
    int countByVideoId(String videoId);
}