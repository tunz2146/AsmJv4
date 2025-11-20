<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - Online Entertainment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px 0;
        }
        .register-container {
            max-width: 600px;
            width: 100%;
        }
        .register-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
        }
        .register-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .register-body {
            padding: 40px;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-register {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px;
            font-weight: 600;
        }
        .input-group-text {
            background: #f8f9fa;
            border-right: none;
        }
        .form-control {
            border-left: none;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-card">
            <div class="register-header">
                <i class="bi bi-person-plus-fill" style="font-size: 3rem;"></i>
                <h2 class="mb-0 mt-3">Đăng Ký Tài Khoản</h2>
                <p class="mb-0 opacity-75">Tham gia cùng Online Entertainment</p>
            </div>
            
            <div class="register-body">
                
                <!-- Messages -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <!-- Registration Form -->
                <form method="post" action="<%=request.getContextPath()%>/register" id="registerForm">
                    
                    <!-- Username -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">
                            <i class="bi bi-person-fill me-1"></i>Tên đăng nhập <span class="text-danger">*</span>
                        </label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person"></i></span>
                            <input type="text" class="form-control" name="username" 
                                   placeholder="Nhập tên đăng nhập" value="${username}" required>
                        </div>
                        <small class="text-muted">3-20 ký tự, chỉ chữ, số, gạch dưới và gạch ngang</small>
                    </div>
                    
                    <!-- Password -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">
                            <i class="bi bi-lock-fill me-1"></i>Mật khẩu <span class="text-danger">*</span>
                        </label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-lock"></i></span>
                            <input type="password" class="form-control" name="password" 
                                   id="password" placeholder="Nhập mật khẩu" required>
                        </div>
                        <small class="text-muted">Ít nhất 6 ký tự, có chữ hoa, chữ thường và số</small>
                    </div>
                    
                    <!-- Confirm Password -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">
                            <i class="bi bi-lock-fill me-1"></i>Xác nhận mật khẩu <span class="text-danger">*</span>
                        </label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-lock"></i></span>
                            <input type="password" class="form-control" name="confirmPassword" 
                                   id="confirmPassword" placeholder="Nhập lại mật khẩu" required>
                        </div>
                    </div>
                    
                    <!-- Fullname -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">
                            <i class="bi bi-person-badge-fill me-1"></i>Họ và tên <span class="text-danger">*</span>
                        </label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person-badge"></i></span>
                            <input type="text" class="form-control" name="fullname" 
                                   placeholder="Nhập họ và tên" value="${fullname}" required>
                        </div>
                    </div>
                    
                    <!-- Email -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">
                            <i class="bi bi-envelope-fill me-1"></i>Email <span class="text-danger">*</span>
                        </label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                            <input type="email" class="form-control" name="email" 
                                   placeholder="example@email.com" value="${email}" required>
                        </div>
                    </div>
                    
                    <!-- Terms & Conditions -->
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="terms" required>
                        <label class="form-check-label" for="terms">
                            Tôi đồng ý với <a href="#" class="text-decoration-none">Điều khoản sử dụng</a>
                        </label>
                    </div>
                    
                    <button type="submit" class="btn btn-primary btn-register w-100">
                        <i class="bi bi-person-plus me-2"></i>ĐĂNG KÝ
                    </button>
                </form>
                
                <hr class="my-4">
                
                <div class="text-center">
                    <p class="mb-0">
                        Đã có tài khoản? 
                        <a href="<%=request.getContextPath()%>/login" class="text-decoration-none fw-bold">
                            Đăng nhập ngay
                        </a>
                    </p>
                </div>
                
                <div class="text-center mt-3">
                    <a href="<%=request.getContextPath()%>/home" class="text-decoration-none">
                        <i class="bi bi-arrow-left me-1"></i>Quay lại trang chủ
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form validation
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Mật khẩu xác nhận không khớp!');
                return false;
            }
            
            if (password.length < 6) {
                e.preventDefault();
                alert('Mật khẩu phải có ít nhất 6 ký tự!');
                return false;
            }
            
            // Kiểm tra password có chữ hoa, chữ thường và số
            const hasUpperCase = /[A-Z]/.test(password);
            const hasLowerCase = /[a-z]/.test(password);
            const hasNumber = /\d/.test(password);
            
            if (!hasUpperCase || !hasLowerCase || !hasNumber) {
                e.preventDefault();
                alert('Mật khẩu phải có ít nhất 1 chữ hoa, 1 chữ thường và 1 số!');
                return false;
            }
        });
    </script>
</body>
</html>