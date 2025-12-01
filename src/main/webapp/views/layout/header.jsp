<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<style>
    .navbar-custom {
        background: linear-gradient(90deg, #667eea, #764ba2);
        padding: 12px 0;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .navbar-brand {
        font-weight: 700;
        font-size: 1.3rem;
        letter-spacing: 0.5px;
    }

    .nav-link {
        font-weight: 500;
        margin-right: 15px;
        transition: all 0.3s;
    }

    .nav-link:hover {
        transform: translateY(-2px);
    }

    /* Avatar + Username box */
    .nav-user-box {
        display: flex;
        align-items: center;
        max-width: 180px;
        overflow: hidden;
        white-space: nowrap;
    }

    .nav-username {
        max-width: 130px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        display: inline-block;
    }

    .user-avatar {
        width: 36px;
        height: 36px;
        background: rgba(255,255,255,0.3);
        border-radius: 50%;
        display: flex;
        justify-content: center;
        align-items: center;
        margin-right: 10px;
        border: 2px solid rgba(255,255,255,0.5);
    }

    .dropdown-menu {
        border-radius: 12px;
        padding: 8px 0;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        min-width: 250px;
    }

    .dropdown-item {
        padding: 10px 20px;
        transition: all 0.2s;
    }

    .dropdown-item:hover {
        background: #f8f9fa;
        padding-left: 25px;
    }

    .dropdown-divider {
        margin: 8px 0;
    }

    .dropdown-header {
        font-weight: 600;
        color: #495057;
        padding: 8px 20px;
    }

    /* Mobile responsive */
    @media (max-width: 768px) {
        .main-nav-item { display: none; }
        .nav-more { display: block !important; }
        .nav-username { max-width: 80px; }
    }

    /* Badge styles */
    .badge-admin {
        background: linear-gradient(135deg, #dc3545, #c82333);
        font-size: 0.7rem;
        padding: 3px 8px;
        margin-left: 5px;
    }
</style>

<nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
    <div class="container">

        <!-- Logo & Brand -->
        <a class="navbar-brand" href="<%=request.getContextPath()%>/home">
            <i class="bi bi-play-circle-fill me-2"></i>Online Entertainment
        </a>

        <!-- Navbar Items -->
        <ul class="navbar-nav ms-auto align-items-center">

            <!-- Trang chủ -->
            <li class="nav-item main-nav-item">
                <a class="nav-link" href="<%=request.getContextPath()%>/home">
                    <i class="bi bi-house-door me-1"></i>Trang chủ
                </a>
            </li>

            <!-- Yêu thích (chỉ hiện khi đã login) -->
            <c:if test="${not empty sessionScope.currentUser}">
                <li class="nav-item main-nav-item">
                    <a class="nav-link" href="<%=request.getContextPath()%>/favorites">
                        <i class="bi bi-heart-fill me-1"></i>Yêu thích
                    </a>
                </li>
            </c:if>

            <!-- Menu 3 chấm (mobile) -->
            <li class="nav-item dropdown nav-more" style="display:none;">
                <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#">
                    <i class="bi bi-three-dots-vertical fs-4"></i>
                </a>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li>
                        <a class="dropdown-item" href="<%=request.getContextPath()%>/home">
                            <i class="bi bi-house-door me-2"></i>Trang chủ
                        </a>
                    </li>
                    <c:if test="${not empty sessionScope.currentUser}">
                        <li>
                            <a class="dropdown-item" href="<%=request.getContextPath()%>/favorites">
                                <i class="bi bi-heart-fill me-2"></i>Yêu thích
                            </a>
                        </li>
                    </c:if>
                </ul>
            </li>

            <!-- User Account Dropdown -->
            <li class="nav-item dropdown">
                <a class="nav-link d-flex align-items-center dropdown-toggle" 
                   id="accountDropdown" role="button" data-bs-toggle="dropdown">
                    
                    <div class="nav-user-box">
                        <!-- Avatar -->
                        <div class="user-avatar">
                            <i class="bi bi-person-fill" style="font-size: 20px;"></i>
                        </div>

                        <!-- Username -->
                        <span class="nav-username">
                            <c:choose>
                                <c:when test="${not empty sessionScope.currentUser}">
                                    ${sessionScope.currentUser.fullname}
                                    <c:if test="${sessionScope.currentUser.admin}">
                                        <span class="badge badge-admin">Admin</span>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    Tài khoản
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </a>

                <!-- Dropdown Menu -->
                <ul class="dropdown-menu dropdown-menu-end shadow-lg">
                    
                    <c:choose>
                        <c:when test="${not empty sessionScope.currentUser}">
                            
                            <!-- User Info Header -->
                            <li>
                                <h6 class="dropdown-header">
                                    <i class="bi bi-person-circle me-2"></i>
                                    ${sessionScope.currentUser.fullname}
                                </h6>
                            </li>
                            <li>
                                <span class="dropdown-item-text text-muted small">
                                    <i class="bi bi-at"></i> ${sessionScope.currentUser.id}
                                </span>
                            </li>
                            <li><hr class="dropdown-divider"></li>

                            <!-- Profile Actions -->
                            <li>
                                <a class="dropdown-item" href="<%=request.getContextPath()%>/profile">
                                    <i class="bi bi-pencil-square me-2 text-primary"></i>
                                    Cập nhật thông tin
                                </a>
                            </li>

                            <li>
                                <a class="dropdown-item" href="<%=request.getContextPath()%>/change-password">
                                    <i class="bi bi-key me-2 text-warning"></i>
                                    Đổi mật khẩu
                                </a>
                            </li>

                            <li>
                                <a class="dropdown-item" href="<%=request.getContextPath()%>/favorites">
                                    <i class="bi bi-heart me-2 text-danger"></i>
                                    Video yêu thích
                                </a>
                            </li>

                            <!-- Admin Section -->
                            <c:if test="${sessionScope.currentUser.admin}">
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <h6 class="dropdown-header text-danger">
                                        <i class="bi bi-shield-check"></i> Quản trị viên
                                    </h6>
                                </li>

                                <li>
                                    <a class="dropdown-item" href="<%=request.getContextPath()%>/admin/videos">
                                        <i class="bi bi-camera-video me-2"></i>
                                        Quản lý Video
                                    </a>
                                </li>

                                <li>
                                    <a class="dropdown-item" href="<%=request.getContextPath()%>/admin/users">
                                        <i class="bi bi-people me-2"></i>
                                        Quản lý User
                                    </a>
                                </li>

                                <li>
                                    <a class="dropdown-item" href="<%=request.getContextPath()%>/admin/reports">
                                        <i class="bi bi-graph-up me-2"></i>
                                        Báo cáo thống kê
                                    </a>
                                </li>
                            </c:if>

                            <!-- Logout -->
                            <li><hr class="dropdown-divider"></li>
                            <li>
                                <a class="dropdown-item text-danger" href="<%=request.getContextPath()%>/logout">
                                    <i class="bi bi-box-arrow-right me-2"></i>
                                    Đăng xuất
                                </a>
                            </li>

                        </c:when>

                        <!-- Not Logged In -->
                        <c:otherwise>
                            <li>
                                <a class="dropdown-item" href="<%=request.getContextPath()%>/login">
                                    <i class="bi bi-box-arrow-in-right me-2 text-primary"></i>
                                    Đăng nhập
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item" href="<%=request.getContextPath()%>/register">
                                    <i class="bi bi-person-plus me-2 text-success"></i>
                                    Đăng ký
                                </a>
                            </li>
                            <li><hr class="dropdown-divider"></li>
                            <li>
                                <a class="dropdown-item" href="<%=request.getContextPath()%>/home">
                                    <i class="bi bi-house-door me-2"></i>
                                    Trang chủ
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>

                </ul>
            </li>

        </ul>
    </div>
</nav>