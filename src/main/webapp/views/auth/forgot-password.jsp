<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên Mật Khẩu - Online Entertainment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .forgot-container {
            max-width: 450px;
            width: 100%;
            padding: 20px;
        }
        .forgot-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        .forgot-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
            border-radius: 20px 20px 0 0;
        }
        .forgot-body {
            padding: 40px 30px;
        }
        .btn-retrieve {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="forgot-container">
        <div class="forgot-card">
            <div class="forgot-header">
                <i class="bi bi-key-fill" style="font-size: 3.5rem;"></i>
                <h2 class="mb-0 mt-3">Quên Mật Khẩu?</h2>
                <p class="mb-0 opacity-75">Nhập email để lấy lại mật khẩu</p>
            </div>
            
            <div class="forgot-body">
                
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
                
                <form method="post" action="<%=request.getContextPath()%>/forgot-password">
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">
                            <i class="bi bi-envelope-fill me-1"></i>Email đã đăng ký
                        </label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="bi bi-envelope"></i>
                            </span>
                            <input type="email" class="form-control" name="email" 
                                   placeholder="Nhập email của bạn" required autofocus>
                        </div>
                        <small class="text-muted">
                            Chúng tôi sẽ gửi mật khẩu qua email này
                        </small>
                    </div>
                    
                    <button type="submit" class="btn btn-primary btn-retrieve w-100 mb-3">
                        <i class="bi bi-send me-2"></i>LẤY LẠI MẬT KHẨU
                    </button>
                    
                    <div class="text-center">
                        <a href="<%=request.getContextPath()%>/login" class="text-decoration-none">
                            <i class="bi bi-arrow-left me-1"></i>Quay lại đăng nhập
                        </a>
                    </div>
                </form>
                
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>