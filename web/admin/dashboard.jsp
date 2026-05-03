<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Admin Dashboard - MochiGo</title>
                <script src="https://cdn.tailwindcss.com"></script>
            </head>

            <body class="bg-gray-100 min-h-screen flex flex-col">

                <jsp:include page="/admin/admin-nav.jsp" />

                <div class="max-w-7xl mx-auto py-10 px-4 sm:px-6 lg:px-8 w-full flex-grow">
                    <div class="flex justify-between items-center mb-8">
                        <h1 class="text-3xl font-extrabold text-gray-900">Bảng điều khiển ⚡</h1>
                        <a href="${pageContext.request.contextPath}/home"
                            class="inline-flex items-center px-4 py-2 bg-pink-600 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-pink-700 active:bg-pink-900 focus:outline-none focus:border-pink-900 focus:ring ring-pink-300 disabled:opacity-25 transition ease-in-out duration-150">
                            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
                            </svg>
                            Về trang khách
                        </a>
                    </div>

                    <!-- Tổng doanh thu -->
                    <div
                        class="mb-8 bg-gradient-to-r from-pink-500 to-rose-500 rounded-xl shadow-lg p-6 text-white flex items-center justify-between">
                        <div>
                            <h2 class="text-lg font-medium text-pink-100 mb-1">Tổng doanh thu (Đã thanh toán)</h2>
                            <div class="text-4xl font-extrabold tracking-tight mb-2">
                                <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"
                                    maxFractionDigits="0" /> đ
                            </div>
                            <a href="${pageContext.request.contextPath}/admin/revenue" 
                               class="inline-flex items-center text-sm font-bold text-white bg-white/20 px-3 py-1.5 rounded-lg hover:bg-white/30 transition-colors">
                                Xem báo cáo chi tiết &rarr;
                            </a>
                        </div>
                        <div class="bg-white/20 p-4 rounded-full">
                            <svg class="w-12 h-12 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 mb-8">
                        <div
                            class="bg-white rounded-xl shadow-sm p-6 border-t-4 border-pink-500 hover:shadow-md transition-shadow">
                            <h3 class="text-lg font-bold text-gray-700 mb-2">Quản lý Sản phẩm</h3>
                            <p class="text-gray-500 mb-4 text-sm">Thêm, sửa, xóa bánh kẹo, cập nhật tồn kho.</p>
                            <a href="${pageContext.request.contextPath}/admin/products"
                                class="text-pink-600 font-bold hover:text-pink-800 flex items-center">
                                Truy cập ngay
                                <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M13 7l5 5m0 0l-5 5m5-5H6" />
                                </svg>
                            </a>
                        </div>

                        <div
                            class="bg-white rounded-xl shadow-sm p-6 border-t-4 border-blue-500 hover:shadow-md transition-shadow">
                            <h3 class="text-lg font-bold text-gray-700 mb-2">Quản lý Đơn hàng</h3>
                            <p class="text-gray-500 mb-4 text-sm">Xem và duyệt các đơn đặt hàng từ khách hàng.</p>
                            <a href="${pageContext.request.contextPath}/admin/orders"
                                class="text-blue-600 font-bold hover:text-blue-800 flex items-center">
                                Duyệt đơn ngay
                                <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M13 7l5 5m0 0l-5 5m5-5H6" />
                                </svg>
                            </a>
                        </div>

                        <div
                            class="bg-white rounded-xl shadow-sm p-6 border-t-4 border-green-500 hover:shadow-md transition-shadow">
                            <h3 class="text-lg font-bold text-gray-700 mb-2">Quản lý Danh mục</h3>
                            <p class="text-gray-500 mb-4 text-sm">Thêm các loại bánh kẹo, danh mục mới.</p>
                            <a href="${pageContext.request.contextPath}/admin/categories"
                                class="text-green-600 font-bold hover:text-green-800 flex items-center">
                                Sắp xếp ngay
                                <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M13 7l5 5m0 0l-5 5m5-5H6" />
                                </svg>
                            </a>
                        </div>

                        <div
                            class="bg-white rounded-xl shadow-sm p-6 border-t-4 border-yellow-500 hover:shadow-md transition-shadow">
                            <h3 class="text-lg font-bold text-gray-700 mb-2">Quản lý Voucher</h3>
                            <p class="text-gray-500 mb-4 text-sm">Tạo và quản lý các mã giảm giá cho khách hàng.</p>
                            <a href="${pageContext.request.contextPath}/admin/vouchers"
                                class="text-yellow-600 font-bold hover:text-yellow-800 flex items-center">
                                Quản lý ngay
                                <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M13 7l5 5m0 0l-5 5m5-5H6" />
                                </svg>
                            </a>
                        </div>

                        <div
                            class="bg-white rounded-xl shadow-sm p-6 border-t-4 border-purple-500 hover:shadow-md transition-shadow">
                            <h3 class="text-lg font-bold text-gray-700 mb-2">Quản lý Người Dùng</h3>
                            <p class="text-gray-500 mb-4 text-sm">Xem danh sách khách hàng, cấp quyền.</p>
                            <a href="${pageContext.request.contextPath}/admin/users"
                                class="text-purple-600 font-bold hover:text-purple-800 flex items-center">
                                Kiểm soát ngay
                                <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M13 7l5 5m0 0l-5 5m5-5H6" />
                                </svg>
                            </a>
                        </div>

                        <div
                            class="bg-white rounded-xl shadow-sm p-6 border-t-4 border-orange-500 hover:shadow-md transition-shadow">
                            <h3 class="text-lg font-bold text-gray-700 mb-2">Quản lý Đánh giá</h3>
                            <p class="text-gray-500 mb-4 text-sm">Xem danh sách đánh giá từ khách hàng.</p>
                            <a href="${pageContext.request.contextPath}/admin/reviews"
                                class="text-orange-600 font-bold hover:text-orange-800 flex items-center">
                                Xem đánh giá
                                <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M13 7l5 5m0 0l-5 5m5-5H6" />
                                </svg>
                            </a>
                        </div>
                    </div>

                    <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
                        <div class="px-6 py-4 border-b border-gray-100 flex justify-between items-center">
                            <h2 class="text-lg font-bold text-gray-800">Đánh giá mới nhất ⭐</h2>
                            <a href="${pageContext.request.contextPath}/admin/reviews"
                                class="text-pink-600 hover:text-pink-800 text-sm font-medium">Xem tất cả &rarr;</a>
                        </div>
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
                                        </tr>
                                    </thead>
                                    <tbody class="bg-white divide-y divide-gray-200">
                                        <c:forEach var="r" items="${reviews}" end="4">
                                            <tr class="hover:bg-gray-50 transition-colors">
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <div class="font-medium text-gray-900">${r.userName}</div>
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
                                                    <div class="text-sm text-gray-700 whitespace-pre-wrap line-clamp-2">
                                                        ${empty r.comment ? '<em class="text-gray-400">Không có bình
                                                            luận</em>' : r.comment}</div>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                    <fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm" />
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