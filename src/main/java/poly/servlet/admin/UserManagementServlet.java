package poly.servlet.admin;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import poly.dao.UserDAO;
import poly.daoimpl.UserDAOImpl;   // ← DAO IMPLEMENT của bạn
import poly.entity.User;

@WebServlet({"/admin/user", "/admin/user/create", "/admin/user/delete", "/admin/user/edit"})
public class UserManagementServlet extends HttpServlet {

    private UserDAO userDao = new UserDAOImpl(); // dùng implementation thật

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String uri = req.getRequestURI();

        // ---------------------------------------
        // DELETE USER
        // ---------------------------------------
        if (uri.contains("delete")) {
            String id = req.getParameter("id");
            if (id != null) {
                userDao.deleteById(id);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/user");
            return;
        }

        // ---------------------------------------
        // EDIT USER (LOAD FORM EDIT)
        // ---------------------------------------
        if (uri.contains("edit")) {
            String id = req.getParameter("id");
            User user = userDao.findById(id);
            req.setAttribute("user", user);
            req.getRequestDispatcher("/views/admin/user-edit.jsp").forward(req, resp);
            return;
        }

        // ---------------------------------------
        // LOAD LIST USERS + PAGINATION + SEARCH
        // ---------------------------------------
        String keyword = req.getParameter("keyword");
        int page = req.getParameter("page") == null ? 1 : Integer.parseInt(req.getParameter("page"));
        int size = 8; // 8 user mỗi trang

        List<User> list;

        if (keyword != null && !keyword.isEmpty()) {
            list = userDao.findAll()      // bạn chưa có findByKeyword → dùng tạm filter
                         .stream()
                         .filter(u -> u.getId().contains(keyword)
                                   || u.getEmail().contains(keyword)
                                   || u.getFullname().contains(keyword))
                         .toList();
        } else {
            list = userDao.findWithPagination(page, size);
        }

        int totalUsers = userDao.countAll();
        int totalPages = (int) Math.ceil(totalUsers / (double) size);

        req.setAttribute("users", list);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("currentPage", page);

        req.getRequestDispatcher("/views/admin/user-management.jsp").forward(req, resp);
    }


    // ==========================================
    // POST → CREATE / UPDATE
    // ==========================================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String uri = req.getRequestURI();

        // CREATE NEW USER
        if (uri.contains("create")) {

            User u = new User();
            u.setId(req.getParameter("id"));
            u.setPassword(req.getParameter("password"));
            u.setFullname(req.getParameter("fullname"));
            u.setEmail(req.getParameter("email"));
            u.setAdmin(Boolean.parseBoolean(req.getParameter("admin")));

            userDao.create(u);
            resp.sendRedirect(req.getContextPath() + "/admin/user");
            return;
        }

        // UPDATE USER
        if (uri.contains("edit")) {

            User u = userDao.findById(req.getParameter("id"));

            u.setFullname(req.getParameter("fullname"));
            u.setEmail(req.getParameter("email"));
            u.setAdmin(Boolean.parseBoolean(req.getParameter("admin")));

            // CHỈ cập nhật password nếu user nhập vào
            String pw = req.getParameter("password");
            if (pw != null && !pw.isEmpty()) {
                u.setPassword(pw);
            }

            userDao.update(u);

            resp.sendRedirect(req.getContextPath() + "/admin/user");
        }
    }
}
