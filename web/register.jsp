<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký - MochiGo</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-pink-50 min-h-screen flex items-center justify-center">

<div class="bg-white p-8 rounded-xl shadow-md w-full max-w-md">
    <h2 class="text-2xl font-bold mb-6 text-center text-pink-600">Đăng ký</h2>

    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
        <p class="text-red-500 mb-4"><%= error %></p>
    <% } %>

    <form action="<%= request.getContextPath() %>/auth" method="post" class="space-y-4">
        <input type="hidden" name="action" value="register">

        <div>
            <label class="block mb-1 font-medium">Họ tên</label>
            <input type="text" name="fullName" class="w-full border rounded-lg px-4 py-2" required>
        </div>

        <div>
            <label class="block mb-1 font-medium">Email</label>
            <input type="email" name="email" class="w-full border rounded-lg px-4 py-2" required>
        </div>

        <div>
            <label class="block mb-1 font-medium">Số điện thoại</label>
            <input type="text" name="phone" class="w-full border rounded-lg px-4 py-2">
        </div>

        <div>
            <label class="block mb-1 font-medium">Mật khẩu</label>
            <input type="password" name="password" class="w-full border rounded-lg px-4 py-2" required>
        </div>

        <div>
            <label class="block mb-1 font-medium">Xác nhận mật khẩu</label>
            <input type="password" name="confirmPassword" class="w-full border rounded-lg px-4 py-2" required>
        </div>

        <button type="submit" class="w-full bg-pink-600 text-white py-2 rounded-lg font-semibold hover:bg-pink-700">
            Đăng ký
        </button>
    </form>

    <p class="mt-4 text-center text-sm">
        Đã có tài khoản?
        <a href="<%= request.getContextPath() %>/login.jsp" class="text-pink-600 font-semibold">Đăng nhập</a>
    </p>
</div>

</body>
</html>