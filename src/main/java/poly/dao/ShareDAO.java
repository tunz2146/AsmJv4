// File: src/main/java/poly/dao/ShareDAO.java
package poly.dao;

import poly.entity.Share;
import java.util.List;

public interface ShareDAO {
    List<Share> findAll();
    Share findById(Long id);
    void create(Share share);
    void update(Share share);
    void deleteById(Long id);
    
    // ✅ THÊM MỚI: Đếm số lượng share của video
    int countByVideoId(String videoId);
}