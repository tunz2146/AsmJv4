<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập Nhật Thông Tin - Online Entertainment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        html, body { height: 100%; }
        body { display: flex; flex-direction: column; }
        main { flex: 1 0 auto; }
        footer { flex-shrink: 0; }
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        .profile-card {
            max-width: 700px;
            margin: 0 auto;
        }
    </style>
</head>
<body class="bg-light">
    
    <jsp:include page="/views/layout/header.jsp" />
    
    <main>
        <div class="page-header">
            <div class="container">
                <h2 class="mb-0">
                    <i class="bi bi-person-circle me-2"></i>Cập Nhật Thông Tin
                </h2>
            </div>
        </div>
        
        <div class="container mb-5">
            <div class="profile-card">
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
                        
                        <form method="post" action="<%=request.getContextPath()%>/profile">
                            
                            <!-- Username (Read-only) -->
                            <div class="mb-3">
                                <label class="form-label fw-bold">
                                    <i class="bi bi-person-fill me-1"></i>Tên đăng nhập
                                </label>
                                <input type="text" class="form-control" 
                                       value="${sessionScope.currentUser.username}" readonly>
                                <small class="text-muted">Không thể thay đổi tên đăng nhập</small>
                            </div>
                            
                            <!-- Fullname -->
                            <div class="mb-3">
                                <label class="form-label fw-bold">
                                    <i class="bi bi-person-badge-fill me-1"></i>Họ và tên
                                </label>
                                <input type="text" class="form-control" name="fullname" 
                                       value="${sessionScope.currentUser.fullname}" 
                                       placeholder="Nhập họ và tên" required>
                            </div>
                            
                            <!-- Email -->
                            <div class="mb-4">
                                <label class="form-label fw-bold">
                                    <i class="bi bi-envelope-fill me-1"></i>Email
                                </label>
                                <input type="email" class="form-control" name="email" 
                                       value="${sessionScope.currentUser.email}" 
                                       placeholder="example@email.com" required>
                            </div>
                            
                            <!-- User Info Display -->
                            <div class="alert alert-info">
                                <h6 class="alert-heading">
                                    <i class="bi bi-info-circle me-2"></i>Thông tin tài khoản
                                </h6>
                                <hr>
                                <p class="mb-1">
                                    <strong>Vai trò:</strong> 
                                    <c:choose>
                                        <c:when test="${sessionScope.currentUser.admin}">
                                            <span class="badge bg-danger">Quản trị viên</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-primary">Người dùng</span>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <p class="mb-0">
                                    <strong>Trạng thái:</strong> 
                                    <c:choose>
                                        <c:when test="${sessionScope.currentUser.active}">
                                            <span class="badge bg-success">Đang hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">Không hoạt động</span>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="bi bi-check-circle me-2"></i>CẬP NHẬT
                                </button>
                                <a href="<%=request.getContextPath()%>/" class="btn btn-outline-secondary">
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