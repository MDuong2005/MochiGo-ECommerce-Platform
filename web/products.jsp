<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Sản phẩm - MochiGo</title>
                <script src="https://cdn.tailwindcss.com"></script>
            </head>

            <body class="flex flex-col min-h-screen bg-gray-50">

                <jsp:include page="/common/navbar.jsp" />

                <main
                    class="flex-grow max-w-7xl mx-auto py-8 px-4 sm:px-6 lg:px-8 w-full flex flex-col md:flex-row gap-8">

                    <!-- Sidebar: Categories -->
                    <aside class="w-full md:w-64 flex-shrink-0">
                        <div class="bg-white rounded-xl shadow-sm p-5 border border-gray-100">
                            <h3 class="text-lg font-bold text-gray-900 mb-4 border-b pb-2">Danh mục</h3>
                            <ul class="space-y-2">
                                <li>
                                    <a href="${pageContext.request.contextPath}/products"
                                        class="block w-full text-left px-3 py-2 rounded-lg transition-colors ${empty currentCategory ? 'bg-pink-100 text-pink-700 font-medium' : 'text-gray-600 hover:bg-gray-50 hover:text-pink-600'}">
                                        🍩 Tất cả sản phẩm
                                    </a>
                                </li>
                                <c:forEach var="cat" items="${categories}">
                                    <li>
                                        <a href="${pageContext.request.contextPath}/products?categoryId=${cat.categoryId}"
                                            class="block w-full text-left px-3 py-2 rounded-lg transition-colors ${currentCategory == cat.categoryId ? 'bg-pink-100 text-pink-700 font-medium' : 'text-gray-600 hover:bg-gray-50 hover:text-pink-600'}">
                                            🍬 ${cat.name}
                                        </a>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </aside>

                    <!-- Product Grid -->
                    <div class="flex-grow">
                        <c:choose>
                            <c:when test="${isSalePage}">
                                <h2 class="text-2xl font-bold text-red-600 mb-6 flex items-center">Siêu Sale Ưu Đãi 🔥
                                </h2>
                            </c:when>
                            <c:otherwise>
                                <h2 class="text-2xl font-bold text-gray-900 mb-6">Danh sách sản phẩm</h2>
                            </c:otherwise>
                        </c:choose>

                        <c:if test="${empty products}">
                            <div class="text-center py-12 bg-white rounded-xl shadow-sm border border-gray-100">
                                <p class="text-gray-500 text-lg">Không tìm thấy sản phẩm nào.</p>
                            </div>
                        </c:if>

                        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                            <c:forEach var="p" items="${products}">
                                <div
                                    class="bg-white rounded-xl shadow-sm overflow-hidden hover:shadow-lg transition-shadow border border-gray-100 flex flex-col group relative">
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
                                            class="w-full h-48 object-cover object-center group-hover:scale-105 transition-transform duration-300">
                                    </a>
                                    <div class="p-4 flex-grow flex flex-col">

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

                                        <h3 class="text-md font-semibold text-gray-800 mb-1 truncate">
                                            <a href="${pageContext.request.contextPath}/products?action=detail&id=${p.productId}"
                                                class="hover:text-pink-600">${p.name}</a>
                                        </h3>
                                        <p class="text-sm text-gray-500 mb-2 truncate">${p.description}</p>
                                        <div
                                            class="flex items-center justify-between mt-auto pb-2 border-b border-gray-100">
                                            <div class="flex flex-col">
                                                <c:if test="${p.discountPercent > 0}">
                                                    <span class="text-xs text-gray-400 line-through">
                                                        <fmt:formatNumber value="${p.price}" type="number"
                                                            maxFractionDigits="0" /> đ
                                                    </span>
                                                </c:if>
                                                <span class="text-lg font-bold text-pink-600">
                                                    <fmt:formatNumber
                                                        value="${p.discountPercent > 0 ? p.discountedPrice : p.price}"
                                                        type="number" maxFractionDigits="0" /> đ
                                                </span>
                                            </div>
                                        </div>
                                        <form action="${pageContext.request.contextPath}/cart" method="post"
                                            class="mt-3">
                                            <input type="hidden" name="action" value="add">
                                            <input type="hidden" name="productId" value="${p.productId}">
                                            <input type="hidden" name="quantity" value="1">
                                            <button type="submit"
                                                class="w-full flex justify-center py-2 px-4 border border-transparent rounded-lg text-sm font-medium text-white bg-pink-500 hover:bg-pink-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-pink-500 transition-colors">
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