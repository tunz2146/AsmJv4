<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - Online Entertainment</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        /* Make body flex to push footer to bottom */
        html, body {
            height: 100%;
        }
        body {
            display: flex;
            flex-direction: column;
        }
        main {
            flex: 1 0 auto;
        }
        footer {
            flex-shrink: 0;
        }
        
        /* Video Card Styles */
        .video-card {
            transition: all 0.3s ease;
            cursor: pointer;
            border: none;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            height: 100%;
        }
        .video-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        }
        .video-poster {
            width: 100%;
            height: 220px;
            object-fit: cover;
            border-radius: 8px 8px 0 0;
        }
        .views-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(0,0,0,0.75);
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        .card-title {
            height: 3em;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body class="bg-light">
    
    <!-- Include Header -->
    <jsp:include page="/views/layout/header.jsp" />
    
    <!-- Main Content -->
    <main>
        <!-- Page Header -->
        <div class="page-header">
            <div class="container">
                <div class="text-center">
                    <h1 class="display-5 fw-bold mb-2">
                        <i class="bi bi-play-circle-fill me-3"></i>
                        Welcome to Online Entertainment
                    </h1>
                    <p class="lead mb-0 opacity-90">
                        Khám phá những tiểu phẩm giải trí hấp dẫn nhất
                    </p>
                </div>
            </div>
        </div>

        <div class="container mb-5">
            
            <!-- Alert Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i>${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Video Grid -->
            <div class="row g-4 mb-5">
                <c:choose>
                    <c:when test="${empty videos}">
                        <div class="col-12">
                            <div class="alert alert-info text-center py-5">
                                <i class="bi bi-inbox display-1 d-block mb-3"></i>
                                <h4>Chưa có video nào</h4>
                                <p class="text-muted mb-0">Hãy quay lại sau nhé!</p>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${videos}" var="video">
                            <div class="col-lg-4 col-md-6">
                                <div class="card video-card" 
                                     onclick="location.href='<%=request.getContextPath()%>/video-detail?id=${video.id}'">
                                    
                                    <!-- Poster with Views Badge -->
                                    <div class="position-relative">
                                        <img src="${video.poster}" 
                                             class="video-poster" 
                                             alt="${video.title}"
                                             onerror="this.src='https://via.placeholder.com/400x220?text=No+Image'">
                                        
                                        <span class="views-badge">
                                            <i class="bi bi-eye-fill me-1"></i>${video.views}
                                        </span>
                                    </div>

                                    <!-- Card Body -->
                                    <div class="card-body">
                                        <h5 class="card-title fw-bold">${video.title}</h5>
                                        
                                        <p class="card-text text-muted small mb-3">
                                            <c:choose>
                                                <c:when test="${not empty video.description && video.description.length() > 80}">
                                                    ${video.description.substring(0, 80)}...
                                                </c:when>
                                                <c:when test="${not empty video.description}">
                                                    ${video.description}
                                                </c:when>
                                                <c:otherwise>
                                                    <em>Nhấn để xem chi tiết video</em>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        
                                        <!-- Video Info -->
                                        <div class="d-flex justify-content-between align-items-center">
                                            <small class="text-primary fw-bold">
                                                <i class="bi bi-eye-fill me-1"></i>${video.views} lượt xem
                                            </small>
                                            <small class="text-muted">
                                                <i class="bi bi-hash"></i>${video.id}
                                            </small>
                                        </div>
                                    </div>

                                    <!-- Action Buttons -->
                                    <div class="card-footer bg-white border-top">
                                        <div class="d-flex gap-2">
                                            <button class="btn btn-sm btn-outline-danger flex-fill" 
                                                    onclick="event.stopPropagation(); likeVideo('${video.id}')">
                                                <i class="bi bi-heart"></i> Like
                                            </button>
                                            <button class="btn btn-sm btn-outline-primary flex-fill"
                                                    onclick="event.stopPropagation(); shareVideo('${video.id}')">
                                                <i class="bi bi-share"></i> Share
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <nav aria-label="Video pagination">
                    <ul class="pagination justify-content-center mb-4">
                        
                        <!-- First Page -->
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="?page=1" aria-label="First">
                                <i class="bi bi-chevron-double-left"></i>
                            </a>
                        </li>
                        
                        <!-- Previous Page -->
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${currentPage - 1}" aria-label="Previous">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </li>
                        
                        <!-- Page Numbers -->
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <c:if test="${i >= currentPage - 2 && i <= currentPage + 2}">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}">${i}</a>
                                </li>
                            </c:if>
                        </c:forEach>
                        
                        <!-- Next Page -->
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${currentPage + 1}" aria-label="Next">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>
                        
                        <!-- Last Page -->
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${totalPages}" aria-label="Last">
                                <i class="bi bi-chevron-double-right"></i>
                            </a>
                        </li>
                    </ul>
                    
                    <!-- Page Info -->
                    <div class="text-center">
                        <p class="text-muted mb-0">
                            <i class="bi bi-info-circle me-1"></i>
                            Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong>
                            <span class="mx-2">•</span>
                            Tổng <strong>${totalVideos}</strong> videos
                        </p>
                    </div>
                </nav>
            </c:if>

        </div>
    </main>

    <!-- Include Footer -->
    <jsp:include page="/views/layout/footer.jsp" />

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script>
        // Like Video Function
        function likeVideo(videoId) {
            <c:choose>
                <c:when test="${empty sessionScope.currentUser}">
                    // Redirect to login
                    if (confirm('Bạn cần đăng nhập để thích video. Đăng nhập ngay?')) {
                        window.location.href = '<%=request.getContextPath()%>/login?returnUrl=' + 
                                               encodeURIComponent(window.location.href);
                    }
                </c:when>
                <c:otherwise>
                    // Call like API
                    fetch('<%=request.getContextPath()%>/like-video', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: 'videoId=' + videoId
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert('Đã thêm vào yêu thích!');
                        } else {
                            alert(data.message || 'Có lỗi xảy ra!');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Có lỗi xảy ra khi thích video!');
                    });
                </c:otherwise>
            </c:choose>
        }

        // Share Video Function
        function shareVideo(videoId) {
            <c:choose>
                <c:when test="${empty sessionScope.currentUser}">
                    if (confirm('Bạn cần đăng nhập để chia sẻ video. Đăng nhập ngay?')) {
                        window.location.href = '<%=request.getContextPath()%>/login?returnUrl=' + 
                                               encodeURIComponent(window.location.href);
                    }
                </c:when>
                <c:otherwise>
                    window.location.href = '<%=request.getContextPath()%>/share?videoId=' + videoId;
                </c:otherwise>
            </c:choose>
        }
    </script>
</body>
</html>