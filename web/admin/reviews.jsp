<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Quản lý Đánh giá - Admin MochiGo</title>
                <script src="https://cdn.tailwindcss.com"></script>
            </head>

            <body class="bg-gray-100 min-h-screen flex flex-col">

                <jsp:include page="/admin/admin-nav.jsp" />

                <div class="max-w-7xl mx-auto py-10 px-4 sm:px-6 lg:px-8 w-full flex-grow">
                    <h1 class="text-3xl font-extrabold text-gray-900 mb-8">Quản lý Đánh giá ⭐</h1>

                    <c:if test="${not empty sessionScope.message}">
                        <div
                            class="mb-4 bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative">
                            ${sessionScope.message}
                            <c:remove var="message" scope="session" />
                        </div>
                    </c:if>
                    <c:if test="${not empty sessionScope.error}">
                        <div class="mb-4 bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative">
                            ${sessionScope.error}
                            <c:remove var="error" scope="session" />
                        </div>
                    </c:if>

                    <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
                        <c:choose>
                            <c:when test="${empty reviews}">
                                <div class="p-12 text-center text-gray-500">
                                    Chưa có đánh giá nào từ khách hàng.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <table class="min-w-full divide-y divide-gray-200">
                                    <thead class="bg-gray-50">
                                        <tr>
                                            <th
                                                class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Người dùng</th>
                                            <th
                                                class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Sản phẩm</th>
                                            <th
                                                class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Đánh giá</th>
                                            <th
                                                class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Ngày gửi</th>
                                            <th
                                                class="px-6 py-4 text-right text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody class="bg-white divide-y divide-gray-200">
                                        <c:forEach var="r" items="${reviews}">
                                            <tr class="hover:bg-gray-50 transition-colors">
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <div class="font-medium text-gray-900">${r.userName}</div>
                                                    <div class="text-xs text-gray-500">User ID: ${r.userId}</div>
                                                </td>
                                                <td class="px-6 py-4">
                                                    <div class="flex items-center">
                                                        <c:if test="${not empty r.productImage}">
                                                            <img src="${pageContext.request.contextPath}/${r.productImage}"
                                                                alt="${r.productName}"
                                                                class="w-10 h-10 object-cover rounded mr-3">
                                                        </c:if>
                                                        <div class="font-medium text-pink-600">${r.productName}</div>
                                                    </div>
                                                </td>
                                                <td class="px-6 py-4 min-w-[250px]">
                                                    <div class="flex items-center mb-1">
                                                        <c:forEach var="i" begin="1" end="5">
                                                            <svg class="w-4 h-4 ${i <= r.rating ? 'text-yellow-400' : 'text-gray-300'}"
                                                                fill="currentColor" viewBox="0 0 20 20">
                                                                <path
                                                                    d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z">
                                                                </path>
                                                            </svg>
                                                        </c:forEach>
                                                    </div>
                                                    <div class="text-sm text-gray-700 whitespace-pre-wrap">${empty
                                                        r.comment ? '<em class="text-gray-400">Không có bình luận</em>'
                                                        : r.comment}</div>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                    <fmt:formatDate value="${r.createdAt}"
                                                        pattern="dd/MM/yyyy HH:mm:ss" />
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                                    <form action="${pageContext.request.contextPath}/admin/reviews"
                                                        method="post" class="inline"
                                                        onsubmit="return confirm('Bạn có chắc chắn muốn xóa đánh giá này không? Hành động này không thể hoàn tác.');">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="reviewId" value="${r.reviewId}">
                                                        <button type="submit"
                                                            class="text-red-600 hover:text-red-900 bg-red-50 hover:bg-red-100 px-3 py-1 rounded transition-colors font-bold">Xóa</button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <footer class="bg-white border-t py-4 text-center text-gray-500 text-sm mt-auto">
                    MochiGo Admin Panel &copy; 2026
                </footer>
            </body>

            </html>