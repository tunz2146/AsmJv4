<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chia Sẻ Video - Online Entertainment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        html, body { height: 100%; }
        body { display: flex; flex-direction: column; }
        main { flex: 1 0 auto; }
        footer { flex-shrink: 0; }
        .page-header {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        .share-card {
            max-width: 700px;
            margin: 0 auto;
        }
        .video-preview {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .video-preview img {
            width: 100%;
            max-width: 300px;
            border-radius: 8px;
        }
    </style>
</head>
<body class="bg-light">
    
    <jsp:include page="/views/layout/header.jsp" />
    
    <main>
        <div class="page-header">
            <div class="container">
                <h2 class="mb-0">
                    <i class="bi bi-share me-2"></i>Chia Sẻ Video
                </h2>
            </div>
        </div>
        
        <div class="container mb-5">
            <div class="share-card">
                <div class="card shadow">
                    <div class="card-body p-4">
                        
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty message}">
                            <div class="alert alert-success alert-dismissible fade show">
                                <i class="bi bi-check-circle-fill me-2"></i>${message}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <!-- Video Preview -->
                        <c:if test="${not empty video}">
                            <div class="video-preview text-center">
                                <h5 class="mb-3">
                                    <i class="bi bi-film me-2"></i>Video được chia sẻ
                                </h5>
                                <img src="${video.poster}" alt="${video.title}" 
                                     onerror="this.src='https://via.placeholder.com/300x200?text=No+Image'">
                                <h6 class="mt-3 fw-bold">${video.title}</h6>
                                <p class="text-muted small mb-0">
                                    <i class="bi bi-eye me-1"></i>${video.views} lượt xem
                                </p>
                            </div>
                        </c:if>
                        
                        <!-- Share Form -->
                        <form method="post" action="<%=request.getContextPath()%>/share">
                            <input type="hidden" name="videoId" value="${video.id}">
                            
                            <div class="mb-3">
                                <label class="form-label fw-bold">
                                    <i class="bi bi-envelope-fill me-1"></i>
                                    Email người nhận
                                </label>
                                <textarea class="form-control" name="emails" rows="4" 
                                          placeholder="Nhập email người nhận (cách nhau bằng dấu phẩy hoặc chấm phẩy)&#10;Ví dụ: friend1@email.com, friend2@email.com" 
                                          required></textarea>
                                <small class="text-muted">
                                    Có thể gửi cho nhiều người cùng lúc
                                </small>
                            </div>
                            
                            <div class="mb-4">
                                <label class="form-label fw-bold">
                                    <i class="bi bi-chat-left-text-fill me-1"></i>
                                    Lời nhắn (không bắt buộc)
                                </label>
                                <textarea class="form-control" name="message" rows="3" 
                                          placeholder="Thêm lời nhắn cho người nhận..."></textarea>
                            </div>
                            
                            <!-- Video Link Preview -->
                            <div class="alert alert-info">
                                <h6 class="alert-heading">
                                    <i class="bi bi-link-45deg me-2"></i>Link video
                                </h6>
                                <p class="mb-0 small">
                                    <code><%=request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath()%>/video-detail?id=${video.id}</code>
                                </p>
                            </div>
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="bi bi-send me-2"></i>GỬI EMAIL
                                </button>
                                <a href="<%=request.getContextPath()%>/video-detail?id=${video.id}" 
                                   class="btn btn-outline-secondary">
                                    <i class="bi bi-x-circle me-2"></i>Hủy
                                </a>
                            </div>
                        </form>
                        
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="/views/layout/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>