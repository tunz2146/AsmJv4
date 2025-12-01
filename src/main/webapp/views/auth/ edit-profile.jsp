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
        html, body { 
            height: 100%; 
            margin: 0;
        }
        body { 
            display: flex; 
            flex-direction: column;
            background: #f8f9fa;
        }
        main { 
            flex: 1 0 auto; 
        }
        footer { 
            flex-shrink: 0; 
        }
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .profile-card {
            max-width: 700px;
            margin: 0 auto;
        }
        .info-box {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .user-avatar {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
            margin: 0 auto 20px;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-save {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
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
                <div class="card shadow">
                    <div class="card-body p-4">
                        
                        <!-- Avatar -->
                        <div class="user-avatar">
                            <i class="bi bi-person-fill"></i>
                        </div>
                        
                        <!-- Success Messages -->
                        <c:if test="${not empty message}">
                            <div class="alert alert-success alert-dismissible fade show">
                                <i class="bi bi-check-circle-fill me-2"></i>${message}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <!-- Error Messages -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <!-- Info Box -->
                        <div class="info-box">
                            <h6 class="mb-2">
                                <i class="bi bi-info-circle me-2"></i>Thông tin tài khoản
                            </h6>
                            <div class="row">
                                <div class="col-md-6">
                                    <small class="text-muted">Tên đăng nhập:</small>
                                    <p class="mb-1 fw-bold">${sessionScope.currentUser.id}</p>
                                </div>
                                <div class="col-md-6">
                                    <small class="text-muted">Vai trò:</small>
                                    <p class="mb-1">
                                        <c:choose>
                                            <c:when test="${sessionScope.currentUser.admin}">
                                                <span class="badge bg-danger">
                                                    <i class="bi bi-shield-check me-1"></i>Quản trị viên
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-primary">
                                                    <i class="bi bi-person me-1"></i>Người dùng
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Edit Form -->
                        <form method="post" action="<%=request.getContextPath()%>/profile" id="editProfileForm">
                            
                            <!-- Username (Read-only) -->
                            <div class="mb-3">
                                <label class="form-label fw-bold">
                                    <i class="bi bi-person-fill me-1"></i>Tên đăng nhập
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light">
                                        <i class="bi bi-lock-fill"></i>
                                    </span>
                                    <input type="text" class="form-control bg-light" 
                                           value="${sessionScope.currentUser.id}" readonly>
                                </div>
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
                                           id="fullname"
                                           value="${sessionScope.currentUser.fullname}" 
                                           placeholder="Nhập họ và tên" required>
                                </div>
                                <small class="text-muted">2-50 ký tự</small>
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
                                           id="email"
                                           value="${sessionScope.currentUser.email}" 
                                           placeholder="example@email.com" required>
                                </div>
                                <small class="text-muted">Email hợp lệ</small>
                            </div>
                            
                            <!-- Quick Actions -->
                            <div class="alert alert-light border">
                                <h6 class="mb-3">
                                    <i class="bi bi-gear me-2"></i>Thao tác nhanh
                                </h6>
                                <div class="d-grid gap-2 d-md-flex">
                                    <a href="<%=request.getContextPath()%>/change-password" 
                                       class="btn btn-outline-warning btn-sm">
                                        <i class="bi bi-key me-1"></i>Đổi mật khẩu
                                    </a>
                                    <a href="<%=request.getContextPath()%>/favorites" 
                                       class="btn btn-outline-info btn-sm">
                                        <i class="bi bi-heart me-1"></i>Video yêu thích
                                    </a>
                                </div>
                            </div>
                            
                            <!-- Buttons -->
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary btn-save btn-lg">
                                    <i class="bi bi-check-circle me-2"></i>LƯU THAY ĐỔI
                                </button>
                                <a href="<%=request.getContextPath()%>/home" 
                                   class="btn btn-outline-secondary btn-lg">
                                    <i class="bi bi-x-circle me-2"></i>HỦY
                                </a>
                            </div>
                        </form>
                        
                    </div>
                </div>
                
                <!-- Additional Info Card -->
                <div class="card shadow mt-3">
                    <div class="card-body">
                        <h6 class="mb-3">
                            <i class="bi bi-shield-check me-2"></i>Bảo mật & Quyền riêng tư
                        </h6>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="d-flex align-items-center mb-2">
                                    <i class="bi bi-check-circle-fill text-success me-2"></i>
                                    <small>Thông tin được mã hóa</small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="d-flex align-items-center mb-2">
                                    <i class="bi bi-check-circle-fill text-success me-2"></i>
                                    <small>Email được bảo mật</small>
                                </div>
                            </div>
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
        document.getElementById('editProfileForm').addEventListener('submit', function(e) {
            const fullname = document.getElementById('fullname').value.trim();
            const email = document.getElementById('email').value.trim();
            
            // Check fullname length
            if (fullname.length < 2 || fullname.length > 50) {
                e.preventDefault();
                alert('Họ tên phải từ 2-50 ký tự!');
                return false;
            }
            
            // Check email format
            const emailPattern = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$/;
            if (!emailPattern.test(email)) {
                e.preventDefault();
                alert('Email không hợp lệ!');
                return false;
            }
        });
        
        // Auto-hide success message after 3 seconds
        window.addEventListener('load', function() {
            const successAlert = document.querySelector('.alert-success');
            if (successAlert) {
                setTimeout(function() {
                    const bsAlert = new bootstrap.Alert(successAlert);
                    bsAlert.close();
                }, 3000);
            }
        });
    </script>
</body>
</html>