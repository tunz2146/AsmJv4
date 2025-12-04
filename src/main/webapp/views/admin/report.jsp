<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo Thống Kê - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        .admin-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        .stat-card {
            border-radius: 10px;
            padding: 20px;
            color: white;
            margin-bottom: 20px;
            transition: transform 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-card i {
            font-size: 2.5rem;
            opacity: 0.8;
        }
        .stat-card h3 {
            font-size: 2rem;
            font-weight: bold;
            margin: 10px 0;
        }
        .report-section {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .chart-container {
            position: relative;
            height: 300px;
        }
        .video-thumbnail {
            width: 60px;
            height: 40px;
            object-fit: cover;
            border-radius: 5px;
        }
        .badge-lg {
            font-size: 1rem;
            padding: 8px 15px;
        }
    </style>
</head>
<body class="bg-light">
    
    <!-- Header -->
    <div class="admin-header">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2><i class="bi bi-graph-up me-2"></i>Báo Cáo Thống Kê</h2>
                    <p class="mb-0">Dashboard & Analytics - Online Entertainment</p>
                </div>
                <div>
                    <a href="<%=request.getContextPath()%>/admin/videos" class="btn btn-light btn-sm me-2">
                        <i class="bi bi-film"></i> Videos
                    </a>
                    <a href="<%=request.getContextPath()%>/admin/users" class="btn btn-light btn-sm me-2">
                        <i class="bi bi-people"></i> Users
                    </a>
                    <a href="<%=request.getContextPath()%>/home" class="btn btn-outline-light btn-sm">
                        <i class="bi bi-house"></i> Home
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container mb-5">
        
        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="bi bi-exclamation-triangle me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- DASHBOARD OVERVIEW -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="stat-card" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                    <i class="bi bi-film"></i>
                    <h3>${dashboard.totalVideos}</h3>
                    <p class="mb-0">Tổng Videos</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                    <i class="bi bi-people-fill"></i>
                    <h3>${dashboard.totalUsers}</h3>
                    <p class="mb-0">Tổng Users</p>
                    <small>${dashboard.totalAdmins} Admins</small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card" style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);">
                    <i class="bi bi-heart-fill"></i>
                    <h3>${dashboard.totalFavorites}</h3>
                    <p class="mb-0">Tổng Favorites</p>
                </div>
            </div>
        </div>

        <div class="row mb-4">
            <div class="col-md-6">
                <div class="stat-card" style="background: linear-gradient(135deg, #30cfd0 0%, #330867 100%);">
                    <i class="bi bi-share-fill"></i>
                    <h3>${dashboard.totalShares}</h3>
                    <p class="mb-0">Tổng Shares</p>
                </div>
            </div>
            <div class="col-md-6">
                <div class="stat-card" style="background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);">
                    <i class="bi bi-eye-fill"></i>
                    <h3>${dashboard.totalViews}</h3>
                    <p class="mb-0">Tổng Lượt Xem</p>
                </div>
            </div>
        </div>

        <!-- CHARTS -->
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="report-section">
                    <h5 class="mb-3">
                        <i class="bi bi-graph-up text-danger me-2"></i>
                        Favorites theo tháng (2024)
                    </h5>
                    <div class="chart-container">
                        <canvas id="favoritesChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="report-section">
                    <h5 class="mb-3">
                        <i class="bi bi-graph-up text-success me-2"></i>
                        Shares theo tháng (2024)
                    </h5>
                    <div class="chart-container">
                        <canvas id="sharesChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- TOP FAVORITE VIDEOS -->
        <div class="report-section">
            <h5 class="mb-3">
                <i class="bi bi-heart-fill text-danger me-2"></i>
                Top 10 Videos Được Yêu Thích Nhất
            </h5>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th width="5%">#</th>
                            <th width="10%">Poster</th>
                            <th width="40%">Title</th>
                            <th width="15%" class="text-center">Views</th>
                            <th width="15%" class="text-center">Likes</th>
                            <th width="15%" class="text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${topFavoriteVideos}" var="video" varStatus="status">
                            <tr>
                                <td class="fw-bold">${status.index + 1}</td>
                                <td>
                                    <img src="${video.poster}" class="video-thumbnail" alt="">
                                </td>
                                <td>${video.title}</td>
                                <td class="text-center">
                                    <span class="badge bg-info">${video.views}</span>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-danger badge-lg">
                                        <i class="bi bi-heart-fill"></i> ${video.likeCount}
                                    </span>
                                </td>
                                <td class="text-center">
                                    <a href="<%=request.getContextPath()%>/video-detail?id=${video.videoId}" 
                                       class="btn btn-sm btn-outline-primary" target="_blank">
                                        <i class="bi bi-eye"></i> Xem
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- TOP VIEWED VIDEOS -->
        <div class="report-section">
            <h5 class="mb-3">
                <i class="bi bi-eye-fill text-primary me-2"></i>
                Top 10 Videos Được Xem Nhiều Nhất
            </h5>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th width="5%">#</th>
                            <th width="10%">Poster</th>
                            <th width="40%">Title</th>
                            <th width="15%" class="text-center">Views</th>
                            <th width="15%" class="text-center">Likes</th>
                            <th width="15%" class="text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${topViewedVideos}" var="video" varStatus="status">
                            <tr>
                                <td class="fw-bold">${status.index + 1}</td>
                                <td>
                                    <img src="${video.poster}" class="video-thumbnail" alt="">
                                </td>
                                <td>${video.title}</td>
                                <td class="text-center">
                                    <span class="badge bg-primary badge-lg">
                                        <i class="bi bi-eye-fill"></i> ${video.views}
                                    </span>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-danger">${video.likeCount}</span>
                                </td>
                                <td class="text-center">
                                    <a href="<%=request.getContextPath()%>/video-detail?id=${video.videoId}" 
                                       class="btn btn-sm btn-outline-primary" target="_blank">
                                        <i class="bi bi-eye"></i> Xem
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- TOP ACTIVE USERS -->
        <div class="report-section">
            <h5 class="mb-3">
                <i class="bi bi-person-hearts text-success me-2"></i>
                Top 10 Users Hoạt Động Tích Cực Nhất
            </h5>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th width="5%">#</th>
                            <th width="20%">Username</th>
                            <th width="30%">Email</th>
                            <th width="15%" class="text-center">Favorites</th>
                            <th width="15%" class="text-center">Shares</th>
                            <th width="15%" class="text-center">Tổng</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${topActiveUsers}" var="user" varStatus="status">
                            <tr>
                                <td class="fw-bold">${status.index + 1}</td>
                                <td>
                                    <i class="bi bi-person-circle text-primary me-2"></i>
                                    ${user.userId}
                                </td>
                                <td>
                                    <small class="text-muted">${user.email}</small>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-danger">${user.favoriteCount}</span>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-info">${user.shareCount}</span>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-success badge-lg">${user.totalActivity}</span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- TWO COLUMNS: TOP SHARED & INACTIVE -->
        <div class="row">
            <!-- TOP SHARED VIDEOS -->
            <div class="col-md-6">
                <div class="report-section">
                    <h5 class="mb-3">
                        <i class="bi bi-share-fill text-info me-2"></i>
                        Videos Được Share Nhiều
                    </h5>
                    <c:choose>
                        <c:when test="${empty topSharedVideos}">
                            <p class="text-muted text-center py-3">Chưa có video nào được share</p>
                        </c:when>
                        <c:otherwise>
                            <div class="list-group">
                                <c:forEach items="${topSharedVideos}" var="video" varStatus="status">
                                    <c:if test="${status.index < 5}">
                                        <div class="list-group-item">
                                            <div class="d-flex align-items-center">
                                                <img src="${video.poster}" class="video-thumbnail me-3" alt="">
                                                <div class="flex-grow-1">
                                                    <h6 class="mb-1">${video.title}</h6>
                                                    <span class="badge bg-info">
                                                        <i class="bi bi-share"></i> ${video.shareCount} shares
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- INACTIVE USERS -->
            <div class="col-md-6">
                <div class="report-section">
                    <h5 class="mb-3">
                        <i class="bi bi-person-x text-warning me-2"></i>
                        Users Không Hoạt Động
                    </h5>
                    <c:choose>
                        <c:when test="${empty inactiveUsers}">
                            <p class="text-muted text-center py-3">Tất cả users đều hoạt động!</p>
                        </c:when>
                        <c:otherwise>
                            <div class="list-group" style="max-height: 300px; overflow-y: auto;">
                                <c:forEach items="${inactiveUsers}" var="user">
                                    <div class="list-group-item">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <h6 class="mb-0">${user.userId}</h6>
                                                <small class="text-muted">${user.email}</small>
                                            </div>
                                            <span class="badge bg-warning">Inactive</span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- UNLIKED VIDEOS -->
        <c:if test="${not empty unlikedVideos}">
            <div class="report-section">
                <h5 class="mb-3">
                    <i class="bi bi-heart text-secondary me-2"></i>
                    Videos Chưa Được Like (${unlikedVideos.size()})
                </h5>
                <div class="row">
                    <c:forEach items="${unlikedVideos}" var="video" varStatus="status">
                        <c:if test="${status.index < 6}">
                            <div class="col-md-2">
                                <div class="card">
                                    <img src="${video.poster}" class="card-img-top" alt="">
                                    <div class="card-body p-2">
                                        <small class="d-block text-truncate">${video.title}</small>
                                        <small class="text-muted">${video.views} views</small>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </c:if>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Fetch and render Favorites chart
        fetch('<%=request.getContextPath()%>/admin/reports?action=chartData&type=favorites')
            .then(response => response.json())
            .then(data => {
                const ctx = document.getElementById('favoritesChart').getContext('2d');
                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'],
                        datasets: [{
                            label: 'Favorites',
                            data: data.map(d => d.total),
                            borderColor: 'rgb(220, 53, 69)',
                            backgroundColor: 'rgba(220, 53, 69, 0.1)',
                            tension: 0.4,
                            fill: true
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                display: false
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true
                            }
                        }
                    }
                });
            });

        // Fetch and render Shares chart
        fetch('<%=request.getContextPath()%>/admin/reports?action=chartData&type=shares')
            .then(response => response.json())
            .then(data => {
                const ctx = document.getElementById('sharesChart').getContext('2d');
                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'],
                        datasets: [{
                            label: 'Shares',
                            data: data.map(d => d.total),
                            backgroundColor: 'rgba(23, 162, 184, 0.8)',
                            borderColor: 'rgb(23, 162, 184)',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                display: false
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true
                            }
                        }
                    }
                });
            });
    </script>
</body>
</html>