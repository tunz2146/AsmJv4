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
    
    // Methods cũ
    List<Video> findWithPagination(int page, int size);
    int countAll();
    void incrementViews(String videoId);
    List<Video> findTop6ByViews();
    
    // Methods mới - Không sort
    List<Video> findWithPaginationNoSort(int page, int size);
    List<Video> findSuggestedVideos(String excludeVideoId, int limit);
    
    // ===== METHODS TỐI ƯU - RANDOM TRONG JAVA =====
    
    /**
     * Lấy TẤT CẢ video IDs (chỉ ID, không load video)
     * Dùng để shuffle trong Java
     */
    List<String> findAllActiveVideoIds();
    
    /**
     * Tìm videos theo danh sách IDs
     * @param ids Danh sách video IDs
     * @return Danh sách videos theo đúng thứ tự IDs
     */
    List<Video> findByIds(List<String> ids);
}