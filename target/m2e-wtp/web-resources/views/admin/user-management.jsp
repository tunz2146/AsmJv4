<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Users - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        .admin-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        .form-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
        }
        .avatar-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            color: white;
        }
    </style>
</head>
<body class="bg-light">
    
    <!-- Header -->
    <div class="admin-header">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2><i class="bi bi-people-fill me-2"></i>Quản Lý Users</h2>
                    <p class="mb-0">Admin Panel - Online Entertainment</p>
                </div>
                <div>
                    <span class="me-3">${sessionScope.currentUser.fullname}</span>
                    <a href="<%=request.getContextPath()%>/admin/videos" class="btn btn-light btn-sm me-2">
                        <i class="bi bi-film"></i> Videos
                    </a>
                    <a href="<%=request.getContextPath()%>/home" class="btn btn-outline-light btn-sm">
                        <i class="bi bi-house"></i> Home
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container mb-5">
        
        <!-- Messages -->
        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="bi bi-check-circle me-2"></i>
                <c:choose>
                    <c:when test="${param.success == 'create'}">Tạo user thành công!</c:when>
                    <c:when test="${param.success == 'update'}">Cập nhật user thành công!</c:when>
                    <c:when test="${param.success == 'delete'}">Xóa user thành công!</c:when>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="bi bi-exclamation-triangle me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Form -->
        <div class="form-card">
            <h4 class="mb-3">
                <c:choose>
                    <c:when test="${mode == 'edit'}">
                        <i class="bi bi-pencil me-2"></i>Chỉnh Sửa User
                    </c:when>
                    <c:otherwise>
                        <i class="bi bi-plus-circle me-2"></i>Thêm User Mới
                    </c:otherwise>
                </c:choose>
            </h4>
            
            <form method="post" action="<%=request.getContextPath()%>/admin/users">
                <div class="row">
                    <!-- Username -->
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label fw-bold">
                                Username <span class="text-danger">*</span>
                            </label>
                            <input type="text" name="id" class="form-control" 
                                   value="${user.id}" 
                                   placeholder="3-20 ký tự"
                                   ${mode == 'edit' ? 'readonly' : ''} 
                                   required>
                            <small class="text-muted">
                                Chỉ chữ, số, gạch dưới và gạch ngang
                            </small>
                        </div>
                    </div>
                    
                    <!-- Fullname -->
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label fw-bold">
                                Họ và tên <span class="text-danger">*</span>
                            </label>
                            <input type="text" name="fullname" class="form-control" 
                                   value="${user.fullname}" 
                                   placeholder="Nhập họ và tên" 
                                   required>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <!-- Email -->
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label fw-bold">
                                Email <span class="text-danger">*</span>
                            </label>
                            <input type="email" name="email" class="form-control" 
                                   value="${user.email}" 
                                   placeholder="example@email.com" 
                                   required>
                        </div>
                    </div>
                    
                    <!-- Password -->
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label fw-bold">
                                Mật khẩu 
                                <c:if test="${mode == 'edit'}">
                                    <small class="text-muted">(Để trống nếu không đổi)</small>
                                </c:if>
                                <c:if test="${mode != 'edit'}">
                                    <span class="text-danger">*</span>
                                </c:if>
                            </label>
                            <input type="password" name="password" class="form-control" 
                                   placeholder="Ít nhất 6 ký tự" 
                                   ${mode != 'edit' ? 'required' : ''}>
                            <small class="text-muted">
                                Có chữ hoa, chữ thường và số
                            </small>
                        </div>
                    </div>
                </div>
                
                <!-- Admin checkbox -->
                <div class="mb-3 form-check">
                    <input type="checkbox" name="admin" class="form-check-input" id="admin"
                           ${user.admin ? 'checked' : ''}>
                    <label class="form-check-label" for="admin">
                        <strong>Admin</strong> - Cấp quyền quản trị viên
                    </label>
                </div>
                
                <!-- Action Buttons -->
                <div class="d-flex gap-2">
                    <c:choose>
                        <c:when test="${mode == 'edit'}">
                            <button type="submit" name="action" value="update" class="btn btn-warning">
                                <i class="bi bi-save me-1"></i>Update
                            </button>
                            <button type="submit" name="action" value="delete" class="btn btn-danger"
                                    onclick="return confirm('Bạn có chắc muốn xóa user này?\n\nLưu ý: Tất cả dữ liệu liên quan (favorites, shares) sẽ bị xóa!')">
                                <i class="bi bi-trash me-1"></i>Delete
                            </button>
                            <button type="submit" name="action" value="reset" class="btn btn-secondary">
                                <i class="bi bi-arrow-clockwise me-1"></i>Reset
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button type="submit" name="action" value="create" class="btn btn-primary">
                                <i class="bi bi-plus-circle me-1"></i>Create
                            </button>
                            <button type="reset" class="btn btn-secondary">
                                <i class="bi bi-x-circle me-1"></i>Clear
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </form>
        </div>

        <!-- Table -->
        <div class="card shadow">
            <div class="card-header bg-white">
                <h5 class="mb-0">
                    <i class="bi bi-list-ul me-2"></i>Danh Sách Users
                    <span class="badge bg-primary float-end">${totalUsers} users</span>
                </h5>
            </div>
            
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th width="10%">Avatar</th>
                                <th width="15%">Username</th>
                                <th width="25%">Họ và tên</th>
                                <th width="20%">Email</th>
                                <th width="10%" class="text-center">Role</th>
                                <th width="10%" class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty users}">
                                    <tr>
                                        <td colspan="6" class="text-center py-4 text-muted">
                                            <i class="bi bi-inbox" style="font-size: 3rem;"></i>
                                            <p class="mt-2">Chưa có user nào</p>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${users}" var="u">
                                        <tr>
                                            <!-- Avatar -->
                                            <td>
                                                <div class="avatar-icon" 
                                                     style="background: linear-gradient(135deg, 
                                                            ${u.admin ? '#dc3545, #c82333' : '#007bff, #0056b3'});">
                                                    ${u.fullname.substring(0, 1).toUpperCase()}
                                                </div>
                                            </td>
                                            
                                            <!-- Username -->
                                            <td>
                                                <div class="fw-bold">${u.id}</div>
                                                <c:if test="${u.id == sessionScope.currentUser.id}">
                                                    <span class="badge bg-info">You</span>
                                                </c:if>
                                            </td>
                                            
                                            <!-- Fullname -->
                                            <td>${u.fullname}</td>
                                            
                                            <!-- Email -->
                                            <td>
                                                <small class="text-muted">
                                                    <i class="bi bi-envelope me-1"></i>${u.email}
                                                </small>
                                            </td>
                                            
                                            <!-- Role -->
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${u.admin}">
                                                        <span class="badge bg-danger">
                                                            <i class="bi bi-shield-check"></i> Admin
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">
                                                            <i class="bi bi-person"></i> User
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            
                                            <!-- Action -->
                                            <td class="text-center">
                                                <a href="<%=request.getContextPath()%>/admin/users?action=edit&id=${u.id}" 
                                                   class="btn btn-sm btn-outline-primary"
                                                   title="Chỉnh sửa">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <div class="card-footer bg-white">
                    <nav>
                        <ul class="pagination pagination-sm mb-0 justify-content-center">
                            <!-- First -->
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=1">
                                    <i class="bi bi-chevron-double-left"></i>
                                </a>
                            </li>
                            
                            <!-- Previous -->
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage - 1}">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>
                            
                            <!-- Page Numbers -->
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <c:if test="${i >= currentPage - 2 && i <= currentPage + 2}">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="?page=${i}">${i}</a>
                                    </li>
                                </c:if>
                            </c:forEach>
                            
                            <!-- Next -->
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage + 1}">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>
                            
                            <!-- Last -->
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${totalPages}">
                                    <i class="bi bi-chevron-double-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                    
                    <!-- Page Info -->
                    <div class="text-center mt-2">
                        <small class="text-muted">
                            <i class="bi bi-info-circle me-1"></i>
                            Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong>
                            <span class="mx-2">•</span>
                            Tổng <strong>${totalUsers}</strong> users
                        </small>
                    </div>
                </div>
            </c:if>
        </div>
        
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Auto dismiss alerts after 5 seconds
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                var bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>