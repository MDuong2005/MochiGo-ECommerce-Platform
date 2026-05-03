<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>Đăng nhập - MochiGo</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body class="bg-pink-50 min-h-screen flex items-center justify-center">

        <div class="bg-white p-8 rounded-xl shadow-md w-full max-w-md">
            <h2 class="text-2xl font-bold mb-6 text-center text-pink-600">Đăng nhập</h2>

            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
                <p class="text-red-500 mb-4 bg-red-50 p-3 rounded-lg border border-red-200">
                    <%= error %>
                </p>
            <% } %>

            <% String success = (String) request.getAttribute("success"); %>
            <% boolean registered = "true".equals(request.getParameter("registered")); %>
            <% if (success != null || registered) { %>
                <p class="text-green-600 mb-4 bg-green-50 p-3 rounded-lg border border-green-200">
                    ✅ <%= success != null ? success : "Đăng ký thành công! Vui lòng đăng nhập." %>
                </p>
            <% } %>

                                    <form action="<%= request.getContextPath() %>/auth" method="post" class="space-y-4">
                                        <input type="hidden" name="action" value="login">

                                        <div>
                                            <label class="block mb-1 font-medium">Email</label>
                                            <input type="email" name="email" class="w-full border rounded-lg px-4 py-2"
                                                required>
                                        </div>

                                        <div>
                                            <div class="flex justify-between items-center mb-1">
                                                <label class="block font-medium">Mật khẩu</label>
                                                <a href="<%= request.getContextPath() %>/forgot-password.jsp"
                                                    class="text-sm text-pink-500 hover:text-pink-700 font-semibold">Quên
                                                    mật khẩu?</a>
                                            </div>
                                            <input type="password" name="password"
                                                class="w-full border rounded-lg px-4 py-2" required>
                                        </div>

                                        <button type="submit"
                                            class="w-full bg-pink-600 text-white py-2 rounded-lg font-semibold hover:bg-pink-700">
                                            Đăng nhập
                                        </button>
                                    </form>

                                    <p class="mt-4 text-center text-sm">
                                        Chưa có tài khoản?
                                        <a href="<%= request.getContextPath() %>/register.jsp"
                                            class="text-pink-600 font-semibold">Đăng ký</a>
                                    </p>
        </div>

    </body>

    </html>