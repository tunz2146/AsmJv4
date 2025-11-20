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
            padding-bottom: 56.25%; /* 16:9 ratio */
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
        .btn-action {
            transition: all 0.3s ease;
        }
        .btn-action:hover {
            transform: translateY(-2px);
        }
    </style>
</head>
<body class="bg-light">
    
    <!-- Header -->
    <jsp:include page="/views/layout/header.jsp" />

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
                            
                            <!-- Creator Info -->
                            <div class="d-flex align-items-center mb-3">
                                <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2" 
                                     style="width: 40px; height: 40px;">
                                    <i class="bi bi-person-fill"></i>
                                </div>
                                <div>
                                    <strong>${video.creatorName}</strong>
                                    <br>
                                    <small class="text-muted">
                                        <i class="bi bi-calendar3"></i>
                                        ${video.createdDate}
                                    </small>
                                </div>
                            </div>
                            
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
                                        <h4 class="mt-2 mb-0" id="likeCount">${likeCount}</h4>
                                        <small class="text-muted">Lượt thích</small>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="stat-box">
                                        <i class="bi bi-share-fill text-success" style="font-size: 2rem;"></i>
                                        <h4 class="mt-2 mb-0">${shareCount}</h4>
                                        <small class="text-muted">Chia sẻ</small>
                                    </div>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="d-flex gap-2 mb-4">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.currentUser}">
                                        <c:choose>
                                            <c:when test="${isLiked}">
                                                <button class="btn btn-danger flex-fill btn-action" 
                                                        onclick="unlikeVideo('${video.id}')">
                                                    <i class="bi bi-heart-fill me-2"></i>Đã thích
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn btn-outline-danger flex-fill btn-action" 
                                                        onclick="likeVideo('${video.id}')">
                                                    <i class="bi bi-heart me-2"></i>Yêu thích
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                        
                                        <button class="btn btn-primary flex-fill btn-action" 
                                                onclick="shareVideo('${video.id}')">
                                            <i class="bi bi-share me-2"></i>Chia sẻ
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn btn-outline-danger flex-fill" disabled>
                                            <i class="bi bi-heart me-2"></i>Đăng nhập để thích
                                        </button>
                                        <button class="btn btn-outline-primary flex-fill" disabled>
                                            <i class="bi bi-share me-2"></i>Đăng nhập để chia sẻ
                                        </button>
                                    </c:otherwise>
                                </c:choose>
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
                                    <td class="text-muted">Người đăng:</td>
                                    <td><strong>${video.creatorName}</strong></td>
                                </tr>
                                <tr>
                                    <td class="text-muted">Lượt xem:</td>
                                    <td><strong class="text-primary">${video.views}</strong></td>
                                </tr>
                                <tr>
                                    <td class="text-muted">Lượt thích:</td>
                                    <td><strong class="text-danger">${likeCount}</strong></td>
                                </tr>
                                <tr>
                                    <td class="text-muted">Chia sẻ:</td>
                                    <td><strong class="text-success">${shareCount}</strong></td>
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

                        <!-- Poster Card -->
                        <div class="info-card">
                            <h5 class="fw-bold mb-3">
                                <i class="bi bi-image me-2"></i>Poster
                            </h5>
                            <img src="${video.poster}" 
                                 class="img-fluid rounded" 
                                 alt="${video.title}"
                                 onerror="this.src='https://via.placeholder.com/400x300?text=No+Image'">
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
    <jsp:include page="/views/layout/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function likeVideo(videoId) {
            fetch('<%=request.getContextPath()%>/like-video', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'videoId=' + videoId
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert(data.message || 'Có lỗi xảy ra!');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra khi thích video!');
            });
        }

        function unlikeVideo(videoId) {
            if (!confirm('Bạn có chắc muốn bỏ thích video này?')) {
                return;
            }
            
            fetch('<%=request.getContextPath()%>/unlike-video', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'videoId=' + videoId
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert(data.message || 'Có lỗi xảy ra!');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra!');
            });
        }

        function shareVideo(videoId) {
            window.location.href = '<%=request.getContextPath()%>/share?videoId=' + videoId;
        }
    </script>
</body>
</html>