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
        body { 
            display: flex; 
            flex-direction: column;
            background: #f8f9fa;
        }
        main { flex: 1 0 auto; }
        footer { flex-shrink: 0; }
        
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        .profile-card {
            max-width: 700px;
            margin: 0 auto;
        }
        
        .info-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .btn-update {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        
        .btn-update:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
    </style>
</head>
<body>
    
    <jsp:include page="/views/layout/header.jsp" />
    
    <main>
        <div class="page-header">
            <div class="container">
                <h2 class="mb-0">
                    <i class="bi bi-person-circle me-2"></i>Cập Nhật Thông Tin
                </h2>
                <p class="mb-0 opacity-75">Chỉnh sửa thông tin cá nhân của bạn</p>
            </div>
        </div>
        
        <div class="container mb-5">
            <div class="profile-card">
                
                <!-- User Info Box -->
                <div class="info-box">
                    <div class="row align-items-center">
                        <div class="col-auto">
                            <div style="width: 80px; height: 80px; background: rgba(255,255,255,0.2); 
                                        border-radius: 50%; display: flex; align-items: center; 
                                        justify-content: center; font-size: 2.5rem;">
                                <i class="bi bi-person-fill"></i>
                            </div>
                        </div>
                        <div class="col">
                            <h4 class="mb-1">${sessionScope.currentUser.fullname}</h4>
                            <p class="mb-0 opacity-75">
                                <i class="bi bi-at"></i> ${sessionScope.currentUser.id}
                            </p>
                            <p class="mb-0 opacity-75">
                                <i class="bi bi-envelope"></i> ${sessionScope.currentUser.email}
                            </p>
                        </div>
                        <div class="col-auto">
                            <c:choose>
                                <c:when test="${sessionScope.currentUser.admin}">
                                    <span class="badge bg-danger">
                                        <i class="bi bi-shield-fill-check me-1"></i>Admin
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-light text-dark">
                                        <i class="bi bi-person me-1"></i>User
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                
                <!-- Form Card -->
                <div class="card shadow">
                    <div class="card-body p-4">
                        
                        <!-- Success Message -->
                        <c:if test="${not empty message}">
                            <div class="alert alert-success alert-dismissible fade show">
                                <i class="bi bi-check-circle-fill me-2"></i>${message}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <!-- Error Message -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <form method="post" action="<%=request.getContextPath()%>/profile" id="profileForm">
                            
                            <!-- Username (Read-only) -->
                            <div class="mb-3">
                                <label class="form-label fw-bold">
                                    <i class="bi bi-person-fill me-1"></i>Tên đăng nhập
                                </label>
                                <input type="text" class="form-control bg-light" 
                                       value="${sessionScope.currentUser.id}" readonly>
                                <small class="text-muted">
                                    <i class="bi bi-info-circle"></i> Không thể thay đổi tên đăng nhập
                                </small>
                            </div>
                            
                            <!-- Fullname -->
                            <div class="mb-3">
                                <label class="form-label fw-bold">
                                    <i class="bi bi-person-badge-fill me-1"></i>Họ và tên 
                                    <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="bi bi-person-badge"></i>
                                    </span>
                                    <input type="text" class="form-control" name="fullname" 
                                           value="${sessionScope.currentUser.fullname}" 
                                           placeholder="Nhập họ và tên" required>
                                </div>
                            </div>
                            
                            <!-- Email -->
                            <div class="mb-4">
                                <label class="form-label fw-bold">
                                    <i class="bi bi-envelope-fill me-1"></i>Email 
                                    <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="bi bi-envelope"></i>
                                    </span>
                                    <input type="email" class="form-control" name="email" 
                                           value="${sessionScope.currentUser.email}" 
                                           placeholder="example@email.com" required>
                                </div>
                            </div>
                            
                            <!-- Additional Info -->
                            <div class="alert alert-info">
                                <h6 class="alert-heading mb-2">
                                    <i class="bi bi-info-circle me-2"></i>Thông tin bổ sung
                                </h6>
                                <hr>
                                <div class="row">
                                    <div class="col-md-6">
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
                                    </div>
                                    <div class="col-md-6">
                                        <p class="mb-0">
                                            <strong>Tài khoản ID:</strong> 
                                            <code>${sessionScope.currentUser.id}</code>
                                        </p>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Buttons -->
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary btn-update btn-lg">
                                    <i class="bi bi-check-circle me-2"></i>CẬP NHẬT THÔNG TIN
                                </button>
                                <a href="<%=request.getContextPath()%>/home" class="btn btn-outline-secondary">
                                    <i class="bi bi-x-circle me-2"></i>Hủy
                                </a>
                            </div>
                        </form>
                        
                        <hr class="my-4">
                        
                        <!-- Quick Links -->
                        <div class="text-center">
                            <a href="<%=request.getContextPath()%>/change-password" 
                               class="btn btn-outline-primary btn-sm me-2">
                                <i class="bi bi-key me-1"></i>Đổi mật khẩu
                            </a>
                            <a href="<%=request.getContextPath()%>/favorites" 
                               class="btn btn-outline-success btn-sm">
                                <i class="bi bi-heart me-1"></i>Video yêu thích
                            </a>
                        </div>
                        
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="/views/layout/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form validation
        document.getElementById('profileForm').addEventListener('submit', function(e) {
            const fullname = this.fullname.value.trim();
            const email = this.email.value.trim();
            
            if (fullname.length < 2 || fullname.length > 50) {
                e.preventDefault();
                alert('Họ tên phải từ 2-50 ký tự!');
                return false;
            }
            
            // Email validation
            const emailPattern = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$/;
            if (!emailPattern.test(email)) {
                e.preventDefault();
                alert('Email không hợp lệ!');
                return false;
            }
        });
    </script>
</body>
</html>