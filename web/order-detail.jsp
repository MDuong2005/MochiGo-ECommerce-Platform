<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Chi tiết đơn hàng #${order.orderId} - MochiGo</title>
                <script src="https://cdn.tailwindcss.com"></script>
            </head>

            <body class="flex flex-col min-h-screen bg-gray-50">

                <jsp:include page="/common/navbar.jsp" />

                <main class="flex-grow max-w-5xl mx-auto py-12 px-4 sm:px-6 lg:px-8 w-full">

                    <div class="flex items-center mb-8">
                        <a href="${pageContext.request.contextPath}/history"
                            class="text-pink-600 hover:text-pink-800 mr-4 font-bold flex items-center">
                            <svg class="h-5 w-5 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M15 19l-7-7 7-7" />
                            </svg>
                            Quay lại lịch sử
                        </a>
                        <h2 class="text-3xl font-extrabold text-gray-900 tracking-tight">Chi tiết đơn hàng
                            #${order.orderId}</h2>
                    </div>

                    <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden mb-8">
                        <div
                            class="px-6 py-5 border-b border-gray-200 bg-gray-50 flex justify-between items-center bg-pink-50">
                            <div>
                                <p class="text-sm font-medium text-gray-500">Ngày đặt hàng</p>
                                <p class="text-lg font-bold text-gray-900">
                                    <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                </p>
                            </div>
                            <div class="text-right">
                                <p class="text-sm font-medium text-gray-500">Tổng thanh toán</p>
                                <p class="text-2xl font-black text-pink-600">
                                    <fmt:formatNumber value="${order.totalAmount}" type="number"
                                        groupingUsed="true" maxFractionDigits="0" /> đ
                                </p>
                            </div>
                        </div>

                        <div class="p-6">
                            <h3 class="text-lg font-bold text-gray-900 mb-4 border-b pb-2">Danh sách sản phẩm</h3>
                            <ul class="divide-y divide-gray-100 mb-8">
                                <c:forEach var="item" items="${orderItems}">
                                    <li class="py-4 flex justify-between items-center">
                                        <div class="flex items-center">
                                            <div class="ml-4">
                                                <p class="text-lg font-bold text-gray-900">Sản phẩm #${item.productId}
                                                </p>
                                                <p class="text-sm text-gray-500">Số lượng: ${item.quantity} x
                                                    <fmt:formatNumber value="${item.unitPrice}" type="number"
                                                        maxFractionDigits="0" /> đ
                                                </p>
                                                <c:if test="${order.status == 'COMPLETED'}">
                                                    <c:choose>
                                                        <c:when test="${reviewedMap[item.productId]}">
                                                            <span
                                                                class="inline-flex items-center mt-2 px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                                Đã đánh giá
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button
                                                                onclick="openReviewModal(${item.productId}, ${order.orderId})"
                                                                class="mt-2 inline-flex items-center px-3 py-1 border border-transparent text-xs font-medium rounded-full shadow-sm text-white bg-pink-600 hover:bg-pink-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-pink-500">
                                                                Đánh giá sao
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="text-lg font-bold text-gray-900">
                                            <fmt:formatNumber value="${item.lineTotal}" type="number"
                                                maxFractionDigits="0" /> đ
                                        </div>
                                    </li>
                                </c:forEach>
                            </ul>

                            <h3 class="text-lg font-bold text-gray-900 mb-4 border-b pb-2">Thông tin giao hàng</h3>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 bg-gray-50 p-6 rounded-xl">
                                <div>
                                    <p class="text-sm text-gray-500 mb-1">Người nhận</p>
                                    <p class="font-medium text-gray-900">${order.receiverName}</p>
                                </div>
                                <div>
                                    <p class="text-sm text-gray-500 mb-1">Số điện thoại</p>
                                    <p class="font-medium text-gray-900">${order.receiverPhone}</p>
                                </div>
                                <div class="md:col-span-2">
                                    <p class="text-sm text-gray-500 mb-1">Địa chỉ giao hàng</p>
                                    <p class="font-medium text-gray-900">${order.shippingAddress}</p>
                                </div>
                                <div class="md:col-span-2">
                                    <p class="text-sm text-gray-500 mb-1">Ghi chú</p>
                                    <p class="font-medium text-gray-900 italic">${empty order.note ? 'Không có' :
                                        order.note}</p>
                                </div>
                                <div>
                                    <p class="text-sm text-gray-500 mb-1">Phương thức thanh toán</p>
                                    <p class="font-bold text-pink-600 uppercase">${order.paymentMethod}</p>
                                </div>
                                <div>
                                    <p class="text-sm text-gray-500 mb-1">Trạng thái đơn hàng</p>
                                    <p
                                        class="font-bold uppercase ${order.status == 'COMPLETED' ? 'text-green-600' : (order.status == 'CANCELLED' ? 'text-red-600' : 'text-blue-600')}">
                                        ${order.status}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>

                <!-- Review Modal -->
                <div id="reviewModal" class="fixed inset-0 z-50 hidden overflow-y-auto" aria-labelledby="modal-title"
                    role="dialog" aria-modal="true">
                    <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
                        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true"
                            onclick="closeReviewModal()"></div>
                        <span class="hidden sm:inline-block sm:align-middle sm:h-screen"
                            aria-hidden="true">&#8203;</span>
                        <div
                            class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
                            <form action="${pageContext.request.contextPath}/review" method="POST">
                                <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                                    <h3 class="text-lg leading-6 font-medium text-gray-900" id="modal-title">Đánh giá
                                        sản phẩm</h3>
                                    <div class="mt-4">
                                        <input type="hidden" name="productId" id="reviewProductId" value="">
                                        <input type="hidden" name="orderId" id="reviewOrderId" value="">

                                        <label class="block text-sm font-medium text-gray-700">Chất lượng sản phẩm
                                            (Sao)</label>
                                        <input type="hidden" name="rating" id="reviewRating" value="5">
                                        <div class="flex items-center mt-2 mb-4 space-x-1" id="starContainer">
                                            <!-- Stars inserted via JS -->
                                        </div>

                                        <label for="reviewComment" class="block text-sm font-medium text-gray-700">Bình
                                            luận của bạn</label>
                                        <div class="mt-1">
                                            <textarea id="reviewComment" name="comment" rows="3"
                                                class="shadow-sm focus:ring-pink-500 focus:border-pink-500 block w-full sm:text-sm border-gray-300 rounded-md p-2 border"
                                                placeholder="Sản phẩm tuyệt vời..."></textarea>
                                        </div>
                                    </div>
                                </div>
                                <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
                                    <button type="submit"
                                        class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-pink-600 text-base font-medium text-white hover:bg-pink-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-pink-500 sm:ml-3 sm:w-auto sm:text-sm">Gửi
                                        đánh giá</button>
                                    <button type="button" onclick="closeReviewModal()"
                                        class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">Hủy</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <script>
                    function openReviewModal(productId, orderId) {
                        document.getElementById('reviewProductId').value = productId;
                        document.getElementById('reviewOrderId').value = orderId;
                        renderStars(5); // Default 5 stars
                        document.getElementById('reviewModal').classList.remove('hidden');
                    }

                    function closeReviewModal() {
                        document.getElementById('reviewModal').classList.add('hidden');
                    }

                    function setRating(rating) {
                        document.getElementById('reviewRating').value = rating;
                        renderStars(rating);
                    }

                    function renderStars(rating) {
                        const container = document.getElementById('starContainer');
                        let html = '';
                        for (let i = 1; i <= 5; i++) {
                            if (i <= rating) {
                                html += '<svg onclick="setRating(' + i + ')" class="w-8 h-8 text-yellow-400 cursor-pointer" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"></path></svg>';
                            } else {
                                html += '<svg onclick="setRating(' + i + ')" class="w-8 h-8 text-gray-300 cursor-pointer" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"></path></svg>';
                            }
                        }
                        container.innerHTML = html;
                    }
                </script>

                <jsp:include page="/common/footer.jsp" />

            </body>

            </html>