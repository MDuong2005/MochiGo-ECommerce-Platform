<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Quản lý Sản phẩm - Admin MochiGo</title>
                <script src="https://cdn.tailwindcss.com"></script>
            </head>

            <body class="bg-gray-100 min-h-screen flex flex-col">

                <jsp:include page="/admin/admin-nav.jsp" />

                <div class="max-w-7xl mx-auto py-10 px-4 sm:px-6 lg:px-8 w-full flex-grow">
                    <c:if test="${not empty sessionScope.message}">
                        <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-6 rounded shadow-sm flex justify-between items-center">
                            <span>${sessionScope.message}</span>
                            <button onclick="this.parentElement.remove()" class="text-green-700">&times;</button>
                        </div>
                        <c:remove var="message" scope="session" />
                    </c:if>

                    <c:if test="${not empty sessionScope.error}">
                        <div class="bg-amber-100 border-l-4 border-amber-500 text-amber-700 p-4 mb-6 rounded shadow-sm flex flex-col">
                            <div class="flex justify-between items-center mb-1">
                                <span class="font-bold">⚠️ Thông báo</span>
                                <button onclick="this.parentElement.parentElement.remove()" class="text-amber-700">&times;</button>
                            </div>
                            <p class="text-sm">${sessionScope.error}</p>
                            <p class="text-xs mt-2 italic text-amber-600 font-medium">
                                * Lưu ý: Các sản phẩm đã có lịch sử đặt hàng không thể xóa để đảm bảo toàn vẹn dữ liệu. 
                                Bạn nên dùng chức năng <strong>"Ẩn"</strong> thay vì <strong>"Xóa"</strong>.
                            </p>
                        </div>
                        <c:remove var="error" scope="session" />
                    </c:if>

                    <div class="flex justify-between items-center mb-8">
                        <h1 class="text-3xl font-extrabold text-gray-900">Quản lý Sản phẩm 📦</h1>
                        <a href="${pageContext.request.contextPath}/admin/products?action=new"
                            class="bg-pink-600 hover:bg-pink-700 text-white font-bold py-2 px-4 rounded-lg shadow transition-colors flex items-center">
                            <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M12 4v16m8-8H4" />
                            </svg>
                            Thêm sản phẩm
                        </a>
                    </div>

                    <div class="bg-white shadow-sm border border-gray-200 rounded-2xl overflow-hidden">
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-gray-200">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th
                                            class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                                            ID</th>
                                        <th
                                            class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                                            Hình ảnh</th>
                                        <th
                                            class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                                            Tên sản phẩm</th>
                                        <th
                                            class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                                            Giá bán</th>
                                        <th
                                            class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                                            Khuyến mãi</th>
                                        <th
                                            class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                                            Tồn kho</th>
                                        <th
                                            class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                                            Trạng thái</th>
                                        <th
                                            class="px-6 py-4 text-right text-xs font-bold text-gray-500 uppercase tracking-wider">
                                            Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-200">
                                    <c:forEach var="p" items="${products}">
                                        <tr class="hover:bg-gray-50 transition-colors">
                                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                                #${p.productId}</td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <img src="${pageContext.request.contextPath}/${p.imageUrl}"
                                                    alt="${p.name}"
                                                    class="h-12 w-12 rounded object-cover border border-gray-200">
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-900">
                                                ${p.name}
                                                <c:if test="${p.featured}">
                                                    <span class="text-yellow-500 ml-1" title="Sản phẩm nổi bật">★</span>
                                                </c:if>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm font-bold text-pink-600">
                                                <c:choose>
                                                    <c:when test="${p.discountPercent > 0}">
                                                        <span class="line-through text-gray-400 text-xs mr-2">
                                                            <fmt:formatNumber value="${p.price}" type="number"
                                                                groupingUsed="true" maxFractionDigits="0" /> đ
                                                        </span>
                                                        <br />
                                                        <fmt:formatNumber value="${p.discountedPrice}" type="number"
                                                            groupingUsed="true" maxFractionDigits="0" /> đ
                                                    </c:when>
                                                    <c:otherwise>
                                                        <fmt:formatNumber value="${p.price}" type="number"
                                                            groupingUsed="true" maxFractionDigits="0" /> đ
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm font-bold">
                                                <c:if test="${p.discountPercent > 0}">
                                                    <span
                                                        class="bg-red-100 text-red-600 px-2 py-1 rounded-full text-xs">-${p.discountPercent}%</span>
                                                </c:if>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm">
                                                <c:choose>
                                                    <c:when test="${p.stock > 10}">
                                                        <span class="text-green-600 font-bold">${p.stock}</span>
                                                    </c:when>
                                                    <c:when test="${p.stock > 0}">
                                                        <span class="text-orange-500 font-bold">${p.stock} (Sắp
                                                            hết)</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-red-500 font-bold">0 (Hết hàng)</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm">
                                                <c:choose>
                                                    <c:when test="${p.active}">
                                                        <span
                                                            class="px-2 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">Hiển
                                                            thị</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span
                                                            class="px-2 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">Đã
                                                            ẩn</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                                <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.productId}"
                                                    class="text-indigo-600 hover:text-indigo-900 mr-4 font-bold">Sửa</a>
                                                <a href="${pageContext.request.contextPath}/admin/products?action=toggleStatus&id=${p.productId}"
                                                    class="text-orange-500 hover:text-orange-700 mr-4 font-bold"
                                                    title="${p.active ? 'Ẩn sản phẩm' : 'Hiện sản phẩm'}">
                                                    ${p.active ? 'Ẩn' : 'Hiện'}
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=${p.productId}"
                                                    class="text-red-600 hover:text-red-900 font-bold"
                                                    onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?');">Xóa</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty products}">
                                        <tr>
                                            <td colspan="7" class="px-6 py-12 text-center text-gray-500 font-medium">
                                                Chưa có sản phẩm nào.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <footer class="bg-white border-t py-4 text-center text-gray-500 text-sm mt-auto">
                    MochiGo Admin Panel &copy; 2026
                </footer>

            </body>

            </html>