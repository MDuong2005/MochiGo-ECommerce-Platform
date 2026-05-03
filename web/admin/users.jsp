<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Quản lý Người Dùng - Admin</title>
                <script src="https://cdn.tailwindcss.com"></script>
                <script>
                    function toggleUserStatus(userId, currentStatus) {
                        const newStatus = !currentStatus;

                        fetch('${pageContext.request.contextPath}/admin/user-status', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                            },
                            body: 'userId=' + userId + '&isActive=' + newStatus
                        })
                            .then(response => response.text())
                            .then(result => {
                                if (result === 'success') {
                                    window.location.reload();
                                } else if (result === 'error_self') {
                                    alert('Bạn không thể tự khóa tài khoản của mình!');
                                    window.location.reload();
                                } else {
                                    alert('Lỗi cập nhật trạng thái!');
                                    window.location.reload();
                                }
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                alert('Có lỗi xảy ra!');
                                window.location.reload();
                            });
                    }
                </script>
            </head>

            <body class="bg-gray-100 min-h-screen flex flex-col">

                <jsp:include page="/admin/admin-nav.jsp" />

                <div class="max-w-7xl mx-auto py-10 px-4 sm:px-6 lg:px-8 w-full flex-grow">
                    <div class="flex justify-between items-center mb-8">
                        <h1 class="text-3xl font-extrabold text-gray-900">Quản lý Người Dùng 👥</h1>
                    </div>

                    <c:if test="${param.success == 1}">
                        <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4"
                            role="alert">
                            <span class="block sm:inline">Cập nhật quyền thành công!</span>
                        </div>
                    </c:if>
                    <c:if test="${param.error == 1}">
                        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4"
                            role="alert">
                            <span class="block sm:inline">Có lỗi xảy ra khi cập nhật quyền! (Lưu ý: Bạn không thể tự đổi
                                quyền của chính mình)</span>
                        </div>
                    </c:if>
                    <c:if test="${param.success_delete == 1}">
                        <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4"
                            role="alert">
                            <span class="block sm:inline">Đã xóa tài khoản vĩnh viễn thành công!</span>
                        </div>
                    </c:if>
                    <c:if test="${param.error_delete == 1}">
                        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4"
                            role="alert">
                            <span class="block sm:inline">Có lỗi xảy ra khi xóa tài khoản. Dữ liệu liên quan không thể
                                xóa hết.</span>
                        </div>
                    </c:if>

                    <div class="bg-white shadow-md rounded-2xl overflow-hidden border border-gray-200">
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-gray-200">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                                            ID</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Họ
                                            Tên</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                                            Email</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">SĐT
                                        </th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                                            Ngày tham gia</th>
                                        <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase">
                                            Trạng thái (Bật/Khóa)</th>
                                        <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">
                                            Quyền / Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-200">
                                    <c:forEach var="u" items="${users}">
                                        <tr
                                            class="hover:bg-gray-50 transition-colors ${u.userId == sessionScope.user.userId ? 'bg-yellow-50' : ''}">
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                #${u.userId}
                                                <c:if test="${u.userId == sessionScope.user.userId}">
                                                    <span
                                                        class="ml-2 inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-yellow-100 text-yellow-800">(Bạn)</span>
                                                </c:if>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <div class="text-sm font-bold text-gray-900">${u.fullName}</div>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${u.email}
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${u.phone}
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                <fmt:formatDate value="${u.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                            </td>

                                            <!-- Status Toggle -->
                                            <td class="px-6 py-4 whitespace-nowrap text-center">
                                                <c:choose>
                                                    <c:when test="${u.userId == sessionScope.user.userId}">
                                                        <!-- Khóa toggle cho chính mình -->
                                                        <button disabled
                                                            class="relative inline-flex h-6 w-11 flex-shrink-0 rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none ${u.active ? 'bg-pink-600' : 'bg-gray-200'} opacity-50 cursor-not-allowed">
                                                            <span
                                                                class="pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out ${u.active ? 'translate-x-5' : 'translate-x-0'}"></span>
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button onclick="toggleUserStatus(${u.userId}, ${u.active})"
                                                            class="relative inline-flex h-6 w-11 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none ${u.active ? 'bg-pink-600' : 'bg-gray-200'}">
                                                            <span
                                                                class="pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out ${u.active ? 'translate-x-5' : 'translate-x-0'}"></span>
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Role Form -->
                                            <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                                <c:choose>
                                                    <c:when test="${u.userId == sessionScope.user.userId}">
                                                        <span
                                                            class="inline-flex items-center px-3 py-1 rounded-full text-xs font-bold bg-pink-100 text-pink-800">
                                                            ADMIN
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <form
                                                            action="${pageContext.request.contextPath}/admin/user-role"
                                                            method="POST"
                                                            class="inline-flex items-center justify-end space-x-2 mr-2">
                                                            <input type="hidden" name="userId" value="${u.userId}">
                                                            <select name="role"
                                                                class="text-sm rounded border-gray-300 py-1 pl-2 pr-6 focus:ring-pink-500 focus:border-pink-500 ${u.role == 'ADMIN' ? 'font-bold text-pink-700' : ''}">
                                                                <option value="USER" ${u.role=='USER' ? 'selected' : ''
                                                                    }>
                                                                    USER</option>
                                                                <option value="ADMIN" ${u.role=='ADMIN' ? 'selected'
                                                                    : '' }>
                                                                    ADMIN</option>
                                                            </select>
                                                            <button type="submit"
                                                                onclick="return confirm('Bạn có chắc chắn muốn thay đổi quyền của tài khoản này?');"
                                                                class="text-blue-600 hover:text-blue-900 transition-colors">Lưu</button>
                                                        </form>

                                                        <form
                                                            action="${pageContext.request.contextPath}/admin/user-delete"
                                                            method="POST" class="inline-flex">
                                                            <input type="hidden" name="userId" value="${u.userId}">
                                                            <button type="submit"
                                                                onclick="return confirm('Bạn có chắc chắn muốn XÓA VĨNH VIỄN tài khoản này không? Mọi lịch sử đơn hàng, đánh giá, voucher của tài khoản này sẽ biến mất vĩnh viễn.');"
                                                                class="text-red-500 hover:text-red-700 transition-colors p-1"
                                                                title="Xóa tài khoản">
                                                                <svg class="w-5 h-5" fill="none" stroke="currentColor"
                                                                    viewBox="0 0 24 24">
                                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                                        stroke-width="2"
                                                                        d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16">
                                                                    </path>
                                                                </svg>
                                                            </button>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty users}">
                                        <tr>
                                            <td colspan="7" class="px-6 py-10 text-center text-gray-500">Không tìm thấy
                                                người dùng nào.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </body>

            </html>