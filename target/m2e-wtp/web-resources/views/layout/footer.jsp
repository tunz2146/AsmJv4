<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Footer - Always at bottom -->
<footer class="bg-dark text-white py-4 mt-auto">
    <div class="container">
        <!-- Footer Content -->
        <div class="row">
            <!-- Company Info -->
            <div class="col-md-4 mb-3 mb-md-0">
                <h5 class="fw-bold mb-3">
                    <i class="bi bi-film me-2"></i>Online Entertainment
                </h5>
            </div>
            
            <!-- Quick Links -->
            <div class="col-md-4 mb-3 mb-md-0">
                <h6 class="fw-bold mb-3">Liên kết nhanh</h6>
                <ul class="list-unstyled">
                    <li class="mb-2">
                        <a href="<%=request.getContextPath()%>/" class="text-white-50 text-decoration-none">
                            <i class="bi bi-chevron-right me-1"></i>Trang chủ
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="<%=request.getContextPath()%>/favorites" class="text-white-50 text-decoration-none">
                            <i class="bi bi-chevron-right me-1"></i>Yêu thích
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="<%=request.getContextPath()%>/login" class="text-white-50 text-decoration-none">
                            <i class="bi bi-chevron-right me-1"></i>Đăng nhập
                        </a>
                    </li>
                </ul>
            </div>
            
            <!-- Contact & Social -->
            <div class="col-md-4">
                <h6 class="fw-bold mb-3">Liên hệ</h6>
                <p class="text-white-50 small mb-2">
                    <i class="bi bi-envelope me-2"></i>
                    tunz@gmail.com
                </p>
                <p class="text-white-50 small mb-3">
                    <i class="bi bi-telephone me-2"></i>
                    (084) 794612606
                </p>
                
                
            </div>
        </div>
        
        <!-- Copyright -->
        <hr class="border-secondary my-4">

<div class="text-center">
    <p class="text-white-50 small mb-0">
        <i class="bi bi-code-slash me-1"></i>
        &copy; 2024 Online Entertainment Tunz. All rights reserved.
    </p>
</div>

            
        </div>
    </div>
</footer>