<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Quản lý Danh mục - Admin</title>
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
                    <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded shadow-sm flex justify-between items-center">
                        <span>${sessionScope.error}</span>
                        <button onclick="this.parentElement.remove()" class="text-red-700">&times;</button>
                    </div>
                    <c:remove var="error" scope="session" />
                </c:if>

                <div class="flex justify-between items-center mb-8">
                    <h1 class="text-3xl font-extrabold text-gray-900">Quản lý Danh mục 📋</h1>
                    <a href="${pageContext.request.contextPath}/admin/categories?action=new"
                        class="bg-green-600 hover:bg-green-700 text-white px-4 py-2 flex items-center rounded-lg shadow-sm font-medium transition-colors">
                        <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                        </svg>
                        Thêm danh mục
                    </a>
                </div>

                <div class="bg-white rounded-xl shadow-sm overflow-hidden border">
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th scope="col"
                                        class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        ID</th>
                                    <th scope="col"
                                        class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Tên Danh mục</th>
                                    <th scope="col"
                                        class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Mô tả</th>
                                    <th scope="col"
                                        class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Trạng thái</th>
                                    <th scope="col"
                                        class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Thao tác</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach var="cat" items="${categories}">
                                    <tr class="hover:bg-gray-50">
                                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                            #${cat.categoryId}</td>
                                        <td class="px-6 py-4 text-sm font-bold text-gray-800">
                                            <div class="flex items-center">
                                                <div class="h-10 w-10 flex-shrink-0 bg-gray-100 rounded-lg overflow-hidden border mr-3">
                                                    <c:choose>
                                                        <c:when test="${not empty cat.imageUrl}">
                                                            <img src="${pageContext.request.contextPath}/${cat.imageUrl}" alt="" class="h-full w-full object-cover">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="h-full w-full flex items-center justify-center text-gray-300">
                                                                <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                                                </svg>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                ${cat.name}
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 text-sm text-gray-500 max-w-xs truncate">${cat.description}
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <c:choose>
                                                <c:when test="${cat.active}">
                                                    <span
                                                        class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">Đang
                                                        hoạt động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span
                                                        class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">Tạm
                                                        ẩn</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                            <td
                                                class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium space-x-2">
                                                <a href="${pageContext.request.contextPath}/admin/categories?action=edit&id=${cat.categoryId}"
                                                    class="text-blue-600 hover:text-blue-900 border border-transparent hover:border-blue-300 p-2 rounded transition font-bold">Sửa</a>

                                                <form action="${pageContext.request.contextPath}/admin/categories"
                                                    method="post" class="inline">
                                                    <input type="hidden" name="action" value="toggleStatus">
                                                    <input type="hidden" name="id" value="${cat.categoryId}">
                                                    <button type="submit"
                                                        class="text-orange-500 hover:text-orange-700 border border-transparent hover:border-orange-300 p-2 rounded transition font-bold">
                                                        ${cat.active ? 'Ẩn' : 'Hiện'}
                                                    </button>
                                                </form>

                                                <form action="${pageContext.request.contextPath}/admin/categories"
                                                    method="post" class="inline">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="${cat.categoryId}">
                                                    <button type="submit"
                                                        class="text-red-600 hover:text-red-900 border border-transparent hover:border-red-300 p-2 rounded transition font-bold"
                                                        onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục này không?');">Xóa</button>
                                                </form>
                                            </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty categories}">
                                    <tr>
                                        <td colspan="5" class="px-6 py-10 text-center text-gray-500">Chưa có danh mục
                                            nào trên kệ hàng.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </body>

        </html>