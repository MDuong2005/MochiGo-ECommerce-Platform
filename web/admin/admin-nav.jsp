<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <nav class="bg-pink-800 text-white shadow-md">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex flex-wrap items-center justify-between py-3 gap-y-4">
                    <div class="flex items-center flex-wrap">
                        <a href="${pageContext.request.contextPath}/admin/dashboard"
                            class="font-black text-2xl uppercase tracking-widest flex items-center whitespace-nowrap mr-8">
                            Admin MochiGo
                        </a>
                        <div class="flex flex-wrap gap-2">
                            <c:set var="uri" value="${pageContext.request.requestURI}" />
                            <a href="${pageContext.request.contextPath}/admin/dashboard"
                                class="${uri.endsWith('/dashboard.jsp') || uri.endsWith('/admin/dashboard') ? 'bg-pink-900' : 'hover:bg-pink-700'} px-3 py-2 rounded-md font-medium text-sm transition-colors">Dashboard</a>
                            <a href="${pageContext.request.contextPath}/admin/products"
                                class="${uri.endsWith('/products.jsp') || uri.endsWith('/admin/products') ? 'bg-pink-900' : 'hover:bg-pink-700'} px-3 py-2 rounded-md font-medium text-sm transition-colors">Sản
                                phẩm</a>
                            <a href="${pageContext.request.contextPath}/admin/categories"
                                class="${uri.endsWith('/categories.jsp') || uri.endsWith('/admin/categories') ? 'bg-pink-900' : 'hover:bg-pink-700'} px-3 py-2 rounded-md font-medium text-sm transition-colors">Danh
                                mục</a>
                            <a href="${pageContext.request.contextPath}/admin/orders"
                                class="${uri.endsWith('/orders.jsp') || uri.endsWith('/admin/orders') ? 'bg-pink-900' : 'hover:bg-pink-700'} px-3 py-2 rounded-md font-medium text-sm transition-colors">Đơn
                                hàng</a>
                            <a href="${pageContext.request.contextPath}/admin/vouchers"
                                class="${uri.endsWith('/vouchers.jsp') || uri.endsWith('/admin/vouchers') ? 'bg-pink-900' : 'hover:bg-pink-700'} px-3 py-2 rounded-md font-medium text-sm transition-colors">Voucher</a>
                            <a href="${pageContext.request.contextPath}/admin/users"
                                class="${uri.endsWith('/users.jsp') || uri.endsWith('/admin/users') ? 'bg-pink-900' : 'hover:bg-pink-700'} px-3 py-2 rounded-md font-medium text-sm transition-colors">Người
                                dùng</a>
                            <a href="${pageContext.request.contextPath}/admin/reviews"
                                class="${uri.endsWith('/reviews.jsp') || uri.endsWith('/admin/reviews') ? 'bg-pink-900' : 'hover:bg-pink-700'} px-3 py-2 rounded-md font-medium text-sm transition-colors">Đánh
                                giá</a>
                        </div>
                    </div>
                </div>
                <div class="flex items-center space-x-4 ml-auto">

                    <!-- Notification Bell -->
                    <div class="relative">
                        <button onclick="showCuteNotification()"
                            class="text-pink-200 hover:text-white transition-colors relative block p-2 cursor-pointer focus:outline-none">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
                            </svg>
                            <span id="admin-notif-badge"
                                class="hidden absolute top-0 right-0 inline-flex items-center justify-center px-2 py-1 text-xs font-bold leading-none text-white transform translate-x-1/4 -translate-y-1/4 bg-red-600 rounded-full border-2 border-pink-800">
                                0
                            </span>
                        </button>
                    </div>

                    <span class="text-pink-200 ml-4 border-l border-pink-600 pl-4">Xin chào,
                        ${sessionScope.user.fullName}</span>
                    <a href="${pageContext.request.contextPath}/"
                        class="text-sm border border-pink-400 hover:bg-pink-700 px-3 py-1.5 rounded-md transition-colors">Về
                        trang khách</a>
                </div>
                </div>
            </div>
        </nav>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                window.pendingOrderCount = 0;
                window.unreadReviewCount = 0;
                window.latestOrderCustomer = "";
                window.latestReviewUser = "";
                
                var notifBadge = document.getElementById('admin-notif-badge');
                
                function fetchNotifs() {
                    fetch('${pageContext.request.contextPath}/admin/notifications')
                        .then(response => response.json())
                        .then(data => {
                            let oldTotal = window.pendingOrderCount + window.unreadReviewCount;
                            
                            window.pendingOrderCount = data.pendingOrders || 0;
                            window.unreadReviewCount = data.unreadReviews || 0;
                            window.latestOrderCustomer = data.latestOrderCustomer || "";
                            window.latestReviewUser = data.latestReviewUser || "";

                            let totalNotifs = window.pendingOrderCount + window.unreadReviewCount;

                            if (totalNotifs > 0) {
                                notifBadge.textContent = totalNotifs;
                                notifBadge.classList.remove('hidden');
                                
                                // Auto-show toast if there are MORE notifications than before
                                if (totalNotifs > oldTotal) {
                                    showCuteNotification(true);
                                }
                            } else {
                                notifBadge.classList.add('hidden');
                            }
                        })
                        .catch(error => console.log('Error fetching notifications:', error));
                }

                // Fetch initially
                fetchNotifs();
                // Fetch every 30 seconds
                setInterval(fetchNotifs, 30000);
            });

            function showCuteNotification(isAuto = false) {
                const toastBox = document.getElementById('cute-toast-box');
                const toastMsg = document.getElementById('cute-toast-msg');

                let messages = [];
                let actionLinks = "";

                if (window.pendingOrderCount > 0) {
                    let msg = "📦 Có <b>" + window.pendingOrderCount + "</b> đơn hàng mới!";
                    if (window.latestOrderCustomer) {
                        msg += " (Gần nhất: <i>" + window.latestOrderCustomer + "</i>)";
                    }
                    messages.push(msg);
                    actionLinks += '<a href="${pageContext.request.contextPath}/admin/orders" class="inline-block mt-2 bg-pink-600 text-white text-xs px-3 py-1 rounded-full hover:bg-pink-700 transition mr-2">Cập nhật vận chuyển 🚚</a>';
                }
                
                if (window.unreadReviewCount > 0) {
                    let msg = "⭐ Có <b>" + window.unreadReviewCount + "</b> đánh giá mới!";
                    if (window.latestReviewUser) {
                        msg += " (Từ: <i>" + window.latestReviewUser + "</i>)";
                    }
                    messages.push(msg);
                    actionLinks += '<a href="${pageContext.request.contextPath}/admin/reviews" class="inline-block mt-2 bg-blue-500 text-white text-xs px-3 py-1 rounded-full hover:bg-blue-600 transition">Xem đánh giá ⭐</a>';
                }

                if (messages.length > 0) {
                    let header = isAuto ? "<b>Thông báo mới đây!</b> 💌<br/>" : "Tinh tinh! 💌<br/>";
                    toastMsg.innerHTML = header + messages.join("<br/>") + "<br/>" + actionLinks;
                } else {
                    toastMsg.innerHTML = "Hihi, hiện tại không có thông báo mới nào! Admin tranh thủ nghỉ ngơi xíu đi ạ! ☕✨";
                }

                // Show toast
                toastBox.classList.remove('translate-y-full', 'opacity-0');
                toastBox.classList.add('translate-y-0', 'opacity-100');

                // Hide after 6 seconds if it's an auto-notification, otherwise keep original 4s
                let duration = isAuto ? 6000 : 4000;
                
                // Clear any existing timeout to prevent flickering
                if (window.toastTimeout) clearTimeout(window.toastTimeout);
                
                window.toastTimeout = setTimeout(() => {
                    toastBox.classList.remove('translate-y-0', 'opacity-100');
                    toastBox.classList.add('translate-y-full', 'opacity-0');
                }, duration);
            }
        </script>

        <!-- Cute Toast Notification Container -->
        <div id="cute-toast-box"
            class="fixed bottom-5 right-5 z-50 transform translate-y-full opacity-0 transition-all duration-500 ease-in-out">
            <div class="bg-white border-2 border-pink-300 rounded-2xl shadow-xl p-4 flex items-start max-w-sm">
                <div class="flex-shrink-0 bg-pink-100 p-2 rounded-full mr-3">
                    <span class="text-2xl">🧸</span>
                </div>
                <div>
                    <h4 class="text-pink-600 font-bold text-md mb-1">MochiGo Thông Báo!</h4>
                    <p id="cute-toast-msg" class="text-gray-600 text-sm leading-relaxed"></p>
                </div>
            </div>
        </div>