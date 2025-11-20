<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Video Yêu Thích - Online Entertainment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        html, body { height: 100%; }
        body { display: flex; flex-direction: column; }
        main { flex: 1 0 auto; }
        footer { flex-shrink: 0; }
        .page-header {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
        }
        .video-card {
            transition: all 0.3s ease;
            cursor: pointer;
            border: none;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            height: 100%;
        }
        .video-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        }
        .video-poster {
            width: 100%;
            height: 220px;
            object-fit: cover;
        }
        .views-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(0,0,0,0.75);
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
        }
        .favorite-badge {
            position: absolute;
            top: 10px;
            left: 10px;
            background: rgba(220, 53, 69, 0.9);
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
        }
    </style>
</head>
<body class="bg-light">
    
    <jsp:include page="/views/layout/header.jsp" />
    
    <main>
        <div class="page-header">
            <div class="container">
                <h1 class="display-5 fw-bold mb-2">
                    <i class="bi bi-heart-fill me-3"></i>Video Yêu Thích Của Bạn
                </h1>
                <p class="lead mb-0 opacity-90">
                    Danh sách các video bạn đã thích
                </p>
            </div>
        </div>
        
        <div class="container mb-5">
            
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="bi bi-check-circle-fill me-2"></i>${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            
            <!-- Video Grid -->
            <div class="row g-4">
                <c:choose>
                    <c:when test="${empty favorites}">
                        <div class="col-12">
                            <div class="alert alert-info text-center py-5">
                                <i class="bi bi-heart display-1 d-block mb-3"></i>
                                <h4>Chưa có video yêu thích</h4>
                                <p class="text-muted mb-3">Hãy thêm video yêu thích của bạn!</p>
                                <a href="<%=request.getContextPath()%>/" class="btn btn-primary">
                                    <i class="bi bi-house me-2"></i>Về trang chủ
                                </a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${favorites}" var="fav">
                            <div class="col-lg-4 col-md-6">
                                <div class="card video-card" 
                                     onclick="location.href='<%=request.getContextPath()%>/video-detail?id=${fav.video.id}'">
                                    
                                    <div class="position-relative">
                                        <img src="${fav.video.poster}" 
                                             class="video-poster" 
                                             alt="${fav.video.title}"
                                             onerror="this.src='https://via.placeholder.com/400x220?text=No+Image'">
                                        
                                        <span class="favorite-badge">
                                            <i class="bi bi-heart-fill me-1"></i>Yêu thích
                                        </span>
                                        
                                        <span class="views-badge">
                                            <i class="bi bi-eye-fill me-1"></i>${fav.video.views}
                                        </span>
                                    </div>
                                    
                                    <div class="card-body">
                                        <h5 class="card-title fw-bold">${fav.video.title}</h5>
                                        
                                        <p class="card-text text-muted small mb-3">
                                            <c:choose>
                                                <c:when test="${not empty fav.video.description && fav.video.description.length() > 80}">
                                                    ${fav.video.description.substring(0, 80)}...
                                                </c:when>
                                                <c:when test="${not empty fav.video.description}">
                                                    ${fav.video.description}
                                                </c:when>
                                                <c:otherwise>
                                                    <em>Nhấn để xem chi tiết</em>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        
                                        <div class="d-flex justify-content-between align-items-center">
                                            <small class="text-muted">
                                                <i class="bi bi-calendar me-1"></i>
                                                ${fav.likeDate}
                                            </small>
                                            <small class="text-primary fw-bold">
                                                <i class="bi bi-eye-fill me-1"></i>${fav.video.views} views
                                            </small>
                                        </div>
                                    </div>
                                    
                                    <div class="card-footer bg-white border-top">
                                        <div class="d-flex gap-2">
                                            <button class="btn btn-sm btn-danger flex-fill" 
                                                    onclick="event.stopPropagation(); unlikeVideo('${fav.video.id}')">
                                                <i class="bi bi-heart-fill me-1"></i>Unlike
                                            </button>
                                            <button class="btn btn-sm btn-outline-primary flex-fill"
                                                    onclick="event.stopPropagation(); shareVideo('${fav.video.id}')">
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
            
        </div>
    </main>
    
    <jsp:include page="/views/layout/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
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
            });
        }
        
        function shareVideo(videoId) {
            window.location.href = '<%=request.getContextPath()%>/share?videoId=' + videoId;
        }
    </script>
</body>
</html>