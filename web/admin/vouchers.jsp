<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Quản lý Voucher - Admin</title>
                <script src="https://cdn.tailwindcss.com"></script>
                <script>
                    function toggleVoucherStatus(voucherId, currentStatus) {
                        const newStatus = !currentStatus;

                        fetch('${pageContext.request.contextPath}/admin/voucher-status', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                            },
                            body: 'voucherId=' + voucherId + '&isActive=' + newStatus
                        })
                            .then(response => response.text())
                            .then(result => {
                                if (result === 'success') {
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
                        <h1 class="text-3xl font-extrabold text-gray-900">Quản lý Voucher 🎟️</h1>
                        <a href="${pageContext.request.contextPath}/admin/voucher-create"
                            class="bg-green-600 hover:bg-green-700 text-white px-4 py-2 flex items-center rounded-lg shadow-sm font-medium transition-colors">
                            Thêm Voucher
                        </a>
                    </div>

                    <!-- Bộ lọc -->
                    <div class="mb-6 bg-white p-4 rounded-lg shadow-sm border flex space-x-2">
                        <a href="${pageContext.request.contextPath}/admin/vouchers?status=ALL"
                            class="px-4 py-2 rounded border ${statusFilter == 'ALL' ? 'bg-pink-600 text-white border-pink-600' : 'text-gray-600 hover:bg-gray-50'}">
                            Tất cả
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/vouchers?status=HAPPENING"
                            class="px-4 py-2 rounded border ${statusFilter == 'HAPPENING' ? 'bg-pink-600 text-white border-pink-600' : 'text-gray-600 hover:bg-gray-50'}">
                            Đang diễn ra
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/vouchers?status=UPCOMING"
                            class="px-4 py-2 rounded border ${statusFilter == 'UPCOMING' ? 'bg-pink-600 text-white border-pink-600' : 'text-gray-600 hover:bg-gray-50'}">
                            Sắp diễn ra
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/vouchers?status=EXPIRED"
                            class="px-4 py-2 rounded border ${statusFilter == 'EXPIRED' ? 'bg-pink-600 text-white border-pink-600' : 'text-gray-600 hover:bg-gray-50'}">
                            Hết hạn
                        </a>
                    </div>

                    <div class="bg-white rounded-xl shadow-sm overflow-hidden border">
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-gray-200">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Mã
                                        </th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Giảm
                                            giá</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Loại
                                            đích</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Thời
                                            gian</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Đã
                                            dùng/Tổng</th>
                                        <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase">
                                            Trạng thái</th>
                                        <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">
                                            Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-200">
                                    <c:forEach var="v" items="${vouchers}">
                                        <tr class="hover:bg-gray-50">
                                            <td class="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-900">
                                                ${v.code}</td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-800">
                                                <c:choose>
                                                    <c:when test="${v.discountType == 'PERCENT'}">
                                                        ${v.discountValue}% (Max:
                                                        <fmt:formatNumber value="${v.maxDiscountValue}"
                                                            type="number" maxFractionDigits="0" /> đ)
                                                    </c:when>
                                                    <c:otherwise>
                                                        <fmt:formatNumber value="${v.discountValue}" pattern="#,###" maxFractionDigits="0" />đ
                                                    </c:otherwise>
                                                </c:choose>
                                                <br><span class="text-xs text-gray-500">Đơn tối thiểu:
                                                    <fmt:formatNumber value="${v.minOrderValue}" pattern="#,###" maxFractionDigits="0" />đ
                                                </span>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                ${v.targetType}
                                                <c:if test="${not empty v.targetGroup}">- ${v.targetGroup}</c:if>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                <fmt:formatDate value="${v.startDate}" pattern="dd/MM/yyyy HH:mm" />
                                                <br />
                                                <fmt:formatDate value="${v.endDate}" pattern="dd/MM/yyyy HH:mm" />
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                ${v.usedQuantity} / ${v.totalQuantity}
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-center">
                                                <%-- Badge trạng thái --%>
                                                <c:choose>
                                                    <c:when test="${v.expired}">
                                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-bold bg-red-100 text-red-800 mb-1">🔴 Hết hạn</span>
                                                    </c:when>
                                                    <c:when test="${v.usedUp}">
                                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-bold bg-yellow-100 text-yellow-800 mb-1">🟡 Hết lượt</span>
                                                    </c:when>
                                                    <c:when test="${v.notStarted}">
                                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-bold bg-gray-100 text-gray-600 mb-1">⚪ Chưa bắt đầu</span>
                                                    </c:when>
                                                    <c:when test="${v.active}">
                                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-bold bg-green-100 text-green-800 mb-1">🟢 Đang chạy</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-bold bg-gray-100 text-gray-500 mb-1">⛔ Tắt</span>
                                                    </c:otherwise>
                                                </c:choose>
                                                <br/>
                                                <%-- Toggle bật/tắt thủ công --%>
                                                <button onclick="toggleVoucherStatus(${v.voucherId}, ${v.active})"
                                                    title="Bật/Tắt voucher"
                                                    class="relative inline-flex h-6 w-11 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none ${v.active ? 'bg-pink-600' : 'bg-gray-200'}">
                                                    <span
                                                        class="pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out ${v.active ? 'translate-x-5' : 'translate-x-0'}"></span>
                                                </button>
                                            </td>
                                            <td
                                                class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium space-x-3">
                                                <!-- Add edit link -->
                                                <a href="${pageContext.request.contextPath}/admin/voucher-create?id=${v.voucherId}"
                                                    class="text-blue-600 hover:text-blue-900 transition-colors">Sửa</a>
                                                <!-- Add delete form -->
                                                <form action="${pageContext.request.contextPath}/admin/voucher-delete"
                                                    method="POST" class="inline">
                                                    <input type="hidden" name="voucherId" value="${v.voucherId}">
                                                    <button type="submit"
                                                        onclick="return confirm('Bạn có chắc chắn muốn xóa voucher này? Hành động này không thể hoàn tác.');"
                                                        class="text-red-600 hover:text-red-900 transition-colors">Xóa</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty vouchers}">
                                        <tr>
                                            <td colspan="7" class="px-6 py-10 text-center text-gray-500">Không tìm thấy
                                                voucher nào phù hợp.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </body>

            </html>