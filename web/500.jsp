<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>500 - Lỗi máy chủ</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body class="flex flex-col min-h-screen bg-red-50 items-center justify-center p-4">
        <div class="bg-white rounded-3xl shadow-xl w-full max-w-lg p-10 text-center border-t-8 border-red-500">
            <h1 class="text-9xl font-black text-red-200 mb-4">500</h1>
            <h2 class="text-3xl font-extrabold text-red-700 mb-4">Lỗi hệ thống 🚨</h2>
            <p class="text-gray-600 mb-8 text-lg font-medium">
                Có chút trục trặc trong quá trình xử lý yêu cầu. Mong bạn thông cảm và thử lại sau ít phút.
            </p>

            <div class="text-left bg-gray-100 p-4 rounded-lg overflow-auto text-xs text-red-800 mb-8 max-h-64">
                <strong>DEBUG INFO:</strong><br />
                <%= exception !=null ? exception.getMessage() : "Unknown Error" %><br />
                    <% if (exception !=null) { for (StackTraceElement element : exception.getStackTrace()) {
                        out.print(element.toString() + "<br/>" ); } } %>
            </div>

            <a href="${pageContext.request.contextPath}/"
                class="inline-flex justify-center py-4 px-8 border border-transparent shadow-md text-base font-bold rounded-xl text-white bg-red-600 hover:bg-red-700 transition">
                Về trang chủ MochiGo
            </a>
        </div>
    </body>

    </html>