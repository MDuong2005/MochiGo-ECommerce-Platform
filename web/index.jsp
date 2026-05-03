<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>MochiGo - Cửa Hàng Bánh Kẹo</title>
                <script src="https://cdn.tailwindcss.com"></script>
                <style>
                    .hero-pattern {
                        background-color: #ffeff3;
                        background-image: radial-gradient(#ffa6c9 1px, transparent 1px);
                        background-size: 20px 20px;
                    }
                </style>
            </head>

            <body class="flex flex-col min-h-screen bg-gray-50">

                <jsp:include page="/common/navbar.jsp" />

                <main class="flex-grow">
                    <!-- Hero Section -->
                    <div class="relative hero-pattern py-20 px-4 sm:px-6 lg:px-8 text-center overflow-hidden">
                        <h1 class="text-4xl md:text-5xl font-extrabold text-pink-700 tracking-tight mb-4">
                            Thiên Đường Bánh Kẹo MochiGo 🍬
                        </h1>
                        <p class="text-xl text-pink-800 max-w-2xl mx-auto mb-8">
                            Nơi hội tụ những viên Mochi mềm mại nhất và các loại bánh kẹo ngọt ngào trên toàn thế giới!
                        </p>
                        <a href="${pageContext.request.contextPath}/products"
                            class="inline-flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-full text-white bg-pink-600 hover:bg-pink-700 shadow-lg transform transition hover:-translate-y-1">
                            Khám phá ngay
                        </a>
                    </div>

                    <!-- Featured Products -->
                    <div class="max-w-7xl mx-auto py-16 px-4 sm:px-6 lg:px-8">
                        <h2 class="text-3xl font-bold text-gray-900 mb-8 text-center">Sản phẩm nổi bật</h2>

                        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-8">
                            <c:forEach var="p" items="${featuredProducts}">
                                <div
                                    class="bg-white rounded-2xl shadow-md overflow-hidden hover:shadow-xl transition flex flex-col group relative">
                                    <a href="${pageContext.request.contextPath}/products?action=detail&id=${p.productId}"
                                        class="block overflow-hidden relative">

                                        <!-- Badge Khuyến mãi -->
                                        <c:if test="${p.discountPercent > 0}">
                                            <div
                                                class="absolute top-2 left-2 z-10 bg-red-500 text-white text-xs font-bold px-2 py-1 rounded shadow-sm">
                                                -${p.discountPercent}%
                                            </div>
                                        </c:if>

                                        <!-- Tâm tim yêu thích -->
                                        <div class="absolute top-2 right-2 z-10 transition-transform hover:scale-110">
                                            <c:choose>
                                                <c:when
                                                    test="${not empty sessionScope.user and likedIds.contains(p.productId)}">
                                                    <a href="${pageContext.request.contextPath}/wishlist?action=remove&id=${p.productId}"
                                                        class="bg-white/90 backdrop-blur rounded-full p-2 shadow-sm text-pink-500 hover:text-red-600 flex items-center justify-center">
                                                        <svg class="w-5 h-5 fill-current" viewBox="0 0 24 24">
                                                            <path
                                                                d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z" />
                                                        </svg>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${empty sessionScope.user ? pageContext.request.contextPath.concat('/login.jsp') : pageContext.request.contextPath.concat('/wishlist?action=add&id=').concat(p.productId)}"
                                                        class="bg-white/90 backdrop-blur rounded-full p-2 shadow-sm text-gray-400 hover:text-pink-500 flex items-center justify-center transition-colors">
                                                        <svg class="w-5 h-5" fill="none" stroke="currentColor"
                                                            stroke-width="2" viewBox="0 0 24 24">
                                                            <path stroke-linecap="round" stroke-linejoin="round"
                                                                d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
                                                        </svg>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <img src="${pageContext.request.contextPath}/${p.imageUrl}" alt="${p.name}"
                                            class="w-full h-56 object-cover object-center group-hover:scale-105 transition-transform duration-300">
                                    </a>
                                    <div class="p-5 flex-grow flex flex-col">

                                        <!-- Danh Mục -->
                                        <c:set var="catName" value="Khác" />
                                        <c:forEach var="c" items="${categories}">
                                            <c:if test="${c.categoryId == p.categoryId}">
                                                <c:set var="catName" value="${c.name}" />
                                            </c:if>
                                        </c:forEach>
                                        <span
                                            class="text-xs font-semibold text-pink-500 bg-pink-100 px-2 py-1 rounded w-max mb-2 border border-pink-200">
                                            ${catName}
                                        </span>

                                        <h3 class="text-lg font-bold text-gray-900 mb-2 truncate">
                                            <a href="${pageContext.request.contextPath}/products?action=detail&id=${p.productId}"
                                                class="hover:text-pink-600">${p.name}</a>
                                        </h3>
                                        <div class="flex items-center justify-between mt-auto">
                                            <div class="flex flex-col">
                                                <c:if test="${p.discountPercent > 0}">
                                                    <span class="text-xs text-gray-400 line-through">
                                                        <fmt:formatNumber value="${p.price}" type="number"
                                                            groupingUsed="true" maxFractionDigits="0" /> đ
                                                    </span>
                                                </c:if>
                                                <span class="text-xl font-bold text-pink-600">
                                                    <fmt:formatNumber
                                                        value="${p.discountPercent > 0 ? p.discountedPrice : p.price}"
                                                        type="number" groupingUsed="true" maxFractionDigits="0" /> đ
                                                </span>
                                            </div>
                                        </div>
                                        <form action="${pageContext.request.contextPath}/cart" method="post"
                                            class="mt-4">
                                            <input type="hidden" name="action" value="add">
                                            <input type="hidden" name="productId" value="${p.productId}">
                                            <input type="hidden" name="quantity" value="1">
                                            <button type="submit"
                                                class="w-full flex items-center justify-center px-4 py-2 border border-transparent rounded-lg text-sm font-medium text-pink-600 bg-pink-50 hover:bg-pink-100 transition">
                                                <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor"
                                                    viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                        stroke-width="2"
                                                        d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
                                                </svg>
                                                Thêm vào giỏ
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </main>

                <jsp:include page="/common/footer.jsp" />

            </body>

            </html>