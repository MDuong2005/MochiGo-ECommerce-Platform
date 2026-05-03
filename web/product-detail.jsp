<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>${product.name} - MochiGo</title>
                <script src="https://cdn.tailwindcss.com"></script>
            </head>

            <body class="flex flex-col min-h-screen bg-gray-50">

                <jsp:include page="/common/navbar.jsp" />

                <main class="flex-grow max-w-7xl mx-auto py-12 px-4 sm:px-6 lg:px-8 w-full">

                    <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
                        <div class="md:flex">
                            <!-- Product Image -->
                            <div class="md:w-1/2 flex items-center justify-center p-8 bg-pink-50/50">
                                <div class="relative group cursor-zoom-in overflow-hidden rounded-xl shadow-md" onclick="openLightbox()">
                                    <img src="${pageContext.request.contextPath}/${product.imageUrl}" alt="${product.name}"
                                        id="mainProductImage"
                                        class="max-w-full h-auto object-cover transition-transform duration-500 group-hover:scale-110">
                                    <div class="absolute inset-0 bg-black/0 group-hover:bg-black/10 transition-colors flex items-center justify-center">
                                        <svg class="w-12 h-12 text-white opacity-0 group-hover:opacity-100 transition-opacity" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0zM10 7v3m0 0v3m0-3h3m-3 0H7" />
                                        </svg>
                                    </div>
                                </div>
                            </div>

                            <!-- Product Info -->
                            <div class="p-8 md:w-1/2 flex flex-col justify-center">
                                <div class="mb-6 border-b border-gray-100 pb-6">
                                    <h1
                                        class="text-3xl font-extrabold text-gray-900 tracking-tight mb-2 flex items-center gap-3">
                                        ${product.name}
                                        <c:if test="${product.discountPercent > 0}">
                                            <span
                                                class="bg-red-500 text-white text-base font-bold px-3 py-1 rounded shadow-sm">-${product.discountPercent}%</span>
                                        </c:if>
                                    </h1>
                                    <div class="flex items-center mb-2">
                                        <c:choose>
                                            <c:when test="${totalReviews > 0}">
                                                <div class="flex">
                                                    <c:forEach var="i" begin="1" end="5">
                                                        <svg class="w-5 h-5 ${i <= avgRating ? 'text-yellow-400' : 'text-gray-300'}"
                                                            fill="currentColor" viewBox="0 0 20 20">
                                                            <path
                                                                d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z">
                                                            </path>
                                                        </svg>
                                                    </c:forEach>
                                                </div>
                                                <span class="ml-2 text-sm text-gray-500">
                                                    <fmt:formatNumber value="${avgRating}" maxFractionDigits="1" />/5
                                                    (${totalReviews} đánh giá)
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-sm text-gray-500">Chưa có đánh giá</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="mb-4 flex flex-col">
                                        <c:if test="${product.discountPercent > 0}">
                                            <span class="text-gray-400 line-through text-lg">
                                                <fmt:formatNumber value="${product.price}" type="number"
                                                    groupingUsed="true" maxFractionDigits="0" /> đ
                                            </span>
                                        </c:if>
                                        <p class="text-3xl text-pink-600 font-bold">
                                            <fmt:formatNumber
                                                value="${product.discountPercent > 0 ? product.discountedPrice : product.price}"
                                                type="number" groupingUsed="true" maxFractionDigits="0" /> đ
                                        </p>
                                    </div>
                                    <p class="text-gray-600 leading-relaxed text-lg">
                                        ${product.description}
                                    </p>
                                </div>

                                <div class="mb-8">
                                    <div class="flex items-center text-sm font-medium text-gray-500 mb-2">
                                        <span class="mr-2">Tình trạng:</span>
                                        <c:choose>
                                            <c:when test="${product.stock > 0}">
                                                <span
                                                    class="bg-green-100 text-green-800 px-2 py-0.5 rounded-full text-xs font-semibold uppercase tracking-wide">Còn
                                                    hàng (${product.stock})</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span
                                                    class="bg-red-100 text-red-800 px-2 py-0.5 rounded-full text-xs font-semibold uppercase tracking-wide">Hết
                                                    hàng</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- Add to cart form -->
                                <form action="${pageContext.request.contextPath}/cart" method="post" class="mt-auto">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="productId" value="${product.productId}">

                                    <div class="flex items-center mb-6">
                                        <label for="quantity" class="block text-sm font-medium text-gray-700 mr-4">Số
                                            lượng:</label>
                                        <input type="number" id="quantity" name="quantity" min="1"
                                            max="${product.stock > 0 ? product.stock : 1}" value="1"
                                            class="shadow-sm focus:ring-pink-500 focus:border-pink-500 block w-24 sm:text-sm border-gray-300 rounded-md border py-2 px-3 text-center"
                                            ${product.stock <=0 ? 'disabled' : '' }>
                                    </div>

                                    <button type="submit"
                                        class="w-full bg-pink-600 border border-transparent rounded-xl py-4 px-8 flex items-center justify-center text-lg font-bold text-white hover:bg-pink-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-pink-500 transition-colors shadow-lg ${product.stock <= 0 ? 'opacity-50 cursor-not-allowed' : ''}"
                                        ${product.stock <=0 ? 'disabled' : '' }>
                                        <svg class="h-6 w-6 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
                                        </svg>
                                        Thêm vào giỏ hàng
                                    </button>
                                    <c:if test="${not empty sessionScope.errorMsg}">
                                        <p class="mt-4 text-center text-red-600 font-medium">${sessionScope.errorMsg}
                                        </p>
                                        <c:remove var="errorMsg" scope="session" />
                                    </c:if>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Reviews Section -->
                    <div class="mt-8 bg-white rounded-2xl shadow-sm border border-gray-100 p-8 mb-8">
                        <h2 class="text-2xl font-bold text-gray-900 mb-6 border-b pb-4">Đánh giá sản phẩm</h2>
                        <c:choose>
                            <c:when test="${empty reviews}">
                                <p class="text-gray-500 italic">Sản phẩm này chưa có bài đánh giá nào.</p>
                            </c:when>
                            <c:otherwise>
                                <div class="space-y-6">
                                    <c:forEach var="r" items="${reviews}">
                                        <div class="border-b border-gray-100 pb-6 last:border-0 last:pb-0">
                                            <div class="flex items-center justify-between mb-2">
                                                <h4 class="text-lg font-bold text-gray-900">${r.userName}</h4>
                                                <span class="text-sm text-gray-500">
                                                    <fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                </span>
                                            </div>
                                            <div class="flex mb-2">
                                                <c:forEach var="i" begin="1" end="5">
                                                    <svg class="w-4 h-4 ${i <= r.rating ? 'text-yellow-400' : 'text-gray-300'}"
                                                        fill="currentColor" viewBox="0 0 20 20">
                                                        <path
                                                            d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z">
                                                        </path>
                                                    </svg>
                                                </c:forEach>
                                            </div>
                                            <p class="text-gray-700 leading-relaxed">${empty r.comment ? 'Không có bình
                                                luận' : r.comment}</p>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                </main>

                <jsp:include page="/common/footer.jsp" />

                <!-- Lightbox Modal -->
                <div id="lightbox" class="fixed inset-0 z-[100] hidden flex items-center justify-center bg-black/90 backdrop-blur-sm p-4 md:p-10 transition-all duration-300 opacity-0">
                    <button onclick="closeLightbox()" class="absolute top-6 right-6 text-white hover:text-pink-400 transition-colors z-[110]">
                        <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                    
                    <div class="max-w-5xl max-h-full overflow-hidden flex items-center justify-center" onclick="event.stopPropagation()">
                        <img id="lightboxImage" src="${pageContext.request.contextPath}/${product.imageUrl}" 
                             class="max-w-full max-h-[90vh] object-contain rounded-lg shadow-2xl scale-95 transition-transform duration-300" 
                             alt="${product.name}">
                    </div>
                </div>

                <style>
                    .cursor-zoom-in { cursor: zoom-in; }
                    #lightbox.active { opacity: 1; }
                    #lightbox.active #lightboxImage { scale: 1; }
                </style>

                <script>
                    function openLightbox() {
                        const lightbox = document.getElementById('lightbox');
                        const img = document.getElementById('lightboxImage');
                        lightbox.classList.remove('hidden');
                        setTimeout(() => {
                            lightbox.classList.add('flex');
                            lightbox.classList.add('active');
                            document.body.style.overflow = 'hidden';
                        }, 10);
                    }

                    function closeLightbox() {
                        const lightbox = document.getElementById('lightbox');
                        lightbox.classList.remove('active');
                        setTimeout(() => {
                            lightbox.classList.add('hidden');
                            lightbox.classList.remove('flex');
                            document.body.style.overflow = '';
                        }, 300);
                    }

                    // Close on click backdrop
                    document.getElementById('lightbox').addEventListener('click', closeLightbox);
                    
                    // Close on Escape key
                    document.addEventListener('keydown', function(event) {
                        if (event.key === "Escape") {
                            closeLightbox();
                        }
                    });
                </script>
            </body>

            </html>