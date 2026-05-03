<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Thanh toán - MochiGo</title>
                <script src="https://cdn.tailwindcss.com"></script>
            </head>

            <body class="flex flex-col min-h-screen bg-gray-50">

                <jsp:include page="/common/navbar.jsp" />

                <main class="flex-grow max-w-3xl mx-auto py-12 px-4 sm:px-6 lg:px-8 w-full">

                    <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-8">
                        <h2 class="text-3xl font-extrabold text-gray-900 tracking-tight mb-8 text-center">Thanh toán 💳
                        </h2>

                        <c:if test="${not empty error}">
                            <div class="bg-red-50 border-l-4 border-red-400 p-4 mb-8 rounded-lg" role="alert">
                                <p class="text-red-700 font-medium">${error}</p>
                            </div>
                        </c:if>

                        <c:set var="checkoutTotal" value="0" />
                        <!-- Tính toán nhanh tổng giỏ hàng -->
                        <c:forEach var="entry" items="${sessionScope.cart}">
                            <c:set var="checkoutTotal" value="${checkoutTotal + 1}" />
                            <!-- This is just a placeholder, calculating total in checkout isn't easy without DAO, so I will fetch it dynamically or just rely on Cart Controller if it put it in session-->
                        </c:forEach>

                        <!-- Wait, checkout.jsp doesn't have cartTotal readily available unless the controller set it.
                             Let me check if OrderController.doGet sets it. Wait, OrderController doesn't set it in GET. 
                             It's better if we display a generic message about coupon if applied, or pass it via OrderController. 
                             I'll modify OrderController to set cartTotal on GET.
                             But I can just show the applied coupon info. -->

                        <c:if test="${not empty sessionScope.appliedVoucher}">
                            <div
                                class="bg-green-50 border border-green-200 text-green-800 px-4 py-3 rounded-xl mb-6 flex justify-between items-center shadow-sm">
                                <div>
                                    <span class="font-bold block text-sm">🎟️ Đang áp dụng mã:
                                        ${sessionScope.appliedVoucher.code}</span>
                                    <span class="text-xs">
                                        Giảm
                                        <c:choose>
                                            <c:when test="${sessionScope.appliedVoucher.discountType == 'PERCENT'}">
                                                ${sessionScope.appliedVoucher.discountValue}% (Tối đa
                                                <fmt:formatNumber value="${sessionScope.appliedVoucher.maxDiscountValue}"
                                                    type="number" groupingUsed="true" maxFractionDigits="0" />đ - Đơn từ
                                                <fmt:formatNumber value="${sessionScope.appliedVoucher.minOrderValue}"
                                                    type="number" groupingUsed="true" maxFractionDigits="0" />đ)
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatNumber value="${sessionScope.appliedVoucher.discountValue}"
                                                    type="number" groupingUsed="true" maxFractionDigits="0" />đ (Đơn từ
                                                <fmt:formatNumber value="${sessionScope.appliedVoucher.minOrderValue}"
                                                    type="number" groupingUsed="true" maxFractionDigits="0" />đ)
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <form action="${pageContext.request.contextPath}/apply-coupon" method="post"
                                    class="m-0">
                                    <input type="hidden" name="couponCode" value="">
                                    <input type="hidden" name="returnUrl"
                                        value="${pageContext.request.contextPath}/checkout">
                                    <button type="submit"
                                        class="text-sm font-bold text-red-500 hover:text-red-700 bg-white px-3 py-1 rounded-lg border border-red-200 shadow-sm">Bỏ
                                        mã</button>
                                </form>
                            </div>
                            <c:if test="${not empty sessionScope.couponMsg}">
                                <p class="text-gray-500 text-xs mt-2 italic font-medium mb-4">${sessionScope.couponMsg}
                                </p>
                                <c:remove var="couponMsg" scope="session" />
                            </c:if>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/checkout" method="post" class="space-y-6">
                            <h3 class="text-xl font-bold text-gray-900 border-b pb-3 mb-6">Thông tin giao hàng</h3>

                            <div>
                                <label class="block text-sm font-medium leading-6 text-gray-900 mb-2">Họ tên người nhận
                                    <span class="text-red-500">*</span></label>
                                <div class="mt-2 text-sm italic py-2 px-3 border border-pink-100 bg-pink-50 rounded-md">
                                    ${sessionScope.user.fullName}
                                </div>
                                <input type="hidden" name="receiverName" value="${sessionScope.user.fullName}">
                            </div>

                            <div>
                                <label class="block text-sm font-medium leading-6 text-gray-900 mb-2">Số điện thoại
                                    <span class="text-red-500">*</span></label>
                                <input type="text" name="receiverPhone" value="${sessionScope.user.phone}"
                                    class="block w-full rounded-md border-0 py-2 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-pink-600 sm:text-sm sm:leading-6 px-3"
                                    required>
                            </div>

                            <div>
                                <label class="block text-sm font-medium leading-6 text-gray-900 mb-2">Địa chỉ giao hàng
                                    (chi tiết) <span class="text-red-500">*</span></label>
                                <textarea name="shippingAddress" rows="3"
                                    class="block w-full rounded-md border-0 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-pink-600 sm:py-2 sm:text-sm sm:leading-6 px-3"
                                    required></textarea>
                            </div>

                            <div>
                                <label class="block text-sm font-medium leading-6 text-gray-900 mb-2">Ghi chú đơn
                                    hàng</label>
                                <textarea name="note" rows="2"
                                    class="block w-full rounded-md border-0 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-pink-600 sm:py-2 sm:text-sm sm:leading-6 px-3"></textarea>
                            </div>

                            <h3 class="text-xl text-gray-900 font-bold border-b pb-3 mt-10 mb-6">Phương thức thanh toán
                            </h3>

                            <div class="space-y-4">
                                <div
                                    class="flex items-center p-4 border rounded-xl hover:bg-gray-50 cursor-pointer shadow-sm">
                                    <input id="cod" name="paymentMethod" type="radio" value="COD"
                                        class="h-5 w-5 border-gray-300 text-pink-600 focus:ring-pink-600" checked>
                                    <label for="cod"
                                        class="ml-3 block text-sm font-medium leading-6 text-gray-900 cursor-pointer">
                                        Thanh toán khi nhận hàng (COD)
                                    </label>
                                </div>
                                <div
                                    class="flex items-center p-4 border rounded-xl hover:bg-gray-50 cursor-pointer shadow-sm">
                                    <input id="bank" name="paymentMethod" type="radio" value="BANK_TRANSFER"
                                        class="h-5 w-5 border-gray-300 text-pink-600 focus:ring-pink-600">
                                    <label for="bank"
                                        class="ml-3 block text-sm font-medium leading-6 text-gray-900 cursor-pointer">
                                        Chuyển khoản QR (MB Bank)
                                    </label>
                                </div>
                            </div>

                            <div class="pt-8">
                                <button type="submit"
                                    class="w-full bg-pink-600 text-white rounded-xl py-4 flex items-center justify-center font-bold text-lg hover:bg-pink-700 shadow-lg transition-transform focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-pink-600 transform hover:scale-[1.02]">
                                    <svg class="h-6 w-6 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                    </svg>
                                    Xác nhận đặt hàng
                                </button>
                            </div>
                        </form>
                    </div>

                </main>

                <jsp:include page="/common/footer.jsp" />

            </body>

            </html>