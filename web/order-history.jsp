<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Lịch sử đơn hàng - MochiGo</title>
                <script src="https://cdn.tailwindcss.com"></script>
            </head>

            <body class="flex flex-col min-h-screen bg-gray-50">

                <jsp:include page="/common/navbar.jsp" />

                <main class="flex-grow max-w-7xl mx-auto py-12 px-4 sm:px-6 lg:px-8 w-full">

                    <h2 class="text-3xl font-extrabold text-gray-900 tracking-tight mb-8">Lịch sử đơn hàng 📦</h2>

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

                    <c:choose>
                        <c:when test="${empty orders}">
                            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-12 text-center">
                                <p class="text-gray-500 text-xl font-medium mb-6">Bạn chưa có đơn hàng nào.</p>
                                <a href="${pageContext.request.contextPath}/products"
                                    class="inline-flex items-center px-8 py-3 border border-transparent text-base font-bold rounded-full shadow-md text-white bg-pink-600 hover:bg-pink-700 transition">
                                    Khám phá bánh kẹo
                                </a>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <div class="bg-white shadow-sm border border-gray-100 rounded-2xl overflow-hidden">
                                <div class="overflow-x-auto">
                                    <table class="min-w-full divide-y divide-gray-200">
                                        <thead class="bg-gray-50">
                                            <tr>
                                                <th scope="col"
                                                    class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                    Mã đơn</th>
                                                <th scope="col"
                                                    class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                    Ngày đặt</th>
                                                <th scope="col"
                                                    class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                    Người nhận</th>
                                                <th scope="col"
                                                    class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                    Tổng tiền</th>
                                                <th scope="col"
                                                    class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                    Trạng thái</th>
                                                <th scope="col"
                                                    class="px-6 py-4 text-right text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                    Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody class="bg-white divide-y divide-gray-200">
                                            <c:forEach var="o" items="${orders}">
                                                <tr class="hover:bg-gray-50 transition-colors">
                                                    <td
                                                        class="px-6 py-4 whitespace-nowrap text-sm font-semibold text-gray-900">
                                                        <a href="${pageContext.request.contextPath}/history?action=detail&id=${o.orderId}"
                                                            class="text-pink-600 hover:underline">
                                                            #${o.orderId}
                                                        </a>
                                                    </td>
                                                    <td
                                                        class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-500">
                                                        <fmt:formatDate value="${o.createdAt}"
                                                            pattern="dd/MM/yyyy HH:mm" />
                                                    </td>
                                                    <td
                                                        class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                                        ${o.receiverName}
                                                    </td>
                                                    <td
                                                        class="px-6 py-4 whitespace-nowrap text-sm font-bold text-pink-600">
                                                        <fmt:formatNumber value="${o.totalAmount}" type="number"
                                                            maxFractionDigits="0" /> đ
                                                    </td>
                                                    <td class="px-6 py-4 whitespace-nowrap">
                                                        <div class="flex flex-col gap-2">
                                                            <c:choose>
                                                                <c:when test="${o.status == 'PENDING'}">
                                                                    <div class="flex flex-col items-start gap-2">
                                                                        <span
                                                                            class="px-3 py-1 inline-flex text-xs leading-5 font-bold rounded-full bg-yellow-100 text-yellow-800 uppercase tracking-wide">
                                                                            Đang xử lý
                                                                        </span>
                                                                        <c:if test="${o.paymentMethod == 'BANK_TRANSFER'}">
                                                                            <a href="${pageContext.request.contextPath}/repay?orderId=${o.orderId}"
                                                                                class="px-3 py-1 bg-pink-600 hover:bg-pink-700 text-white text-xs font-bold rounded shadow-sm transition-colors text-center">
                                                                                Thanh toán lại
                                                                            </a>
                                                                        </c:if>
                                                                    </div>
                                                                </c:when>
                                                                <c:when test="${o.status == 'CONFIRMED'}">
                                                                    <span
                                                                        class="px-3 py-1 inline-flex text-xs leading-5 font-bold rounded-full bg-blue-100 text-blue-800 uppercase tracking-wide">
                                                                        Đã xác nhận
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${o.status == 'SHIPPING'}">
                                                                    <span
                                                                        class="px-3 py-1 inline-flex text-xs leading-5 font-bold rounded-full bg-indigo-100 text-indigo-800 uppercase tracking-wide">
                                                                        Đang giao
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${o.status == 'COMPLETED'}">
                                                                    <span
                                                                        class="px-3 py-1 inline-flex text-xs leading-5 font-bold rounded-full bg-green-100 text-green-800 uppercase tracking-wide">
                                                                        Hoàn thành
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${o.status == 'CANCELLED'}">
                                                                    <span
                                                                        class="px-3 py-1 inline-flex text-xs leading-5 font-bold rounded-full bg-red-100 text-red-800 uppercase tracking-wide">
                                                                        Đã hủy
                                                                    </span>
                                                                </c:when>
                                                            </c:choose>

                                                            <c:if test="${o.status == 'PENDING' || o.status == 'PAID'}">
                                                                <form action="${pageContext.request.contextPath}/history" method="post" 
                                                                      onsubmit="return confirm('Bạn có chắc chắn muốn hủy đơn hàng này? Số lượng sản phẩm sẽ được hoàn lại kho.');">
                                                                    <input type="hidden" name="action" value="cancel">
                                                                    <input type="hidden" name="id" value="${o.orderId}">
                                                                    <button type="submit" 
                                                                            class="text-xs font-bold text-red-600 hover:text-red-800 border border-red-200 px-2 py-1 rounded bg-red-50 hover:bg-red-100 transition-colors w-full">
                                                                        Hủy đơn
                                                                    </button>
                                                                </form>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                    <td
                                                        class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                                        <a href="${pageContext.request.contextPath}/history?action=detail&id=${o.orderId}"
                                                            class="text-pink-600 hover:text-pink-900">Xem chi tiết
                                                            &rarr;</a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>

                </main>

                <jsp:include page="/common/footer.jsp" />

            </body>

            </html>