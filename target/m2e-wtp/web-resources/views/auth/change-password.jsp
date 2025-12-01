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
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .password-card {
            max-width: 600px;
            margin: 0 auto;
        }
        .password-strength {
            height: 5px;
            border-radius: 3px;
            margin-top: 5px;
            transition: all 0.3s;
        }
        .strength-weak { background: #dc3545; width: 33%; }
        .strength-medium { background: #ffc107; width: 66%; }
        .strength-strong { background: #28a745; width: 100%; }
        .btn-change {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            border: none;
        }
        .btn-change:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(245, 87, 108, 0.4);
        }
        .security-tips {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 15px;
            border-radius: 5px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    
    <jsp:include page="/views/layout/header.jsp" />
    
    <main>
        <div class="page-header">
            <div class="container">
                <h2 class="mb-0">
                    <i class="bi bi-key me-2"></i>Đổi Mật Khẩu
                </h2>
                <p class="mb-0 opacity-75">Bảo mật tài khoản của bạn</p>
            </div>
        </div>
        
        <div class="container mb-5">
            <div class="password-card">
                <div class="card shadow">
                    <div class="card-body p-4">
                        
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
                        
                        <!-- Change Password Form -->
                        <form method="post" action="<%=request.getContextPath()%>/change-password" 
                              id="changePasswordForm">
                            
                            <!-- Current Password -->
                            <div class="mb-3">
                                <label class="form-label fw-bold">
                                    <i class="bi bi-lock-fill me-1"></i>Mật khẩu hiện tại
                                    <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="bi bi-lock"></i>
                                    </span>
                                    <input type="password" class="form-control" 
                                           name="currentPassword" id="currentPassword"
                                           placeholder="Nhập mật khẩu hiện tại" required>
                                    <button class="btn btn-outline-secondary" type="button" 
                                            onclick="togglePassword('currentPassword', this)">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                </div>
                            </div>
                            
                            <!-- New Password -->
                            <div class="mb-3">
                                <label class="form-label fw-bold">
                                    <i class="bi bi-lock-fill me-1"></i>Mật khẩu mới
                                    <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="bi bi-key"></i>
                                    </span>
                                    <input type="password" class="form-control" 
                                           name="newPassword" id="newPassword"
                                           placeholder="Nhập mật khẩu mới" required>
                                    <button class="btn btn-outline-secondary" type="button" 
                                            onclick="togglePassword('newPassword', this)">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                </div>
                                <div class="password-strength" id="passwordStrength"></div>
                                <small class="text-muted">
                                    Ít nhất 6 ký tự, có chữ hoa, chữ thường và số
                                </small>
                            </div>
                            
                            <!-- Confirm New Password -->
                            <div class="mb-4">
                                <label class="form-label fw-bold">
                                    <i class="bi bi-lock-fill me-1"></i>Xác nhận mật khẩu mới
                                    <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="bi bi-shield-check"></i>
                                    </span>
                                    <input type="password" class="form-control" 
                                           name="confirmPassword" id="confirmPassword"
                                           placeholder="Nhập lại mật khẩu mới" required>
                                    <button class="btn btn-outline-secondary" type="button" 
                                            onclick="togglePassword('confirmPassword', this)">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                </div>
                                <small class="text-danger d-none" id="passwordMatchError">
                                    <i class="bi bi-exclamation-circle"></i> Mật khẩu không khớp
                                </small>
                            </div>
                            
                            <!-- Buttons -->
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary btn-change btn-lg">
                                    <i class="bi bi-check-circle me-2"></i>ĐỔI MẬT KHẨU
                                </button>
                                <a href="<%=request.getContextPath()%>/profile" 
                                   class="btn btn-outline-secondary btn-lg">
                                    <i class="bi bi-x-circle me-2"></i>HỦY
                                </a>
                            </div>
                        </form>
                        
                        <!-- Security Tips -->
                        <div class="security-tips">
                            <h6 class="mb-2">
                                <i class="bi bi-lightbulb me-2"></i>Mẹo bảo mật
                            </h6>
                            <ul class="small mb-0">
                                <li>Sử dụng mật khẩu mạnh và duy nhất</li>
                                <li>Không chia sẻ mật khẩu với người khác</li>
                                <li>Thay đổi mật khẩu định kỳ (3-6 tháng)</li>
                                <li>Không sử dụng thông tin cá nhân dễ đoán</li>
                            </ul>
                        </div>
                        
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="/views/layout/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Toggle password visibility
        function togglePassword(inputId, button) {
            const input = document.getElementById(inputId);
            const icon = button.querySelector('i');
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('bi-eye');
                icon.classList.add('bi-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('bi-eye-slash');
                icon.classList.add('bi-eye');
            }
        }
        
        // Password strength indicator
        document.getElementById('newPassword').addEventListener('input', function() {
            const password = this.value;
            const strengthBar = document.getElementById('passwordStrength');
            
            let strength = 0;
            if (password.length >= 6) strength++;
            if (/[a-z]/.test(password)) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            
            strengthBar.className = 'password-strength';
            if (strength >= 4) {
                strengthBar.classList.add('strength-strong');
            } else if (strength >= 2) {
                strengthBar.classList.add('strength-medium');
            } else if (strength >= 1) {
                strengthBar.classList.add('strength-weak');
            }
        });
        
        // Check password match
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = this.value;
            const errorMsg = document.getElementById('passwordMatchError');
            
            if (confirmPassword && newPassword !== confirmPassword) {
                errorMsg.classList.remove('d-none');
            } else {
                errorMsg.classList.add('d-none');
            }
        });
        
        // Form validation
        document.getElementById('changePasswordForm').addEventListener('submit', function(e) {
            const currentPassword = document.getElementById('currentPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            // Check all fields filled
            if (!currentPassword || !newPassword || !confirmPassword) {
                e.preventDefault();
                alert('Vui lòng điền đầy đủ thông tin!');
                return false;
            }
            
            // Check password match
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('Mật khẩu xác nhận không khớp!');
                return false;
            }
            
            // Check password length
            if (newPassword.length < 6) {
                e.preventDefault();
                alert('Mật khẩu phải có ít nhất 6 ký tự!');
                return false;
            }
            
            // Check password strength
            if (!/(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/.test(newPassword)) {
                e.preventDefault();
                alert('Mật khẩu phải bao gồm chữ hoa, chữ thường và số!');
                return false;
            }
            
            // Check new password different from current
            if (newPassword === currentPassword) {
                e.preventDefault();
                alert('Mật khẩu mới phải khác mật khẩu hiện tại!');
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