<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<style>
    .navbar-custom {
        background: linear-gradient(90deg, #0066ff, #4f8bff);
        padding: 12px 0;
    }

    .nav-link {
        font-weight: 500;
        margin-right: 18px;
    }

    /* Avatar + Username box cố định giống YouTube */
    .nav-user-box {
        display: flex;
        align-items: center;
        max-width: 160px;       /* Ngăn giãn navbar */
        overflow: hidden;
        white-space: nowrap;
    }

    /* Tên user thu ngắn */
    .nav-username {
        max-width: 110px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        display: inline-block;
    }

    .dropdown-menu {
        border-radius: 12px;
        padding: 10px 0;
    }

    /* Hiện nút 3 chấm khi màn hình nhỏ */
    @media (max-width: 768px) {
        .main-nav-item { display: none; }
        .nav-more { display: block !important; }
    }
</style>


<nav class="navbar navbar-expand-lg navbar-dark navbar-custom shadow-sm">
    <div class="container">

        <!-- Logo -->
        <a class="navbar-brand fw-bold fs-4" href="<%=request.getContextPath()%>/home">
            <i class="bi bi-play-circle-fill me-2"></i>Online Entertainment
        </a>

        <ul class="navbar-nav ms-auto align-items-center">

            <!-- Menu chính -->
            <li class="nav-item main-nav-item">
                <a class="nav-link" href="<%=request.getContextPath()%>/home">
                    <i class="bi bi-house-door me-1"></i>Trang chủ
                </a>
            </li>

            <c:if test="${not empty sessionScope.currentUser}">
                <!-- ✅ THÊM: My Videos -->
                <li class="nav-item main-nav-item">
                    <a class="nav-link" href="<%=request.getContextPath()%>/my-videos">
                        <i class="bi bi-camera-video me-1"></i>Video của tôi
                    </a>
                </li>
                
                <li class="nav-item main-nav-item">
                    <a class="nav-link" href="<%=request.getContextPath()%>/favorites">
                        <i class="bi bi-heart me-1"></i>Yêu thích
                    </a>
                </li>
            </c:if>

            <!-- Nút 3 chấm khi màn nhỏ -->
            <li class="nav-item dropdown nav-more" style="display:none;">
                <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown">
                    <i class="bi bi-three-dots fs-4"></i>
                </a>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a class="dropdown-item" href="<%=request.getContextPath()%>/home">
                        <i class="bi bi-house-door me-2"></i>Trang chủ
                    </a></li>

                    <c:if test="${not empty sessionScope.currentUser}">
                        <!-- ✅ THÊM: My Videos trong mobile menu -->
                        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/my-videos">
                            <i class="bi bi-camera-video me-2"></i>Video của tôi
                        </a></li>
                        
                        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/favorites">
                            <i class="bi bi-heart me-2"></i>Yêu thích
                        </a></li>
                    </c:if>
                </ul>
            </li>


            <!-- User account -->
            <li class="nav-item dropdown">
                <a class="nav-link d-flex align-items-center" id="accountDropdown"
                   role="button" data-bs-toggle="dropdown" style="padding-right: 0;">

                    <!-- Hộp user cố định chiều rộng -->
                    <div class="nav-user-box">
                        <div style="
                            width: 32px; height: 32px;
                            background: #fff3;
                            border-radius: 50%;
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            margin-right: 8px;">
                            <i class="bi bi-person-fill" style="font-size: 18px;"></i>
                        </div>

                        <!-- Username thu ngắn -->
                        <span class="nav-username">
                            <c:choose>
                                <c:when test="${not empty sessionScope.currentUser}">
                                    ${sessionScope.currentUser.fullname}
                                </c:when>
                                <c:otherwise>Tài khoản</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <i class="bi bi-caret-down-fill ms-1"></i>
                </a>

                <ul class="dropdown-menu dropdown-menu-end">

                    <c:choose>
                        <c:when test="${not empty sessionScope.currentUser}">

                            <li><h6 class="dropdown-header">${sessionScope.currentUser.username}</h6></li>
                            <li><hr class="dropdown-divider"></li>

                            <!-- ✅ THÊM: My Videos trong user dropdown -->
                            <li>
                                <a class="dropdown-item" href="<%=request.getContextPath()%>/my-videos">
                                    <i class="bi bi-camera-video me-2"></i>Video của tôi
                                </a>
                            </li>

                            <li>
                                <a class="dropdown-item" href="<%=request.getContextPath()%>/favorites">
                                    <i class="bi bi-heart me-2"></i>Yêu thích
                                </a>
                            </li>

                            <li><hr class="dropdown-divider"></li>

                            <li>
                                <a class="dropdown-item" href="<%=request.getContextPath()%>/profile">
                                    <i class="bi bi-pencil-square me-2"></i>Cập nhật thông tin
                                </a>
                            </li>

                            <li>
                                <a class="dropdown-item" href="<%=request.getContextPath()%>/change-password">
                                    <i class="bi bi-key me-2"></i>Đổi mật khẩu
                                </a>
                            </li>

                            <c:if test="${sessionScope.currentUser.admin}">
                                <li><hr class="dropdown-divider"></li>
                                <li class="dropdown-header text-danger">
                                    <i class="bi bi-shield-check"></i> Quản trị
                                </li>

                                <li><a class="dropdown-item" href="<%=request.getContextPath()%>/admin/videos">
                                    <i class="bi bi-camera-video me-2"></i>Quản lý Video</a></li>

                                <li><a class="dropdown-item" href="<%=request.getContextPath()%>/admin/users">
                                    <i class="bi bi-people me-2"></i>Quản lý User</a></li>

                                <li><a class="dropdown-item" href="<%=request.getContextPath()%>/admin/reports">
                                    <i class="bi bi-graph-up me-2"></i>Báo cáo</a></li>
                            </c:if>

                            <li><hr class="dropdown-divider"></li>

                            <li>
                                <a class="dropdown-item text-danger" href="<%=request.getContextPath()%>/logout">
                                    <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                                </a>
                            </li>

                        </c:when>

                        <c:otherwise>
                            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/login">
                                <i class="bi bi-box-arrow-in-right me-2"></i>Đăng nhập
                            </a></li>
                            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/register">
                                <i class="bi bi-person-plus me-2"></i>Đăng ký
                            </a></li>
                        </c:otherwise>
                    </c:choose>

                </ul>
            </li>

        </ul>
    </div>
</nav>