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
        html, body { height: 100%; }
        body { display: flex; flex-direction: column; }
        main { flex: 1 0 auto; }
        footer { flex-shrink: 0; }
        
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
        
        /* Suggested Videos Styles */
        .suggested-video-card {
            cursor: pointer;
            transition: all 0.2s ease;
            border-radius: 8px;
            overflow: hidden;
            background: white;
            margin-bottom: 15px;
        }
        .suggested-video-card:hover {
            transform: translateX(5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .suggested-video-img {
            width: 120px;
            height: 70px;
            object-fit: cover;
        }
        .suggested-video-title {
            font-size: 0.9rem;
            font-weight: 600;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .suggested-section {
            position: sticky;
            top: 20px;
        }
    </style>
</head>
<body class="bg-light">
    
    <jsp:include page="/views/layout/header.jsp" />

    <main>
        <div class="container my-4">
            
            <c:choose>
                <c:when test="${not empty video}">
                    
                    <div class="row">
                        <!-- LEFT: Video Player + Info -->
                        <div class="col-lg-8 mb-4">
                            
                            <!-- Video Player -->
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
                                
                                <!-- Video Details Table -->
                                <hr>
                                <h6 class="fw-bold mb-3">
                                    <i class="bi bi-info-square me-2"></i>Chi tiết
                                </h6>
                                <table class="table table-sm table-borderless">
                                    <tr>
                                        <td class="text-muted" width="30%">Video ID:</td>
                                        <td><code>${video.id}</code></td>
                                    </tr>
                                    <tr>
                                        <td class="text-muted">YouTube ID:</td>
                                        <td><code>${video.videoId}</code></td>
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
                        </div>

                        <!-- RIGHT: Suggested Videos -->
                        <div class="col-lg-4">
                            <div class="suggested-section">
                                <div class="info-card">
                                    <h5 class="fw-bold mb-4">
                                        <i class="bi bi-collection-play me-2"></i>
                                        Video đề xuất cho bạn
                                    </h5>
                                    
                                    <!-- DEBUG: Kiểm tra suggestedVideos -->
                                    <c:if test="${not empty suggestedVideos}">
                                        <p class="text-success small mb-3">
                                            <i class="bi bi-check-circle"></i> 
                                            Tìm thấy ${suggestedVideos.size()} video đề xuất
                                        </p>
                                    </c:if>
                                    
                                    <c:choose>
                                        <c:when test="${empty suggestedVideos}">
                                            <div class="alert alert-warning text-center">
                                                <i class="bi bi-inbox"></i>
                                                <p class="mb-0"><em>Chưa có video đề xuất</em></p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach items="${suggestedVideos}" var="sv">
                                                <div class="suggested-video-card d-flex p-2" 
                                                     onclick="location.href='<%=request.getContextPath()%>/video-detail?id=${sv.id}'">
                                                    
                                                    <!-- Thumbnail -->
                                                    <img src="${sv.poster}" 
                                                         class="suggested-video-img rounded" 
                                                         alt="${sv.title}"
                                                         onerror="this.src='https://via.placeholder.com/120x70?text=No+Image'">
                                                    
                                                    <!-- Info -->
                                                    <div class="flex-grow-1 ps-3 d-flex flex-column justify-content-center">
                                                        <div class="suggested-video-title mb-1">
                                                            ${sv.title}
                                                        </div>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <small class="text-muted">
                                                                <i class="bi bi-eye-fill"></i>
                                                                ${sv.views}
                                                            </small>
                                                            <small class="text-muted">
                                                                <code>${sv.id}</code>
                                                            </small>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <!-- Poster Card (Optional) -->
                                <div class="info-card mt-3">
                                    <h6 class="fw-bold mb-3">
                                        <i class="bi bi-image me-2"></i>Poster
                                    </h6>
                                    <img src="${video.poster}" 
                                         class="img-fluid rounded" 
                                         alt="${video.title}"
                                         onerror="this.src='https://via.placeholder.com/400x300?text=No+Image'">
                                </div>
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
    </main>

    <jsp:include page="/views/layout/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>