package poly.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

@Entity
@Table(name = "Users")
public class User implements Serializable {
    
    @Id
    @Column(name = "Id", length = 20)
    private String id;
    
    @Column(name = "Password", length = 255, nullable = false)
    private String password;
    
    @Column(name = "Fullname", length = 50, nullable = false)
    private String fullname;
    
    @Column(name = "Email", length = 50, nullable = false, unique = true)
    private String email;
    
    @Column(name = "Admin", nullable = false)
    private Boolean admin = false;

    // ❌ XOÁ CỘT ACTIVE — VÌ DB KHÔNG CÓ
    // @Column(name = "Active", nullable = false)
    // private Boolean active = true;
    
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Favorite> favorites;
    
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Share> shares;
    
    public User() {}

    public User(String id, String password, String fullname, String email, Boolean admin) {
        this.id = id;
        this.password = password;
        this.fullname = fullname;
        this.email = email;
        this.admin = admin;
    }
    
    // Getters / Setters
    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }

    public String getUsername() {
        return this.id;
    }
    public void setUsername(String username) {
        this.id = username;
    }

    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullname() {
        return fullname;
    }
    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public Boolean getAdmin() {
        return admin;
    }
    public void setAdmin(Boolean admin) {
        this.admin = admin;
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
        return "User{" +
                "id='" + id + '\'' +
                ", fullname='" + fullname + '\'' +
                ", email='" + email + '\'' +
                ", admin=" + admin +
                '}';
    }
}
