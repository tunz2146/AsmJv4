// File: src/main/java/poly/entity/Share.java
package poly.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "Shares")
public class Share implements Serializable {
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
    
    @Column(name = "Email", length = 50, nullable = false)
    private String email;
    
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "ShareDate", nullable = false)
    private Date shareDate = new Date();
    
    public Share() {
    }
    
    public Share(User user, Video video, String email, Date shareDate) {
        this.user = user;
        this.video = video;
        this.email = email;
        this.shareDate = shareDate;
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
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public Date getShareDate() {
        return shareDate;
    }
    
    public void setShareDate(Date shareDate) {
        this.shareDate = shareDate;
    }
}