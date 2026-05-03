<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Quên mật khẩu - MochiGo</title>
            <script src="https://cdn.tailwindcss.com"></script>
        </head>

        <body
            class="bg-pink-50 min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8 relative overflow-hidden">
            <!-- Bubble Decorations -->
            <div class="absolute top-0 right-0 -mt-20 -mr-20 w-80 h-80 bg-pink-200 rounded-full opacity-50 blur-3xl">
            </div>
            <div class="absolute bottom-0 left-0 -mb-20 -ml-20 w-80 h-80 bg-pink-300 rounded-full opacity-50 blur-3xl">
            </div>

            <div
                class="max-w-md w-full space-y-8 bg-white/80 backdrop-blur-md p-10 rounded-3xl shadow-2xl relative z-10 border border-white">
                <div>
                    <h2 class="mt-2 text-center text-4xl font-extrabold text-gray-900 tracking-tight">
                        Lấy lại mật khẩu 🔑
                    </h2>
                    <p class="mt-3 text-center text-sm text-gray-600">
                        Nhập Email tài khoản MochiGo của bạn. Chúng tôi sẽ gửi một mã OTP 6 số đến trong giây lát.
                    </p>
                </div>

                <c:if test="${not empty error}">
                    <div class="bg-red-50 border-l-4 border-red-500 p-4 rounded-md">
                        <div class="flex">
                            <div class="flex-shrink-0">
                                <svg class="h-5 w-5 text-red-400" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd"
                                        d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
                                        clip-rule="evenodd" />
                                </svg>
                            </div>
                            <div class="ml-3">
                                <p class="text-sm text-red-700 font-medium">${error}</p>
                            </div>
                        </div>
                    </div>
                </c:if>

                <form class="mt-8 space-y-6" action="${pageContext.request.contextPath}/forgot-password" method="POST">
                    <div class="space-y-4 rounded-md">
                        <div>
                            <label for="email" class="block text-sm font-bold text-gray-700 mb-1">Email đăng ký tài
                                khoản</label>
                            <input id="email" name="email" type="email" required
                                class="appearance-none rounded-xl relative block w-full px-4 py-3 border border-gray-300 placeholder-gray-400 text-gray-900 focus:outline-none focus:ring-2 focus:ring-pink-500 focus:border-pink-500 sm:text-sm transition-all shadow-sm"
                                placeholder="VD: maid88391@gmail.com">
                        </div>
                    </div>

                    <div>
                        <button type="submit"
                            class="group relative w-full flex justify-center py-3 px-4 border border-transparent text-sm font-extrabold rounded-xl text-white bg-pink-600 hover:bg-pink-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-pink-500 shadow-md transition-all">
                            Gửi mã Xác nhận (OTP)
                        </button>
                    </div>

                    <div class="text-sm text-center">
                        <a href="${pageContext.request.contextPath}/login.jsp"
                            class="font-medium text-pink-600 hover:text-pink-500">
                            ← Quay lại Đăng nhập
                        </a>
                    </div>
                </form>
            </div>
        </body>

        </html>