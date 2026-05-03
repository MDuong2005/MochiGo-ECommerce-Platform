<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Đặt hàng thành công - MochiGo</title>
                <script src="https://cdn.tailwindcss.com"></script>
            </head>

            <body class="flex flex-col min-h-screen bg-gray-50">

                <jsp:include page="/common/navbar.jsp" />

                <main class="flex-grow flex items-center justify-center p-4">
                    <div
                        class="bg-white rounded-3xl shadow-xl w-full max-w-lg p-10 text-center relative overflow-hidden">
                        <div class="absolute top-0 right-0 -mt-10 -mr-10 w-32 h-32 bg-pink-50 rounded-full opacity-50">
                        </div>
                        <div
                            class="absolute bottom-0 left-0 -mb-10 -ml-10 w-32 h-32 bg-pink-100 rounded-full opacity-50">
                        </div>

                        <div class="flex justify-center mb-6">
                            <div class="bg-green-100 p-4 rounded-full inline-block animate-bounce shadow-inner">
                                <svg class="w-16 h-16 text-green-500" fill="none" stroke="currentColor"
                                    viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                </svg>
                            </div>
                        </div>

                        <h2 class="text-3xl font-extrabold text-gray-900 mb-4 tracking-tight">Đặt hàng thành công! 🎉
                        </h2>
                        <p class="text-gray-600 mb-8 text-lg font-medium">
                            Cảm ơn bạn đã mua sắm tại <strong>MochiGo</strong>. Đơn hàng của bạn đang được xử lý và sẽ
                            sớm được
                            giao.
                        </p>

                        <c:set var="finalOrderId" value="${not empty param.orderId ? param.orderId : orderId}" />
                        <c:set var="finalAmount" value="${not empty param.amount ? param.amount : totalAmount}" />
                        <c:set var="finalPaymentMethod"
                            value="${not empty param.orderId ? 'BANK_TRANSFER' : paymentMethod}" />

                        <c:if test="${finalPaymentMethod == 'BANK_TRANSFER'}">
                            <div
                                class="mt-2 mb-8 text-center bg-white rounded-2xl p-6 border-2 border-pink-200 shadow-sm relative overflow-hidden">
                                <div class="absolute -right-4 -top-4 w-16 h-16 bg-pink-100 rounded-full"></div>
                                <h3 class="text-xl font-bold text-gray-800 mb-2">Thanh toán thành công qua mã QR</h3>
                                <p class="text-pink-600 font-bold mb-4">MB Bank - 0979705956</p>

                                <div class="bg-gray-50 p-4 rounded-xl inline-block shadow-inner border border-gray-100">
                                    <svg class="mx-auto w-24 h-24 text-green-500 mb-2" fill="none" stroke="currentColor"
                                        viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z">
                                        </path>
                                    </svg>
                                    <p class="text-gray-800 font-bold">Giao dịch đã được ghi nhận</p>
                                </div>

                                <p class="text-gray-800 font-extrabold mt-4 text-xl">
                                    <fmt:formatNumber value="${finalAmount}" type="number" groupingUsed="true"
                                        maxFractionDigits="0" /> đ
                                </p>
                                <p class="text-sm text-gray-500 mt-2 font-medium">Mã đơn hàng: #${finalOrderId}</p>

                                <!-- Thông báo hướng dẫn Khách hàng sau khi chuyển khoản -->
                                <div class="mt-6 p-4 bg-green-50 border border-green-200 rounded-xl text-green-800 text-sm text-left flex items-start shadow-sm transition-all duration-500"
                                    id="paymentStatusBox">
                                    <svg class="w-6 h-6 mr-3 flex-shrink-0 text-green-600 animate-spin"
                                        id="paymentStatusIcon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15">
                                        </path>
                                    </svg>
                                    <span id="paymentStatusText">
                                        <strong class="font-bold block mb-1">Đang chờ thanh toán...</strong>
                                        Hệ thống đang liên tục kiểm tra trạng thái chuyển khoản của bạn. Đừng đóng trang
                                        này. Xin chờ trong giây lát...
                                    </span>
                                </div>
                            </div>

                            <script>
                                document.addEventListener('DOMContentLoaded', function () {
                                    const orderId = '${finalOrderId}';
                                    const urlParams = new URLSearchParams(window.location.search);

                                    // If redirected back from PayOS with code=00
                                    if (urlParams.get('code') === '00' && urlParams.get('orderCode')) {
                                        // Auto confirm locally since webhook can't reach localhost
                                        fetch('${pageContext.request.contextPath}/api/payos-local-confirm?orderId=' + orderId, { method: 'POST' })
                                            .then(res => res.json())
                                            .then(data => {
                                                if (data.success) {
                                                    document.getElementById('paymentStatusIcon').classList.remove('animate-spin');
                                                    document.getElementById('paymentStatusIcon').innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"></path>';
                                                    document.getElementById('paymentStatusText').innerHTML = '<strong class="font-bold block mb-1">Thanh toán hoàn tất! 🎉</strong>Hệ thống đã nhận được tiền qua chuyển khoản. Đơn hàng đang chuẩn bị được giao.';
                                                }
                                            });
                                        return; // Stop polling
                                    }

                                    let checkCount = 0;
                                    const maxChecks = 60; // 60 checks * 3s = 180s (3 minutes timeout)

                                    const checkStatus = setInterval(() => {
                                        fetch('${pageContext.request.contextPath}/api/payos-check?orderId=' + orderId)
                                            .then(res => res.json())
                                            .then(data => {
                                                if (data.success && data.status === 'PAID') {
                                                    clearInterval(checkStatus);
                                                    document.getElementById('paymentStatusIcon').classList.remove('animate-spin');
                                                    document.getElementById('paymentStatusIcon').innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"></path>';
                                                    document.getElementById('paymentStatusText').innerHTML = '<strong class="font-bold block mb-1">Thanh toán hoàn tất! 🎉</strong>Hệ thống đã nhận được tiền và tự động duyệt đơn hàng. Đơn hàng đang chuẩn bị được giao.';
                                                } else {
                                                    checkCount++;
                                                    if (checkCount >= maxChecks) {
                                                        clearInterval(checkStatus);
                                                        document.getElementById('paymentStatusIcon').classList.remove('animate-spin');
                                                        document.getElementById('paymentStatusIcon').innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>';
                                                        document.getElementById('paymentStatusText').innerHTML = '<strong class="font-bold block mb-1">Đã hết thời gian chờ tự động</strong>Bạn đã chuyển tiền chưa? Nếu rồi, hệ thống sẽ tiếp tục kiểm tra và cập nhật muộn nhất sau 5 phút trong mục Lịch sử.';
                                                    }
                                                }
                                            })
                                            .catch(e => console.error('Error checking payment status', e));
                                    }, 3000); // Check every 3 seconds
                                });
                            </script>
                        </c:if>

                        <%-- Thông báo voucher bị gỡ tự động --%>
                        <c:set var="voucherMsg" value="${not empty voucherRemovedMsg ? voucherRemovedMsg : sessionScope.voucherRemovedMsg}" />
                        <c:if test="${not empty voucherMsg}">
                            <div class="mb-6 bg-yellow-50 border border-yellow-300 text-yellow-800 rounded-xl px-4 py-3 text-sm text-left flex items-start gap-2 shadow-sm">
                                <span class="text-lg flex-shrink-0">⚠️</span>
                                <span>${voucherMsg}</span>
                            </div>
                            <c:remove var="voucherRemovedMsg" scope="session" />
                        </c:if>

                        <div class="space-y-4">
                            <a href="${pageContext.request.contextPath}/history"
                                class="w-full flex justify-center py-4 px-4 border shadow-sm text-base font-bold rounded-xl text-pink-700 bg-pink-50 hover:bg-pink-100 transition-colors">
                                Xem lịch sử đơn hàng
                            </a>

                            <a href="${pageContext.request.contextPath}/products"
                                class="w-full flex justify-center py-4 px-4 border border-transparent text-base font-bold rounded-xl text-white bg-pink-600 hover:bg-pink-700 shadow-md transition-colors">
                                Tiếp tục mua sắm
                            </a>
                        </div>
                    </div>
                </main>

                <jsp:include page="/common/footer.jsp" />

            </body>

            </html>