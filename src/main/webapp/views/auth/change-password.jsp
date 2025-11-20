<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi Mật Khẩu - Online Entertainment</title>
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
        .change-password-card {
            max-width: 600px;
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
                    <i class="bi bi-key me-2"></i>Đổi Mật Khẩu
                </h2>
            </div>
        </div>
        
        <div class="container mb-5">
            <div class="change-password-card">
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
                        
                        <form method="post" action="<%=request.getContextPath()%>/change-password" id="changePasswordForm">
                            
                            <!-- Current Password -->
                            <div class="mb-3">
                                <label class="form-label fw-bold">
                                    <i class="bi bi-lock-fill me-1"></i>Mật khẩu hiện tại
                                </label>
                                <input type="password" class="form-control" name="currentPassword" 
                                       placeholder="Nhập mật khẩu hiện tại" required>
                            </div>
                            
                            <!-- New Password -->
                            <div class="mb-3">
                                <label class="form-label fw-bold">
                                    <i class="bi bi-lock-fill me-1"></i>Mật khẩu mới
                                </label>
                                <input type="password" class="form-control" name="newPassword" 
                                       id="newPassword" placeholder="Nhập mật khẩu mới" required>
                                <small class="text-muted">Tối thiểu 6 ký tự</small>
                            </div>
                            
                            <!-- Confirm New Password -->
                            <div class="mb-4">
                                <label class="form-label fw-bold">
                                    <i class="bi bi-lock-fill me-1"></i>Xác nhận mật khẩu mới
                                </label>
                                <input type="password" class="form-control" name="confirmPassword" 
                                       id="confirmPassword" placeholder="Nhập lại mật khẩu mới" required>
                            </div>
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="bi bi-check-circle me-2"></i>ĐỔI MẬT KHẨU
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
    <script>
        document.getElementById('changePasswordForm').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('Mật khẩu xác nhận không khớp!');
                return false;
            }
            
            if (newPassword.length < 6) {
                e.preventDefault();
                alert('Mật khẩu phải có ít nhất 6 ký tự!');
                return false;
            }
        });
    </script>
</body>
</html>