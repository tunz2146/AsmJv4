// File: src/main/java/poly/dao/VideoDAO.java
package poly.dao;

import poly.entity.Video;
import java.util.List;

public interface VideoDAO {
    // CRUD cơ bản
    List<Video> findAll();
    Video findById(String id);
    void create(Video video);
    void update(Video video);
    void deleteById(String id);
    
    // Methods hiện có
    List<Video> findWithPagination(int page, int size);
    int countAll();
    void incrementViews(String videoId);
    List<Video> findTop6ByViews();
    
    // ===== METHODS MỚI - RANDOM =====
    
    /**
     * Lấy videos ngẫu nhiên với phân trang
     * @param page Trang hiện tại
     * @param size Số video mỗi trang
     * @return Danh sách video random
     */
    List<Video> findRandomWithPagination(int page, int size);
    
    /**
     * Lấy 5 videos đề xuất ngẫu nhiên (trừ video hiện tại)
     * @param excludeVideoId Video ID cần loại trừ
     * @return Danh sách 5 video random
     */
    List<Video> findRandomSuggestions(String excludeVideoId, int limit);
}