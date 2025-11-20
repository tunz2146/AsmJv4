<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý User - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        .admin-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
        }
        .table thead th {
            background: #764ba2;
            color: #fff;
        }
        .modal-header {
            background: #764ba2;
            color: white;
        }
        .btn-purple {
            background: #764ba2;
            color: white;
        }
        .btn-purple:hover {
            background: #5b3e8a;
            color: white;
        }
    </style>
</head>

<body class="bg-light">

    <!-- Header -->
    <header class="admin-header text-center">
        <h1 class="fw-bold">Quản Lý User</h1>
        <p class="mb-0">Trang quản trị tài khoản người dùng</p>
    </header>

    <div class="container mt-4">

        <!-- Search + Add User -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <form method="get" class="d-flex w-50">
                <input type="text" name="keyword" class="form-control me-2"
                       placeholder="Tìm theo username, email, họ tên…">
                <button class="btn btn-purple"><i class="bi bi-search"></i> Tìm</button>
            </form>

            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addUserModal">
                <i class="bi bi-person-plus"></i> Thêm User
            </button>
        </div>

        <!-- Danh sách User -->
        <div class="card shadow">
            <div class="card-body">

                <table class="table table-bordered table-striped text-center align-middle">
                    <thead>
                        <tr>
                            <th>Username</th>
                            <th>Họ Tên</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Trạng Thái</th>
                            <th width="180">Thao Tác</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach var="u" items="${users}">
                            <tr>
                                <td>${u.username}</td>
                                <td>${u.fullname}</td>
                                <td>${u.email}</td>
                                <td>
                                    <span class="badge bg-${u.role == 1 ? 'primary':'secondary'}">
                                        ${u.role == 1 ? 'Admin':'User'}
                                    </span>
                                </td>
                                <td>
                                    <span class="badge bg-${u.active ? 'success':'danger'}">
                                        ${u.active ? 'Hoạt động':'Khóa'}
                                    </span>
                                </td>
                                <td>
                                    <a href="admin/user/edit?username=${u.username}" 
                                       class="btn btn-warning btn-sm">
                                        <i class="bi bi-pencil-square"></i>
                                    </a>

                                    <a href="admin/user/delete?username=${u.username}" 
                                       class="btn btn-danger btn-sm"
                                       onclick="return confirm('Xóa user này?')">
                                       <i class="bi bi-trash"></i>
                                    </a>

                                    <a href="admin/user/toggle?username=${u.username}" 
                                       class="btn btn-${u.active ? 'secondary':'success'} btn-sm">
                                        <i class="bi bi-shield-lock"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>

                </table>

            </div>
        </div>

    </div>


    <!-- Modal Thêm User -->
    <div class="modal fade" id="addUserModal">
        <div class="modal-dialog modal-lg">
            <form method="post" action="admin/user/create" class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title"><i class="bi bi-person-plus"></i> Thêm User Mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="fw-bold">Username</label>
                            <input name="username" class="form-control" required>
                        </div>

                        <div class="col-md-6">
                            <label class="fw-bold">Password</label>
                            <input name="password" type="password" class="form-control" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="fw-bold">Họ Tên</label>
                        <input name="fullname" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="fw-bold">Email</label>
                        <input name="email" type="email" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="fw-bold">Role</label>
                        <select name="role" class="form-select">
                            <option value="0">User</option>
                            <option value="1">Admin</option>
                        </select>
                    </div>

                </div>

                <div class="modal-footer">
                    <button class="btn btn-purple">Lưu User</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                </div>

            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
