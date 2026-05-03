<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Sản phẩm yêu thích - MochiGo</title>
                <script src="https://cdn.tailwindcss.com"></script>
            </head>

            <body class="flex flex-col min-h-screen bg-gray-50">

                <jsp:include page="/common/navbar.jsp" />

                <main class="flex-grow max-w-7xl mx-auto py-8 px-4 sm:px-6 lg:px-8 w-full">
                    <h2 class="text-3xl font-extrabold text-gray-900 mb-8 flex items-center">
                        <svg class="w-8 h-8 text-pink-500 mr-3" fill="currentColor" viewBox="0 0 24 24">
                            <path
                                d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z" />
                        </svg>
                        Sản phẩm yêu thích của bạn
                    </h2>

                    <c:if test="${empty wishlist}">
                        <div class="text-center py-16 bg-white rounded-2xl shadow-sm border border-gray-100">
                            <p class="text-gray-500 text-xl font-medium mb-6">Bạn chưa có sản phẩm yêu thích nào.</p>
                            <a href="${pageContext.request.contextPath}/products"
                                class="inline-flex items-center justify-center px-6 py-3 border border-transparent text-base font-medium rounded-xl text-white bg-pink-600 hover:bg-pink-700 shadow-md">
                                Khám phá bánh trái ngay 🍩
                            </a>
                        </div>
                    </c:if>

                    <c:if test="${not empty wishlist}">
                        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                            <c:forEach var="p" items="${wishlist}">
                                <div
                                    class="bg-white rounded-xl shadow-sm overflow-hidden hover:shadow-lg transition-shadow border border-gray-100 flex flex-col group relative">
                                    <a href="${pageContext.request.contextPath}/products?action=detail&id=${p.productId}"
                                        class="block overflow-hidden relative">

                                        <div class="absolute top-2 right-2 z-10 transition-transform hover:scale-110">
                                            <a href="${pageContext.request.contextPath}/wishlist?action=remove&id=${p.productId}"
                                                class="bg-white/90 backdrop-blur rounded-full p-2 shadow-sm text-pink-500 hover:text-red-600 flex items-center justify-center">
                                                <svg class="w-5 h-5 fill-current" viewBox="0 0 24 24">
                                                    <path
                                                        d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z" />
                                                </svg>
                                            </a>
                                        </div>

                                        <img src="${pageContext.request.contextPath}/${p.imageUrl}" alt="${p.name}"
                                            class="w-full h-48 object-cover object-center group-hover:scale-105 transition-transform duration-300">
                                    </a>
                                    <div class="p-4 flex-grow flex flex-col">
                                        <h3 class="text-md font-semibold text-gray-800 mb-1 truncate">
                                            <a href="${pageContext.request.contextPath}/products?action=detail&id=${p.productId}"
                                                class="hover:text-pink-600">${p.name}</a>
                                        </h3>
                                        <p class="text-sm text-gray-500 mb-2 truncate">${p.description}</p>
                                        <div
                                            class="flex items-center justify-between mt-auto pb-2 border-b border-gray-100">
                                            <span class="text-lg font-bold text-pink-600">
                                                <fmt:formatNumber value="${p.price}" type="number"
                                                    maxFractionDigits="0" /> đ
                                            </span>
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
                    </c:if>
                </main>

                <jsp:include page="/common/footer.jsp" />

            </body>

            </html>