// File: src/main/java/poly/entity/Video.java
package poly.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

@Entity
@Table(name = "Videos")
public class Video implements Serializable {
    private static final long serialVersionUID = 1L;
    
    @Id
    @Column(name = "Id", length = 20)
    private String id;
    
    @Column(name = "Title", length = 100, nullable = false)
    private String title;
    
    @Column(name = "Poster", length = 200)
    private String poster;
    
    // ✅ THÊM MỚI: YouTube Video ID (mã video trên YouTube)
    @Column(name = "VideoId", length = 20)
    private String videoId;
    
    // ✅ THÊM MỚI: URL đầy đủ của video
    @Column(name = "VideoUrl", length = 200)
    private String videoUrl;
    
    @Column(name = "Views", nullable = false)
    private Integer views = 0;
    
    @Column(name = "Description", length = 500)
    private String description;
    
    @Column(name = "Active", nullable = false)
    private Boolean active = true;
    
    @OneToMany(mappedBy = "video", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Favorite> favorites;
    
    @OneToMany(mappedBy = "video", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Share> shares;
    
    // Constructors
    public Video() {
    }
    
    public Video(String id, String title, String poster, String videoId, String videoUrl, 
                 Integer views, String description, Boolean active) {
        this.id = id;
        this.title = title;
        this.poster = poster;
        this.videoId = videoId;
        this.videoUrl = videoUrl;
        this.views = views;
        this.description = description;
        this.active = active;
    }
    
    // Getters and Setters
    public String getId() {
        return id;
    }
    
    public void setId(String id) {
        this.id = id;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getPoster() {
        return poster;
    }
    
    public void setPoster(String poster) {
        this.poster = poster;
    }
    
    // ✅ GETTER/SETTER MỚI
    public String getVideoId() {
        return videoId;
    }
    
    public void setVideoId(String videoId) {
        this.videoId = videoId;
    }
    
    // ✅ GETTER/SETTER MỚI
    public String getVideoUrl() {
        return videoUrl;
    }
    
    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl;
    }
    
    public Integer getViews() {
        return views;
    }
    
    public void setViews(Integer views) {
        this.views = views;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Boolean getActive() {
        return active;
    }
    
    public void setActive(Boolean active) {
        this.active = active;
    }
    
    public List<Favorite> getFavorites() {
        return favorites;
    }
    
    public void setFavorites(List<Favorite> favorites) {
        this.favorites = favorites;
    }
    
    public List<Share> getShares() {
        return shares;
    }
    
    public void setShares(List<Share> shares) {
        this.shares = shares;
    }
    
    @Override
    public String toString() {
        return "Video{" +
                "id='" + id + '\'' +
                ", title='" + title + '\'' +
                ", videoId='" + videoId + '\'' +
                ", views=" + views +
                ", active=" + active +
                '}';
    }
}