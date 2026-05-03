<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Giỏ hàng - MochiGo</title>
                <script src="https://cdn.tailwindcss.com"></script>
            </head>

            <body class="flex flex-col min-h-screen bg-gray-50">

                <jsp:include page="/common/navbar.jsp" />

                <main class="flex-grow max-w-7xl mx-auto py-12 px-4 sm:px-6 lg:px-8 w-full">

                    <h1 class="text-3xl font-extrabold text-gray-900 tracking-tight mb-8">Giỏ hàng của bạn 🛍️</h1>

                    <c:if test="${not empty sessionScope.errorMsg}">
                        <div class="bg-red-50 border-l-4 border-red-400 p-4 mb-6" role="alert">
                            <p class="text-red-700">${sessionScope.errorMsg}</p>
                        </div>
                        <c:remove var="errorMsg" scope="session" />
                    </c:if>

                    <c:choose>
                        <c:when test="${empty cartItems}">
                            <div class="text-center py-16 bg-white rounded-2xl shadow-sm border border-gray-100">
                                <p class="text-gray-500 text-xl font-medium mb-6">Giỏ hàng của bạn đang trống.</p>
                                <a href="${pageContext.request.contextPath}/products"
                                    class="inline-flex py-3 px-8 text-white font-bold bg-pink-500 hover:bg-pink-600 rounded-full shadow-md transition-colors">
                                    Tiếp tục mua hàng
                                </a>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <div class="flex flex-col lg:flex-row gap-8">
                                <!-- Shopping Cart Items -->
                                <div class="lg:w-2/3">
                                    <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
                                        <ul class="divide-y divide-gray-100">
                                            <c:forEach var="item" items="${cartItems}">
                                                <li
                                                    class="p-6 flex flex-col sm:flex-row items-center hover:bg-gray-50 transition-colors">
                                                    <img src="${pageContext.request.contextPath}/${item.product.imageUrl}"
                                                        alt="${item.product.name}"
                                                        class="h-24 w-24 object-cover rounded-xl shadow-sm mb-4 sm:mb-0">
                                                    <div class="sm:ml-6 flex-1 flex flex-col">
                                                        <div class="flex justify-between w-full">
                                                            <h3 class="text-lg font-bold text-gray-900 mb-1">
                                                                <a href="${pageContext.request.contextPath}/products?action=detail&id=${item.product.productId}"
                                                                    class="hover:text-pink-600">${item.product.name}</a>
                                                            </h3>
                                                            <p class="text-lg font-bold text-pink-600">
                                                                <fmt:formatNumber value="${item.lineTotal}"
                                                                    type="number" groupingUsed="true" maxFractionDigits="0" /> đ
                                                            </p>
                                                        </div>
                                                        <p class="mt-1 text-sm text-gray-500 flex items-center mb-4">
                                                            <span class="mr-3">Đơn giá:
                                                                <fmt:formatNumber value="${item.product.price}"
                                                                    type="number" groupingUsed="true" maxFractionDigits="0" /> đ
                                                            </span>
                                                            <c:choose>
                                                                <c:when test="${item.product.stock > 0}">
                                                                    <span
                                                                        class="bg-green-100 text-green-800 text-xs px-2 py-0.5 rounded">Trong
                                                                        kho: ${item.product.stock}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span
                                                                        class="bg-red-100 text-red-800 text-xs px-2 py-0.5 rounded">Hết
                                                                        hàng</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </p>

                                                        <div class="flex items-center justify-between w-full">
                                                            <form action="${pageContext.request.contextPath}/cart"
                                                                method="post" class="flex items-center">
                                                                <input type="hidden" name="action" value="update">
                                                                <input type="hidden" name="productId"
                                                                    value="${item.product.productId}">
                                                                <label for="qty-${item.product.productId}"
                                                                    class="sr-only">Số lượng</label>
                                                                <input id="qty-${item.product.productId}" type="number"
                                                                    name="quantity" value="${item.quantity}" min="1"
                                                                    max="${item.product.stock > 0 ? item.product.stock : 1}"
                                                                    class="w-16 border-gray-300 rounded-lg py-1 px-2 text-center text-sm mr-2 focus:ring-pink-500 focus:border-pink-500">
                                                                <button type="submit"
                                                                    class="text-sm text-blue-500 hover:text-blue-700 font-medium">Cập
                                                                    nhật</button>
                                                            </form>

                                                            <form action="${pageContext.request.contextPath}/cart"
                                                                method="post" class="ml-4">
                                                                <input type="hidden" name="action" value="remove">
                                                                <input type="hidden" name="productId"
                                                                    value="${item.product.productId}">
                                                                <button type="submit"
                                                                    class="text-sm font-medium text-red-500 hover:text-red-700 flex items-center p-1 rounded hover:bg-red-50 transition-colors">
                                                                    <svg class="h-4 w-4 mr-1" fill="none"
                                                                        stroke="currentColor" viewBox="0 0 24 24">
                                                                        <path stroke-linecap="round"
                                                                            stroke-linejoin="round" stroke-width="2"
                                                                            d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                                                    </svg>
                                                                    Xóa
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                </div>

                                <!-- Order Summary -->
                                <div class="lg:w-1/3">
                                    <div
                                        class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 sticky top-24">
                                        <h2 class="text-xl font-bold text-gray-900 mb-6 pb-4 border-b">Tóm tắt đơn hàng
                                        </h2>

                                        <div class="flex justify-between mb-4">
                                            <span class="text-gray-600">Tạm tính:</span>
                                            <span class="font-medium text-gray-900">
                                                <fmt:formatNumber value="${cartTotal}" type="number"
                                                    maxFractionDigits="0" /> đ
                                            </span>
                                        </div>
                                        <div class="flex justify-between mb-6 pb-6 border-b border-gray-100">
                                            <span class="text-gray-600">Phí giao hàng:</span>
                                            <span class="font-medium text-green-600 uppercase text-sm">Miễn phí</span>
                                        </div>

                                        <c:set var="discountAmt" value="0" />
                                        <c:if test="${not empty sessionScope.appliedVoucher}">
                                            <c:if test="${cartTotal >= sessionScope.appliedVoucher.minOrderValue}">
                                                <c:if test="${sessionScope.appliedVoucher.discountType == 'PERCENT'}">
                                                    <c:set var="calculatedDiscount"
                                                        value="${cartTotal * sessionScope.appliedVoucher.discountValue / 100}" />
                                                    <c:choose>
                                                        <c:when
                                                            test="${not empty sessionScope.appliedVoucher.maxDiscountValue and calculatedDiscount > sessionScope.appliedVoucher.maxDiscountValue}">
                                                            <c:set var="discountAmt"
                                                                value="${sessionScope.appliedVoucher.maxDiscountValue}" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:set var="discountAmt" value="${calculatedDiscount}" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:if>
                                                <c:if test="${sessionScope.appliedVoucher.discountType == 'FIXED'}">
                                                    <c:set var="discountAmt"
                                                        value="${sessionScope.appliedVoucher.discountValue}" />
                                                </c:if>
                                                <c:if test="${discountAmt > cartTotal}">
                                                    <c:set var="discountAmt" value="${cartTotal}" />
                                                </c:if>
                                            </c:if>
                                        </c:if>

                                        <c:if test="${discountAmt > 0}">
                                            <div class="flex justify-between mb-4 pb-4 border-b border-gray-100">
                                                <span class="text-gray-600">Voucher áp dụng
                                                    (${sessionScope.appliedVoucher.code}):</span>
                                                <span class="font-medium text-pink-600">
                                                    -
                                                    <fmt:formatNumber value="${discountAmt}" type="number"
                                                        groupingUsed="true" maxFractionDigits="0" /> đ
                                                </span>
                                            </div>
                                        </c:if>

                                        <div class="flex justify-between mb-8">
                                            <span class="text-xl font-bold text-gray-900">Tổng cộng:</span>
                                            <span class="text-2xl font-extrabold text-pink-600 tracking-tight">
                                                <fmt:formatNumber value="${cartTotal - discountAmt}" type="number"
                                                    groupingUsed="true" maxFractionDigits="0" /> đ
                                            </span>
                                        </div>

                                        <!-- COUPON FORM -->
                                        <div class="mb-6 mb-8 mt-2">
                                            <form id="couponForm"
                                                action="${pageContext.request.contextPath}/apply-coupon" method="POST"
                                                class="flex gap-2 relative">
                                                <input type="text" name="couponCode" id="couponCodeInput"
                                                    placeholder="Nhập mã (Vd: CODE10)"
                                                    value="${not empty sessionScope.appliedVoucher ? sessionScope.appliedVoucher.code : ''}"
                                                    class="w-full text-sm border-gray-300 rounded-lg py-3 px-4 focus:ring-pink-500 focus:border-pink-500 shadow-sm border uppercase">
                                                <input type="hidden" name="returnUrl"
                                                    value="${pageContext.request.contextPath}/cart">
                                                <button type="submit"
                                                    class="absolute right-0 top-0 bottom-0 bg-gray-800 text-white px-4 rounded-r-lg font-bold hover:bg-gray-700 text-sm">
                                                    Áp dụng
                                                </button>
                                            </form>
                                            <c:if test="${not empty sessionScope.couponSuccess}">
                                                <p class="text-green-600 text-xs mt-2 italic font-medium">✔️
                                                    ${sessionScope.couponSuccess}</p>
                                                <c:if test="${cartTotal < sessionScope.appliedVoucher.minOrderValue}">
                                                    <p class="text-red-500 text-xs mt-1">⚠️ Chưa đạt đơn tối thiểu
                                                        <fmt:formatNumber
                                                            value="${sessionScope.appliedVoucher.minOrderValue}"
                                                            type="number" groupingUsed="true" maxFractionDigits="0" />đ
                                                    </p>
                                                </c:if>
                                                <c:remove var="couponSuccess" scope="session" />
                                            </c:if>
                                            <c:if test="${not empty sessionScope.couponError}">
                                                <p class="text-red-500 text-xs mt-2 italic font-medium">❌
                                                    ${sessionScope.couponError}</p>
                                                <c:remove var="couponError" scope="session" />
                                            </c:if>
                                            <c:if test="${not empty sessionScope.couponMsg}">
                                                <p class="text-gray-500 text-xs mt-2 italic font-medium">
                                                    ${sessionScope.couponMsg}</p>
                                                <c:remove var="couponMsg" scope="session" />
                                            </c:if>

                                            <!-- Available Vouchers List -->
                                            <c:if test="${not empty availableVouchers}">
                                                <div class="mt-4 border-t pt-4">
                                                    <p class="text-sm font-bold text-gray-700 mb-2">Voucher dành cho
                                                        bạn:</p>
                                                    <div class="space-y-2 max-h-48 overflow-y-auto">
                                                        <c:forEach var="v" items="${availableVouchers}">
                                                            <div class="border rounded-lg p-3 flex justify-between items-center bg-gray-50 hover:bg-pink-50 transition-colors cursor-pointer"
                                                                onclick="document.getElementById('couponCodeInput').value='${v.code}';">
                                                                <div>
                                                                    <p
                                                                        class="font-bold text-pink-600 text-sm uppercase">
                                                                        ${v.code}</p>
                                                                    <p class="text-xs text-gray-500 mt-1">
                                                                        Giảm
                                                                        <c:if test="${v.discountType == 'PERCENT'}">
                                                                            <span
                                                                                class="font-bold text-gray-800">${v.discountValue}%</span>
                                                                        </c:if>
                                                                        <c:if test="${v.discountType == 'FIXED'}"><span
                                                                                class="font-bold text-gray-800">
                                                                                <fmt:formatNumber
                                                                                    value="${v.discountValue}"
                                                                                    type="number" groupingUsed="true" maxFractionDigits="0" />
                                                                                đ
                                                                            </span></c:if>
                                                                        (Cho đơn từ
                                                                        <fmt:formatNumber value="${v.minOrderValue}"
                                                                            type="number" groupingUsed="true" maxFractionDigits="0" />đ)
                                                                    </p>
                                                                </div>
                                                                <button type="button"
                                                                    class="text-xs bg-pink-100 font-bold text-pink-700 px-3 py-1.5 rounded hover:bg-pink-200"
                                                                    onclick="document.getElementById('couponCodeInput').value='${v.code}'; document.getElementById('couponForm').submit();">Dùng</button>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </div>

                                        <a href="${pageContext.request.contextPath}/checkout"
                                            class="w-full flex justify-center py-4 px-4 border border-transparent rounded-xl shadow-lg text-lg font-bold text-white bg-pink-600 hover:bg-pink-700 transition">
                                            Tiến hành thanh toán
                                        </a>

                                        <p class="mt-4 text-center text-xs text-gray-400">
                                            Chưa bao gồm thuế giá trị gia tăng (VAT)
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>

                </main>

                <jsp:include page="/common/footer.jsp" />

            </body>

            </html>