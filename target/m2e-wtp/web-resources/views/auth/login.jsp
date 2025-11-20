<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - PolyOE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .login-container {
            max-width: 450px;
            width: 100%;
            padding: 20px;
        }
        .login-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
        }
        .login-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
        }
        .login-header i {
            font-size: 4rem;
            margin-bottom: 15px;
        }
        .login-body {
            padding: 40px 30px;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px;
            font-weight: 600;
            letter-spacing: 1px;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
        }
        .input-group-text {
            background: #f8f9fa;
            border-right: none;
        }
        .form-control {
            border-left: none;
        }
        .alert {
            border-radius: 10px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-card">
            <div class="login-header">
                <i class="bi bi-film"></i>
                <h2 class="mb-0">Tunz</h2>
                <p class="mb-0 opacity-75">Welcome to Online Entertainment</p>
            </div>
            
            <div class="login-body">
                <h4 class="text-center mb-4">Đăng Nhập</h4>
                
                <!-- Messages -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <c:if test="${param.message == 'logout'}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>
                        Đăng xuất thành công!
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <c:if test="${param.message == 'register_success'}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>
                        Đăng ký thành công! Vui lòng đăng nhập.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <c:if test="${param.message == 'required'}">
                    <div class="alert alert-warning alert-dismissible fade show" role="alert">
                        <i class="bi bi-info-circle-fill me-2"></i>
                        Vui lòng đăng nhập để tiếp tục!
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <!-- Login Form -->
                <form method="post" action="<%=request.getContextPath()%>/login">
                    <div class="mb-3">
                        <label class="form-label fw-bold">
                            <i class="bi bi-person-fill me-1"></i>Tên đăng nhập
                        </label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="bi bi-person"></i>
                            </span>
                            <input type="text" 
                                   class="form-control" 
                                   name="username" 
                                   placeholder="Nhập tên đăng nhập"
                                   value="${username}"
                                   required 
                                   autofocus>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">
                            <i class="bi bi-lock-fill me-1"></i>Mật khẩu
                        </label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="bi bi-lock"></i>
                            </span>
                            <input type="password" 
                                   class="form-control" 
                                   name="password" 
                                   placeholder="Nhập mật khẩu"
                                   required>
                        </div>
                    </div>
                    
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="remember" name="remember">
                        <label class="form-check-label" for="remember">
                            Ghi nhớ đăng nhập
                        </label>
                    </div>
                    
                    <button type="submit" class="btn btn-primary btn-login w-100">
                        <i class="bi bi-box-arrow-in-right me-2"></i>
                        ĐĂNG NHẬP
                    </button>
                </form>
                
                <hr class="my-4">
                
                <div class="text-center">
                    <p class="mb-2 text-muted">
                        <i class="bi bi-info-circle me-1"></i>
                        Nếu bạn chưa có tài khoản:
                        <a href="<%=request.getContextPath()%>/views/auth/registration.jsp" class="text-decoration-none fw-bold">
                            Đăng Ký ngay
                        </a>
                    </p>
                </div>
                
                <div class="text-center mt-3">
                    <a href="<%=request.getContextPath()%>/home" class="text-decoration-none">
                        <i class="bi bi-arrow-left me-1"></i>
                        Quay lại trang chủ
                    </a>
                </div>
            </div>
        </div>
        
        <div class="text-center mt-3 text-white">
            <small>© Online Entertainment Tunz 2024</small>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>