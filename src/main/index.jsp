<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PolyOE - Video Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 100px 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            position: relative;
        }
        .user-menu {
            position: absolute;
            top: 20px;
            right: 20px;
        }
        .user-menu .dropdown-toggle {
            background: rgba(255,255,255,0.2);
            border: 2px solid rgba(255,255,255,0.3);
            color: white;
            padding: 10px 20px;
            border-radius: 50px;
        }
        .user-menu .dropdown-toggle:hover {
            background: rgba(255,255,255,0.3);
        }
        .feature-card {
            transition: all 0.3s ease;
            border: none;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border-radius: 15px;
            overflow: hidden;
            cursor: pointer;
        }
        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.2);
        }
        .feature-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            display: inline-block;
            animation: float 3s ease-in-out infinite;
        }
        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }
        .btn-custom {
            padding: 15px 40px;
            font-size: 1.1rem;
            border-radius: 50px;
            transition: all 0.3s ease;
            text-transform: uppercase;
            font-weight: 600;
            letter-spacing: 1px;
        }
        .btn-custom:hover {
            transform: scale(1.05);
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        .stats-card {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 20px;
            margin-top: 50px;
        }
    </style>
</head>
<body>
    <!-- Hero Section -->
    <section class="hero-section">
        <!-- User Menu -->
        <div class="user-menu">
            <c:choose>
                <c:when test="${not empty sessionScope.currentUser}">
                    <div class="dropdown">
                        <button class="btn dropdown-toggle" type="button" data-bs-toggle="dropdown">
                            <i class="bi bi-person-circle me-2"></i>
                            ${sessionScope.currentUser.fullname}
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="#">
                                <i class="bi bi-person me-2"></i>Tài khoản: ${sessionScope.currentUser.id}
                            </a></li>
                            <li><a class="dropdown-item" href="#">
                                <i class="bi bi-envelope me-2"></i>${sessionScope.currentUser.email}
                            </a></li>
                            <li><hr class="dropdown-divider"></li>
                            <c:if test="${sessionScope.currentUser.admin}">
                                <li><a class="dropdown-item text-success" href="#">
                                    <i class="bi bi-shield-check me-2"></i>Admin Panel
                                </a></li>
                                <li><hr class="dropdown-divider"></li>
                            </c:if>
                            <li><a class="dropdown-item text-danger" href="<%=request.getContextPath()%>/logout">
                                <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                            </a></li>
                        </ul>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="<%=request.getContextPath()%>/login" class="btn btn-light">
                        <i class="bi bi-box-arrow-in-right me-2"></i>Đăng nhập
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6 text-center text-lg-start">
                    <h1 class="display-2 fw-bold mb-4">
                        <i class="bi bi-film"></i> PolyOE
                    </h1>
                    <p class="lead mb-4 fs-4">
                        Hệ thống quản lý video hiện đại với JPA & Hibernate
                    </p>
                    <p class="mb-5 opacity-75">
                        Lab 3 - Lập trình Java #4 | Entity Relationships & Data Access
                    </p>
                    
                    <div class="d-flex flex-column flex-md-row gap-3 justify-content-center justify-content-lg-start">
                        <a href="<%=request.getContextPath()%>/user-favorites?userId=NVT01" 
                           class="btn btn-light btn-custom">
                            <i class="bi bi-person-heart me-2"></i>Video của User
                        </a>
                        <a href="<%=request.getContextPath()%>/all-favorites" 
                           class="btn btn-outline-light btn-custom">
                            <i class="bi bi-table me-2"></i>Tất cả Favorites
                        </a>
                    </div>

                    <!-- Stats -->
                    <div class="stats-card mt-5">
                        <div class="row text-center">
                            <div class="col-4">
                                <h3 class="mb-0"><i class="bi bi-people-fill"></i></h3>
                                <p class="mb-0 small">Users</p>
                            </div>
                            <div class="col-4">
                                <h3 class="mb-0"><i class="bi bi-film"></i></h3>
                                <p class="mb-0 small">Videos</p>
                            </div>
                            <div class="col-4">
                                <h3 class="mb-0"><i class="bi bi-heart-fill"></i></h3>
                                <p class="mb-0 small">Favorites</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-6 text-center d-none d-lg-block">
                    <i class="bi bi-camera-reels" style="font-size: 20rem; opacity: 0.2;"></i>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="py-5 bg-light">
        <div class="container">
            <h2 class="text-center mb-5 fw-bold">Tính năng chính</h2>
            <div class="row g-4">
                <!-- Feature 1 -->
                <div class="col-md-3">
                    <a href="<%=request.getContextPath()%>/all-favorites" class="text-decoration-none">
                        <div class="card feature-card h-100">
                            <div class="card-body text-center p-4">
                                <i class="bi bi-heart-fill text-danger feature-icon"></i>
                                <h5 class="mt-3 mb-3">Favorites</h5>
                                <p class="text-muted small">Video yêu thích của người dùng</p>
                            </div>
                        </div>
                    </a>
                </div>

                <!-- Feature 2 -->
                <div class="col-md-3">
                    <a href="<%=request.getContextPath()%>/share-statistics" class="text-decoration-none">
                        <div class="card feature-card h-100">
                            <div class="card-body text-center p-4">
                                <i class="bi bi-share-fill text-success feature-icon"></i>
                                <h5 class="mt-3 mb-3">Shares</h5>
                                <p class="text-muted small">Thống kê chia sẻ video</p>
                            </div>
                        </div>
                    </a>
                </div>

                <!-- Feature 3 -->
                <div class="col-md-3">
                    <a href="<%=request.getContextPath()%>/user-favorites?userId=NVT01" class="text-decoration-none">
                        <div class="card feature-card h-100">
                            <div class="card-body text-center p-4">
                                <i class="bi bi-person-heart text-primary feature-icon"></i>
                                <h5 class="mt-3 mb-3">User Videos</h5>
                                <p class="text-muted small">Quản lý video cá nhân</p>
                            </div>
                        </div>
                    </a>
                </div>

                <!-- Feature 4 -->
                <div class="col-md-3">
                    <a href="<%=request.getContextPath()%>/login" class="text-decoration-none">
                        <div class="card feature-card h-100">
                            <div class="card-body text-center p-4">
                                <i class="bi bi-box-arrow-in-right text-warning feature-icon"></i>
                                <h5 class="mt-3 mb-3">Login</h5>
                                <p class="text-muted small">Đăng nhập hệ thống</p>
                            </div>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-dark text-white py-4 mt-5">
        <div class="container text-center">
            <p class="mb-0">
                <i class="bi bi-code-slash me-2"></i>
                Lab 3 - Lập trình Java #4 | 
                <i class="bi bi-calendar-event me-1"></i>
                <%= new java.text.SimpleDateFormat("yyyy").format(new java.util.Date()) %>
            </p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>