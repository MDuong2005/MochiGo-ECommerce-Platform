<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Quản lý Đơn hàng - Admin</title>
                <script src="https://cdn.tailwindcss.com"></script>
            </head>

            <body class="bg-gray-100 min-h-screen flex flex-col">

                <jsp:include page="/admin/admin-nav.jsp" />

                <div class="max-w-7xl mx-auto py-10 px-4 sm:px-6 lg:px-8 w-full flex-grow">
                    <h1 class="text-3xl font-extrabold text-gray-900 mb-8">Quản lý Đơn hàng 📦</h1>

                    <div class="bg-white rounded-xl shadow-sm overflow-hidden border">
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-gray-200">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th scope="col"
                                            class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Mã ĐH</th>
                                        <th scope="col"
                                            class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Sản phẩm</th>
                                        <th scope="col"
                                            class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Người nhận</th>
                                        <th scope="col"
                                            class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            SĐT</th>
                                        <th scope="col"
                                            class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Tổng tiền</th>
                                        <th scope="col"
                                            class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Thanh toán</th>
                                        <th scope="col"
                                            class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Trạng thái</th>
                                        <th scope="col"
                                            class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-200">
                                    <c:forEach var="order" items="${orders}">
                                        <tr class="hover:bg-gray-50">
                                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                                #${order.orderId}</td>
                                            <td class="px-6 py-4 text-sm text-gray-900 max-w-xs truncate" style="white-space: normal;">
                                                <ul class="list-disc pl-4 space-y-1">
                                                    <c:forEach var="item" items="${order.items}">
                                                        <li>
                                                            <span class="font-medium">${item.productName}</span> 
                                                            <span class="text-gray-500 text-xs">x${item.quantity}</span>
                                                        </li>
                                                    </c:forEach>
                                                </ul>
                                            </td>
                                            <td class="px-6 py-4 text-sm text-gray-500">${order.receiverName}</td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                ${order.receiverPhone}</td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-pink-600">
                                                <fmt:formatNumber value="${order.totalAmount}" type="number"
                                                    maxFractionDigits="0" /> đ
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                <c:choose>
                                                    <c:when test="${order.paymentMethod == 'BANK_TRANSFER'}"><span
                                                            class="bg-blue-100 text-blue-800 px-2 py-1 rounded text-xs font-medium">Chuyển
                                                            khoản QR</span></c:when>
                                                    <c:otherwise><span
                                                            class="bg-gray-100 text-gray-800 px-2 py-1 rounded text-xs font-medium">COD
                                                            (Tiền mặt)</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                	<c:choose>
                                                    <c:when test="${order.status == 'PENDING'}">
                                                        <span
                                                            class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">Chờ
                                                            duyệt</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'PAID'}">
                                                        <span
                                                            class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">Đã
                                                            thanh toán ✅</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'SHIPPING'}">
                                                        <span
                                                            class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">Đang
                                                            giao</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'COMPLETED'}">
                                                        <span
                                                            class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">Hoàn
                                                            thành</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span
                                                            class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">Đã
                                                            hủy</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td
                                                class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium space-x-2">
                                                <c:if test="${order.status == 'PENDING' || order.status == 'PAID'}">
                                                    <form action="${pageContext.request.contextPath}/admin/orders"
                                                        method="post" class="inline">
                                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                                        <input type="hidden" name="action" value="approve">
                                                        <button type="submit"
                                                            class="text-white bg-blue-600 hover:bg-blue-700 px-3 py-1 rounded shadow-sm transition">Duyệt
                                                            &amp; Giao hàng</button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${order.status == 'SHIPPING'}">
                                                    <form action="${pageContext.request.contextPath}/admin/orders"
                                                        method="post" class="inline">
                                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                                        <input type="hidden" name="action" value="complete">
                                                        <button type="submit"
                                                            class="text-white bg-green-600 hover:bg-green-700 px-3 py-1 rounded shadow-sm transition">Xác
                                                            nhận Đã Giao</button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${order.status == 'PENDING' || order.status == 'PAID' || order.status == 'SHIPPING'}">
                                                    <form action="${pageContext.request.contextPath}/admin/orders"
                                                        method="post" class="inline">
                                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                                        <input type="hidden" name="action" value="cancel">
                                                        <button type="submit"
                                                            class="text-white bg-red-500 hover:bg-red-600 px-3 py-1 rounded shadow-sm transition"
                                                            onclick="return confirm('Hủy đơn hàng này?');">Hủy
                                                            Đơn</button>
                                                    </form>
                                                </c:if>
                                                <form action="${pageContext.request.contextPath}/admin/orders"
                                                    method="post" class="inline">
                                                    <input type="hidden" name="orderId" value="${order.orderId}">
                                                    <input type="hidden" name="action" value="delete">
                                                    <button type="submit"
                                                        class="text-red-500 hover:text-red-700 px-2 py-1 transition"
                                                        onclick="return confirm('Xóa vĩnh viễn đơn hàng này? Không thể khôi phục lại!');">
                                                        <svg class="w-5 h-5 inline" fill="none" stroke="currentColor"
                                                            viewBox="0 0 24 24">
                                                            <path stroke-linecap="round" stroke-linejoin="round"
                                                                stroke-width="2"
                                                                d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                                        </svg>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty orders}">
                                        <tr>
                                            <td colspan="8" class="px-6 py-10 text-center text-gray-500">Chưa có đơn
                                                hàng nào trong hệ thống, buồn hiu hắt 💔</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </body>

            </html>