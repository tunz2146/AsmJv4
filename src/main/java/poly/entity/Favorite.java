// File: src/main/java/poly/entity/Favorite.java
package poly.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "Favorites", 
       uniqueConstraints = @UniqueConstraint(columnNames = {"UserId", "VideoId"}))
public class Favorite implements Serializable {
    private static final long serialVersionUID = 1L;
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "UserId", nullable = false)
    private User user;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "VideoId", nullable = false)
    private Video video;
    
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "LikeDate", nullable = false)
    private Date likeDate = new Date();
    
    public Favorite() {
    }
    
    public Favorite(User user, Video video, Date likeDate) {
        this.user = user;
        this.video = video;
        this.likeDate = likeDate;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public User getUser() {
        return user;
    }
    
    public void setUser(User user) {
        this.user = user;
    }
    
    public Video getVideo() {
        return video;
    }
    
    public void setVideo(Video video) {
        this.video = video;
    }
    
    public Date getLikeDate() {
        return likeDate;
    }
    
    public void setLikeDate(Date likeDate) {
        this.likeDate = likeDate;
    }
}