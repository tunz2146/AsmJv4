<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${video.title} - Chi Tiết Video</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        .video-container {
            position: relative;
            padding-bottom: 56.25%;
            height: 0;
            overflow: hidden;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        .video-container iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }
        .info-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .stat-box {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
        }
        
        /* Suggested Video Card Styles */
        .suggested-video-card {
            transition: all 0.3s ease;
            cursor: pointer;
            border: none;
            border-radius: 8px;
            overflow: hidden;
            background: white;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .suggested-video-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .suggested-poster {
            width: 100%;
            height: 120px;
            object-fit: cover;
        }
        .suggested-title {
            font-size: 0.9rem;
            font-weight: 600;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            line-height: 1.4;
            height: 2.8em;
        }
        .suggested-badge {
            position: absolute;
            top: 5px;
            right: 5px;
            background: rgba(0,0,0,0.7);
            color: white;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 0.75rem;
        }
    </style>
</head>
<body class="bg-light">
    
    <!-- Header -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="<%=request.getContextPath()%>/home">
                <i class="bi bi-arrow-left me-2"></i>Quay lại
            </a>
            <span class="navbar-text text-white">
                Chi tiết video
            </span>
        </div>
    </nav>

    <div class="container my-5">
        
        <c:choose>
            <c:when test="${not empty video}">
                
                <div class="row">
                    <!-- Video Player -->
                    <div class="col-lg-8 mb-4">
                        <div class="video-container">
                            <c:choose>
                                <c:when test="${not empty video.videoId}">
                                    <iframe 
                                        src="https://www.youtube.com/embed/${video.videoId}" 
                                        frameborder="0" 
                                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
                                        allowfullscreen>
                                    </iframe>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-warning m-3">
                                        <i class="bi bi-exclamation-triangle me-2"></i>
                                        Video chưa có link YouTube
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Video Info -->
                        <div class="info-card mt-3">
                            <h2 class="fw-bold mb-3">
                                <i class="bi bi-play-circle-fill text-primary me-2"></i>
                                ${video.title}
                            </h2>
                            
                            <!-- Stats Row -->
                            <div class="row g-3 mb-4">
                                <div class="col-md-4">
                                    <div class="stat-box">
                                        <i class="bi bi-eye-fill text-primary" style="font-size: 2rem;"></i>
                                        <h4 class="mt-2 mb-0">${video.views}</h4>
                                        <small class="text-muted">Lượt xem</small>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="stat-box">
                                        <i class="bi bi-heart-fill text-danger" style="font-size: 2rem;"></i>
                                        <h4 class="mt-2 mb-0">0</h4>
                                        <small class="text-muted">Lượt thích</small>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="stat-box">
                                        <i class="bi bi-share-fill text-success" style="font-size: 2rem;"></i>
                                        <h4 class="mt-2 mb-0">0</h4>
                                        <small class="text-muted">Chia sẻ</small>
                                    </div>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="d-flex gap-2 mb-4">
                                <button class="btn btn-danger flex-fill" disabled>
                                    <i class="bi bi-heart me-2"></i>Yêu thích
                                </button>
                                <button class="btn btn-primary flex-fill" disabled>
                                    <i class="bi bi-share me-2"></i>Chia sẻ
                                </button>
                            </div>

                            <!-- Description -->
                            <h5 class="mb-3">
                                <i class="bi bi-info-circle me-2"></i>Mô tả
                            </h5>
                            <p class="text-muted">
                                <c:choose>
                                    <c:when test="${not empty video.description}">
                                        ${video.description}
                                    </c:when>
                                    <c:otherwise>
                                        <em>Chưa có mô tả cho video này</em>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>

                    <!-- Sidebar -->
                    <div class="col-lg-4">
                        
                        <!-- Video Details Card -->
                        <div class="info-card mb-3">
                            <h5 class="fw-bold mb-3">
                                <i class="bi bi-info-square me-2"></i>Thông tin
                            </h5>
                            
                            <table class="table table-sm">
                                <tr>
                                    <td class="text-muted">Video ID:</td>
                                    <td><code>${video.id}</code></td>
                                </tr>
                                <tr>
                                    <td class="text-muted">YouTube ID:</td>
                                    <td><code>${video.videoId}</code></td>
                                </tr>
                                <tr>
                                    <td class="text-muted">Lượt xem:</td>
                                    <td><strong class="text-primary">${video.views}</strong></td>
                                </tr>
                                <tr>
                                    <td class="text-muted">Trạng thái:</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${video.active}">
                                                <span class="badge bg-success">Đang hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Không hoạt động</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </table>
                        </div>

                        <!-- ===== VIDEO ĐỀ CỬ ===== -->
                        <div class="info-card">
                            <h5 class="fw-bold mb-3">
                                <i class="bi bi-collection-play me-2"></i>Video đề cử
                            </h5>
                            
                            <c:choose>
                                <c:when test="${empty suggestedVideos}">
                                    <p class="text-muted text-center mb-0">
                                        <em>Chưa có video đề cử</em>
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <div class="d-flex flex-column gap-3">
                                        <c:forEach items="${suggestedVideos}" var="suggested">
                                            <div class="suggested-video-card" 
                                                 onclick="location.href='<%=request.getContextPath()%>/video-detail?id=${suggested.id}'">
                                                
                                                <!-- Poster -->
                                                <div class="position-relative">
                                                    <img src="${suggested.poster}" 
                                                         class="suggested-poster" 
                                                         alt="${suggested.title}"
                                                         onerror="this.src='https://via.placeholder.com/300x120?text=No+Image'">
                                                    
                                                    <span class="suggested-badge">
                                                        <i class="bi bi-eye-fill me-1"></i>${suggested.views}
                                                    </span>
                                                </div>
                                                
                                                <!-- Info -->
                                                <div class="p-2">
                                                    <p class="suggested-title mb-1">${suggested.title}</p>
                                                    <small class="text-muted">
                                                        <i class="bi bi-hash"></i>${suggested.id}
                                                    </small>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                    </div>
                </div>

            </c:when>
            <c:otherwise>
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-triangle me-2"></i>
                    Không tìm thấy video!
                </div>
                <a href="<%=request.getContextPath()%>/home" class="btn btn-primary">
                    <i class="bi bi-arrow-left me-2"></i>Quay lại trang chủ
                </a>
            </c:otherwise>
        </c:choose>

    </div>

    <!-- Footer -->
    <footer class="bg-dark text-white py-4 mt-5">
        <div class="container text-center">
            <p class="mb-0">
                <i class="bi bi-code-slash me-2"></i>
                Online Entertainment &copy; 2024
            </p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>