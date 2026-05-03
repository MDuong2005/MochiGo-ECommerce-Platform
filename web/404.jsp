<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>404 - Không tìm thấy trang</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body class="flex flex-col min-h-screen bg-pink-50 items-center justify-center p-4">
        <div class="bg-white rounded-3xl shadow-xl w-full max-w-lg p-10 text-center">
            <h1 class="text-9xl font-black text-pink-200 mb-4">404</h1>
            <h2 class="text-3xl font-extrabold text-pink-700 mb-4">Ôi không! 🕵️‍♀️</h2>
            <p class="text-gray-600 mb-8 text-lg font-medium">
                Trang web bạn đang cố tìm kiếm không tồn tại hoặc đã bị di dời. Xin lỗi vì sự bất tiện này.
            </p>
            <a href="${pageContext.request.contextPath}/"
                class="inline-flex justify-center py-4 px-8 border border-transparent shadow-md text-base font-bold rounded-xl text-white bg-pink-600 hover:bg-pink-700 transition">
                Về trang chủ MochiGo
            </a>
        </div>
    </body>

    </html>