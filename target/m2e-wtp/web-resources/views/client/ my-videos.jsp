<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Video Của Tôi - Online Entertainment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        html, body { height: 100%; }
        body { display: flex; flex-direction: column; background: #f8f9fa; }
        main { flex: 1 0 auto; }
        footer { flex-shrink: 0; }
        
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .form-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }
        
        .video-table-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }
        
        .btn-action {
            padding: 5px 15px;
            font-size: 0.875rem;
        }
        
        .video-thumbnail {
            width: 80px;
            height: 50px;
            object-fit: cover;
            border-radius: 5px;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }
        
        .empty-state i {
            font-size: 5rem;
            color: #dee2e6;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    
    <!-- Include Header -->
    <jsp:include page="/views/layout/header.jsp" />
    
    <main>
        <!-- Page Header -->
        <div class="page-header">
            <div class="container">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="mb-2">
                            <i class="bi bi-camera-video me-2"></i>Video Của Tôi
                        </h2>
                        <p class="mb-0 opacity-90">
                            Quản lý các video bạn đã đăng tải
                        </p>
                    </div>
                    <div>
                        <span class="badge bg-light text-dark fs-6">
                            <i class="bi bi-collection-play me-1"></i>
                            ${totalVideos} videos
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <div class="container mb-5">
            
            <!-- Alert Messages -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="bi bi-check-circle-fill me-2"></i>
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
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Form Create/Edit -->
            <div class="form-card">
                <h4 class="mb-4">
                    <c:choose>
                        <c:when test="${mode == 'edit'}">
                            <i class="bi bi-pencil-square me-2"></i>Chỉnh Sửa Video
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-plus-circle me-2"></i>Đăng Video Mới
                        </c:otherwise>
                    </c:choose>
                </h4>
                
                <form method="post" action="<%=request.getContextPath()%>/my-videos" id="videoForm">
                    <div class="row">
                        <!-- Video ID -->
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">
                                Video ID <span class="text-danger">*</span>
                            </label>
                            <input type="text" name="id" class="form-control" 
                                   value="${video.id}" 
                                   placeholder="vd: my_video_001"
                                   ${mode == 'edit' ? 'readonly' : ''} 
                                   required>
                            <small class="text-muted">
                                <i class="bi bi-info-circle"></i>
                                3-20 ký tự, chỉ chữ, số, gạch dưới và gạch ngang
                            </small>
                        </div>
                        
                        <!-- Title -->
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">
                                Tiêu đề <span class="text-danger">*</span>
                            </label>
                            <input type="text" name="title" class="form-control" 
                                   value="${video.title}" 
                                   placeholder="Nhập tiêu đề video" 
                                   required>
                        </div>
                    </div>
                    
                    <!-- YouTube URL -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">
                            Link YouTube <span class="text-danger">*</span>
                        </label>
                        <input type="text" name="videoUrl" class="form-control" 
                               value="${video.videoUrl}" 
                               placeholder="https://www.youtube.com/watch?v=..." 
                               required>
                        <small class="text-muted">
                            <i class="bi bi-youtube text-danger"></i>
                            Dán link YouTube đầy đủ. VD: https://www.youtube.com/watch?v=dQw4w9WgXcQ
                        </small>
                    </div>
                    
                    <!-- Description -->
                    <div class="mb-4">
                        <label class="form-label fw-bold">Mô tả</label>
                        <textarea name="description" class="form-control" rows="4" 
                                  placeholder="Nhập mô tả về video của bạn...">${video.description}</textarea>
                        <small class="text-muted">Tối đa 500 ký tự</small>
                    </div>
                    
                    <!-- Action Buttons -->
                    <div class="d-flex gap-2">
                        <c:choose>
                            <c:when test="${mode == 'edit'}">
                                <button type="submit" name="action" value="update" class="btn btn-warning">
                                    <i class="bi bi-save me-1"></i>Cập Nhật
                                </button>
                                <button type="submit" name="action" value="delete" class="btn btn-danger"
                                        onclick="return confirm('Bạn có chắc muốn xóa video này?')">
                                    <i class="bi bi-trash me-1"></i>Xóa
                                </button>
                                <button type="submit" name="action" value="reset" class="btn btn-secondary">
                                    <i class="bi bi-x-circle me-1"></i>Hủy
                                </button>
                            </c:when>
                            <c:otherwise>
                                <button type="submit" name="action" value="create" class="btn btn-primary">
                                    <i class="bi bi-cloud-upload me-1"></i>Đăng Video
                                </button>
                                <button type="reset" class="btn btn-secondary">
                                    <i class="bi bi-arrow-clockwise me-1"></i>Làm Mới
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </form>
            </div>

            <!-- Video List -->
            <div class="video-table-card">
                <div class="card-header bg-white border-bottom py-3 px-4">
                    <h5 class="mb-0">
                        <i class="bi bi-list-ul me-2"></i>Video Đã Đăng
                    </h5>
                </div>
                
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th width="10%">ID</th>
                                <th width="10%">Thumbnail</th>
                                <th width="25%">Tiêu đề</th>
                                <th width="12%">YouTube ID</th>
                                <th width="8%" class="text-center">Lượt xem</th>
                                <th width="12%">Ngày đăng</th>
                                <th width="10%" class="text-center">Trạng thái</th>
                                <th width="13%" class="text-center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty videos}">
                                    <tr>
                                        <td colspan="8">
                                            <div class="empty-state">
                                                <i class="bi bi-camera-video-off"></i>
                                                <h5 class="mt-3">Bạn chưa đăng video nào</h5>
                                                <p class="text-muted">
                                                    Hãy đăng video đầu tiên của bạn bằng form ở trên!
                                                </p>
                                            </div>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${videos}" var="v">
                                        <tr>
                                            <td><code>${v.id}</code></td>
                                            <td>
                                                <img src="${v.poster}" 
                                                     class="video-thumbnail" 
                                                     alt="Thumbnail"
                                                     onerror="this.src='https://via.placeholder.com/80x50?text=No+Image'">
                                            </td>
                                            <td>
                                                <strong>${v.title}</strong>
                                                <c:if test="${not empty v.description}">
                                                    <br>
                                                    <small class="text-muted">
                                                        ${v.description.length() > 50 ? v.description.substring(0, 50).concat('...') : v.description}
                                                    </small>
                                                </c:if>
                                            </td>
                                            <td><code class="small">${v.videoId}</code></td>
                                            <td class="text-center">
                                                <span class="badge bg-info">
                                                    <i class="bi bi-eye"></i> ${v.views}
                                                </span>
                                            </td>
                                            <td>
                                                <small>
                                                    <i class="bi bi-calendar3"></i>
                                                    ${v.createdDate}
                                                </small>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${v.active}">
                                                        <span class="badge bg-success">
                                                            <i class="bi bi-check-circle"></i> Active
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">
                                                            <i class="bi bi-x-circle"></i> Inactive
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <div class="btn-group" role="group">
                                                    <a href="<%=request.getContextPath()%>/video-detail?id=${v.id}" 
                                                       class="btn btn-sm btn-outline-primary btn-action"
                                                       title="Xem">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                    <a href="<%=request.getContextPath()%>/my-videos?action=edit&id=${v.id}" 
                                                       class="btn btn-sm btn-outline-warning btn-action"
                                                       title="Sửa">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
                
                <!-- Footer Info -->
                <c:if test="${not empty videos}">
                    <div class="card-footer bg-light text-muted small py-3">
                        <i class="bi bi-info-circle me-1"></i>
                        Tổng cộng: <strong>${totalVideos}</strong> video
                    </div>
                </c:if>
            </div>

        </div>
    </main>

    <!-- Include Footer -->
    <jsp:include page="/views/layout/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form validation
        document.getElementById('videoForm').addEventListener('submit', function(e) {
            const action = e.submitter.value;
            
            if (action === 'delete') {
                return; // Skip validation for delete
            }
            
            const videoId = document.querySelector('input[name="id"]').value.trim();
            const title = document.querySelector('input[name="title"]').value.trim();
            const videoUrl = document.querySelector('input[name="videoUrl"]').value.trim();
            
            // Validate Video ID format
            if (action === 'create') {
                const idPattern = /^[a-zA-Z0-9_-]{3,20}$/;
                if (!idPattern.test(videoId)) {
                    e.preventDefault();
                    alert('Video ID phải từ 3-20 ký tự, chỉ chứa chữ, số, gạch dưới và gạch ngang!');
                    return false;
                }
            }
            
            // Validate Title
            if (title.length < 3 || title.length > 100) {
                e.preventDefault();
                alert('Tiêu đề phải từ 3-100 ký tự!');
                return false;
            }
            
            // Validate YouTube URL
            const youtubePattern = /(?:youtube\.com\/watch\?v=|youtu\.be\/)([a-zA-Z0-9_-]{11})/;
            if (!youtubePattern.test(videoUrl)) {
                e.preventDefault();
                alert('Link YouTube không hợp lệ!\nVui lòng nhập link đúng định dạng:\nhttps://www.youtube.com/watch?v=...');
                return false;
            }
        });
    </script>
</body>
</html>