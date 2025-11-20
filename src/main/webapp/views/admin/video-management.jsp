<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Videos - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        .admin-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
        }
        .form-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
        }
    </style>
</head>
<body class="bg-light">
    <!-- Header -->
    <div class="admin-header">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2><i class="bi bi-film me-2"></i>Quản Lý Videos</h2>
                    <p class="mb-0">Admin Panel - YouTuBee</p>
                </div>
                <div>
                    <span class="me-3">${sessionScope.currentUser.fullname}</span>
                    <a href="<%=request.getContextPath()%>/admin/users" class="btn btn-light btn-sm me-2">
                        <i class="bi bi-people"></i> Users
                    </a>
                    <a href="<%=request.getContextPath()%>/home" class="btn btn-outline-light btn-sm">
                        <i class="bi bi-house"></i> Home
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container my-4">
        <!-- Messages -->
        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="bi bi-check-circle me-2"></i>
                <c:choose>
                    <c:when test="${param.success == 'create'}">Tạo video thành công!</c:when>
                    <c:when test="${param.success == 'update'}">Cập nhật video thành công!</c:when>
                    <c:when test="${param.success == 'delete'}">Xóa video thành công!</c:when>
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
                        <i class="bi bi-pencil me-2"></i>Chỉnh Sửa Video
                    </c:when>
                    <c:otherwise>
                        <i class="bi bi-plus-circle me-2"></i>Thêm Video Mới
                    </c:otherwise>
                </c:choose>
            </h4>
            
            <form method="post" action="<%=request.getContextPath()%>/admin/videos">
                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Video ID <span class="text-danger">*</span></label>
                            <input type="text" name="id" class="form-control" 
                                   value="${video.id}" placeholder="VID001"
                                   ${mode == 'edit' ? 'readonly' : ''} required>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Title <span class="text-danger">*</span></label>
                            <input type="text" name="title" class="form-control" 
                                   value="${video.title}" placeholder="Tên video" required>
                        </div>
                    </div>
                </div>
                
                <div class="mb-3">
                    <label class="form-label fw-bold">YouTube URL <span class="text-danger">*</span></label>
                    <input type="text" name="videoUrl" class="form-control" 
                           value="${video.videoUrl}" 
                           placeholder="https://www.youtube.com/watch?v=..." required>
                    <small class="text-muted">
                        <i class="bi bi-info-circle"></i>
                        Dán link YouTube đầy đủ. VD: https://www.youtube.com/watch?v=Tmoe6fjpnKY
                    </small>
                </div>
                
                <div class="mb-3">
                    <label class="form-label fw-bold">Description</label>
                    <textarea name="description" class="form-control" rows="3" 
                              placeholder="Mô tả video...">${video.description}</textarea>
                </div>
                
                <div class="mb-3 form-check">
                    <input type="checkbox" name="active" class="form-check-input" id="active"
                           ${video.active == null || video.active ? 'checked' : ''}>
                    <label class="form-check-label" for="active">Active (Hiển thị video)</label>
                </div>
                
                <div class="d-flex gap-2">
                    <c:choose>
                        <c:when test="${mode == 'edit'}">
                            <button type="submit" name="action" value="update" class="btn btn-warning">
                                <i class="bi bi-save me-1"></i>Update
                            </button>
                            <button type="submit" name="action" value="delete" class="btn btn-danger"
                                    onclick="return confirm('Bạn có chắc muốn xóa video này?')">
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
                    <i class="bi bi-list-ul me-2"></i>Danh Sách Videos
                    <span class="badge bg-primary float-end">${totalVideos} videos</span>
                </h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th width="10%">ID</th>
                                <th width="25%">Title</th>
                                <th width="15%">Video ID</th>
                                <th width="10%" class="text-center">Views</th>
                                <th width="10%" class="text-center">Active</th>
                                <th width="10%" class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty videos}">
                                    <tr>
                                        <td colspan="6" class="text-center py-4 text-muted">
                                            <i class="bi bi-inbox" style="font-size: 3rem;"></i>
                                            <p class="mt-2">Chưa có video nào</p>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${videos}" var="v">
                                        <tr>
                                            <td class="fw-bold">${v.id}</td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="${v.poster}" 
                                                         style="width:60px; height:40px; object-fit:cover;"
                                                         class="rounded me-2" alt="Poster">
                                                    <span>${v.title}</span>
                                                </div>
                                            </td>
                                            <td>
                                                <code>${v.videoId}</code>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge bg-info">${v.views}</span>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${v.active}">
                                                        <i class="bi bi-check-circle-fill text-success"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="bi bi-x-circle-fill text-danger"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <a href="<%=request.getContextPath()%>/admin/videos?action=edit&id=${v.id}" 
                                                   class="btn btn-sm btn-outline-primary">
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
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=1">|&lt;</a>
                            </li>
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage - 1}">&lt;&lt;</a>
                            </li>
                            
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}">${i}</a>
                                </li>
                            </c:forEach>
                            
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage + 1}">&gt;&gt;</a>
                            </li>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${totalPages}">&gt;|</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </c:if>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>