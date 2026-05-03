<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <header class="bg-pink-100 shadow-md sticky top-0 z-50">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-16">
                    <div class="flex items-center">
                        <a href="${pageContext.request.contextPath}/home" class="flex-shrink-0 flex items-center">
                            <span class="text-2xl font-bold text-pink-600">MochiGo🍡</span>
                        </a>
                        <nav class="hidden md:ml-6 md:flex md:space-x-8">
                            <a href="${pageContext.request.contextPath}/home"
                                class="text-gray-700 hover:text-pink-600 px-3 py-2 rounded-md text-sm font-medium">Trang
                                chủ</a>
                            <a href="${pageContext.request.contextPath}/products"
                                class="text-gray-700 hover:text-pink-600 px-3 py-2 rounded-md text-sm font-medium">Sản
                                phẩm</a>
                            <a href="${pageContext.request.contextPath}/products?action=sale"
                                class="text-red-500 hover:text-red-700 px-3 py-2 rounded-md text-sm font-bold flex items-center">
                                Khuyến mãi <span class="animate-bounce ml-1">🔥</span>
                            </a>
                        </nav>
                    </div>
                    <div class="flex items-center space-x-4">
                        <form action="${pageContext.request.contextPath}/products" method="get"
                            class="hidden md:flex relative group search-form">
                            <input type="text" name="search" id="searchInput" placeholder="Tìm kiếm bánh kẹo..."
                                autocomplete="off"
                                class="pl-10 pr-4 py-2 border rounded-full focus:outline-none focus:ring-2 focus:ring-pink-400 w-64 transition-all focus:w-80">
                            <div class="absolute left-3 top-2.5 text-gray-400">
                                <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M21 21l-4.35-4.35m1.5-5.15a7.5 7.5 0 11-15 0 7.5 7.5 0 0115 0z" />
                                </svg>
                            </div>

                            <!-- Search Suggestions Dropdown -->
                            <div id="searchSuggestions"
                                class="absolute top-full left-0 right-0 mt-2 bg-white border border-gray-100 rounded-xl shadow-xl z-50 hidden overflow-hidden">
                                <ul id="suggestionsList" class="max-h-80 overflow-y-auto divide-y divide-gray-50">
                                </ul>
                                <div id="searchLoading" class="p-4 text-center text-sm text-gray-500 hidden">
                                    Đang tìm...
                                </div>
                                <div id="noResults" class="p-4 text-center text-sm text-gray-500 hidden">
                                    Không tìm thấy sản phẩm
                                </div>
                            </div>
                        </form>
                        <a href="${pageContext.request.contextPath}/cart"
                            class="text-gray-700 hover:text-pink-600 relative">
                            <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
                            </svg>
                            <c:if test="${not empty sessionScope.cart}">
                                <span
                                    class="absolute -top-2 -right-2 bg-red-500 text-white rounded-full h-5 w-5 flex items-center justify-center text-xs">
                                    ${sessionScope.cart.size()}
                                </span>
                            </c:if>
                        </a>

                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <div class="relative group">
                                    <button
                                        class="flex items-center text-gray-700 hover:text-pink-600 focus:outline-none">
                                        <span class="mr-1">${sessionScope.user.fullName}</span>
                                        <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                d="M19 9l-7 7-7-7" />
                                        </svg>
                                    </button>
                                    <div class="absolute right-0 pt-2 w-48 z-50 hidden group-hover:block">
                                        <div class="bg-white rounded-md shadow-lg py-1 border">
                                            <a href="${pageContext.request.contextPath}/wishlist"
                                                class="flex items-center px-4 py-2 text-sm text-pink-600 font-medium hover:bg-pink-50">
                                                <svg class="h-4 w-4 mr-2 fill-current" viewBox="0 0 24 24">
                                                    <path
                                                        d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z" />
                                                </svg>
                                                Yêu thích
                                            </a>
                                            <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                                <a href="${pageContext.request.contextPath}/admin/dashboard"
                                                    class="block px-4 py-2 text-sm text-gray-700 hover:bg-pink-50">Quản
                                                    trị
                                                    Admin</a>
                                            </c:if>
                                            <a href="${pageContext.request.contextPath}/history"
                                                class="block px-4 py-2 text-sm text-gray-700 hover:bg-pink-50">Lịch sử
                                                đơn
                                                hàng</a>
                                            <a href="${pageContext.request.contextPath}/auth?action=logout"
                                                class="block px-4 py-2 text-sm text-red-600 hover:bg-pink-50">Đăng
                                                xuất</a>
                                        </div>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/login.jsp"
                                    class="text-pink-600 font-medium hover:text-pink-800">Đăng nhập</a>
                                <a href="${pageContext.request.contextPath}/register.jsp"
                                    class="bg-pink-600 text-white px-4 py-2 rounded-md text-sm font-medium hover:bg-pink-700">Đăng
                                    ký</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </header>

        <c:if test="${not empty sessionScope.successMsg}">
            <div id="toast-success"
                class="fixed bottom-5 right-5 z-50 flex items-center w-full max-w-xs p-4 text-gray-700 bg-white rounded-xl shadow-lg border-l-4 border-green-500 transition-all duration-500"
                role="alert">
                <div
                    class="inline-flex items-center justify-center flex-shrink-0 w-8 h-8 text-green-500 bg-green-100 rounded-lg">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                    </svg>
                </div>
                <div class="ml-3 text-sm font-bold">${sessionScope.successMsg}</div>
                <button type="button"
                    class="ml-auto -mx-1.5 -my-1.5 bg-white text-gray-400 hover:text-gray-900 rounded-lg focus:ring-2 focus:ring-gray-300 p-1.5 hover:bg-gray-100 inline-flex items-center justify-center h-8 w-8"
                    onclick="document.getElementById('toast-success').style.display='none'">
                    <span class="sr-only">Close</span>
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12">
                        </path>
                    </svg>
                </button>
            </div>
            <script>
                setTimeout(() => {
                    const toast = document.getElementById('toast-success');
                    if (toast) {
                        toast.style.opacity = '0';
                        toast.style.transform = 'translateY(10px)';
                        setTimeout(() => toast.remove(), 500);
                    }
                }, 3000);
            </script>
            <c:remove var="successMsg" scope="session" />
        </c:if>

        <!-- Script Search Suggestions -->
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const searchInput = document.getElementById('searchInput');
                const searchSuggestions = document.getElementById('searchSuggestions');
                const suggestionsList = document.getElementById('suggestionsList');
                const searchLoading = document.getElementById('searchLoading');
                const noResults = document.getElementById('noResults');

                let timeoutId;

                // Format currency
                const formatter = new Intl.NumberFormat('vi-VN');

                searchInput.addEventListener('input', function () {
                    clearTimeout(timeoutId);
                    const query = this.value.trim();

                    if (query.length < 2) {
                        searchSuggestions.classList.add('hidden');
                        return;
                    }

                    timeoutId = setTimeout(() => {
                        searchSuggestions.classList.remove('hidden');
                        suggestionsList.innerHTML = '';
                        searchLoading.classList.remove('hidden');
                        noResults.classList.add('hidden');

                        fetch('${pageContext.request.contextPath}/api/search-suggest?q=' + encodeURIComponent(query))
                            .then(response => response.json())
                            .then(data => {
                                searchLoading.classList.add('hidden');

                                if (data.length === 0) {
                                    noResults.classList.remove('hidden');
                                    return;
                                }

                                let html = '';
                                data.forEach(p => {
                                    html += `
                                        <li>
                                            <a href="${pageContext.request.contextPath}/products?action=detail&id=` + p.id + `" class="flex items-center p-3 hover:bg-pink-50 transition-colors">
                                                <img src="${pageContext.request.contextPath}/` + p.image + `" alt="` + p.name + `" class="w-10 h-10 object-cover rounded-md border border-gray-100 flex-shrink-0">
                                                <div class="ml-3 flex-grow overflow-hidden">
                                                    <div class="text-sm font-medium text-gray-900 truncate">` + p.name + `</div>
                                                    <div class="text-xs font-bold text-pink-600 mt-0.5">` + formatter.format(p.price) + ` đ</div>
                                                </div>
                                            </a>
                                        </li>
                                    `;
                                });

                                suggestionsList.innerHTML = html;
                            })
                            .catch(error => {
                                console.error('Error fetching suggestions:', error);
                                searchLoading.classList.add('hidden');
                            });
                    }, 300); // 300ms debounce
                });

                // Hide suggestions when clicking outside
                document.addEventListener('click', function (e) {
                    if (!searchInput.contains(e.target) && !searchSuggestions.contains(e.target)) {
                        searchSuggestions.classList.add('hidden');
                    }
                });

                // Show again when clicking input if there's text
                searchInput.addEventListener('focus', function () {
                    if (this.value.trim().length >= 2) {
                        searchSuggestions.classList.remove('hidden');
                    }
                });
            });
        </script>