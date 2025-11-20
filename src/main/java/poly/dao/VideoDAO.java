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
    
    // Methods mới cho Assignment
    List<Video> findWithPagination(int page, int size);
    int countAll();
    void incrementViews(String videoId);
    List<Video> findTop6ByViews();
}