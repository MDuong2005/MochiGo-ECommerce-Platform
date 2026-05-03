<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>${product == null ? 'Thêm mới' : 'Sửa'} Sản phẩm - Admin MochiGo</title>
            <script src="https://cdn.tailwindcss.com"></script>
        </head>

        <body class="bg-gray-100 min-h-screen flex flex-col">

            <jsp:include page="/admin/admin-nav.jsp" />

            <div class="max-w-3xl mx-auto py-10 px-4 sm:px-6 lg:px-8 w-full flex-grow">

                <div class="mb-8 flex items-center">
                    <a href="${pageContext.request.contextPath}/admin/products"
                        class="text-gray-500 hover:text-pink-600 mr-4 font-bold flex items-center">
                        <svg class="h-5 w-5 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
                        </svg>
                        Quay lại
                    </a>
                    <h1 class="text-3xl font-extrabold text-gray-900">${product == null ? 'Thêm Sản Phẩm Mới' : 'Sửa Sản
                        Phẩm'} 🍡</h1>
                </div>

                <div class="bg-white shadow-md rounded-2xl p-8 border border-gray-200">
                    <form action="${pageContext.request.contextPath}/admin/products" method="post" 
                          enctype="multipart/form-data" class="space-y-6">
                        <input type="hidden" name="action" value="${product == null ? 'insert' : 'update'}">

                        <c:if test="${product != null}">
                            <input type="hidden" name="productId" value="${product.productId}">
                        </c:if>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <!-- Danh mục -->
                            <div>
                                <label class="block text-sm font-bold text-gray-700 mb-2">Danh mục <span
                                        class="text-red-500">*</span></label>
                                <select name="categoryId"
                                    class="block w-full rounded-lg border-gray-300 shadow-sm focus:border-pink-500 focus:ring-pink-500 sm:text-sm py-2 px-3 border"
                                    required>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.categoryId}" ${product !=null &&
                                            product.categoryId==cat.categoryId ? 'selected' : '' }>
                                            ${cat.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Tên sản phẩm -->
                            <div>
                                <label class="block text-sm font-bold text-gray-700 mb-2">Tên sản phẩm <span
                                        class="text-red-500">*</span></label>
                                <input type="text" name="name" value="${product != null ? product.name : ''}"
                                    class="block w-full rounded-lg border-gray-300 shadow-sm focus:border-pink-500 focus:ring-pink-500 sm:text-sm py-2 px-3 border"
                                    required>
                            </div>

                            <!-- Giá bán -->
                            <div>
                                <label class="block text-sm font-bold text-gray-700 mb-2">Giá bán (VNĐ) <span
                                        class="text-red-500">*</span></label>
                                <input type="number" name="price" value="${product != null ? product.price : '0'}"
                                    step="0.01"
                                    class="block w-full rounded-lg border-gray-300 shadow-sm focus:border-pink-500 focus:ring-pink-500 sm:text-sm py-2 px-3 border"
                                    required>
                            </div>

                            <!-- Tồn kho -->
                            <div>
                                <label class="block text-sm font-bold text-gray-700 mb-2">Tồn kho <span
                                        class="text-red-500">*</span></label>
                                <input type="number" name="stock" value="${product != null ? product.stock : '0'}"
                                    class="block w-full rounded-lg border-gray-300 shadow-sm focus:border-pink-500 focus:ring-pink-500 sm:text-sm py-2 px-3 border"
                                    required>
                            </div>

                            <!-- % Khuyến mãi -->
                            <div>
                                <label class="block text-sm font-bold text-gray-700 mb-2">Khuyến mãi (%)</label>
                                <input type="number" name="discountPercent"
                                    value="${product != null ? product.discountPercent : '0'}" min="0" max="100"
                                    class="block w-full rounded-lg border-gray-300 shadow-sm focus:border-pink-500 focus:ring-pink-500 sm:text-sm py-2 px-3 border">
                            </div>

                            <!-- Hình ảnh -->
                            <div class="md:col-span-2 space-y-4">
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 items-start">
                                    <div class="space-y-4">
                                        <div>
                                            <label class="block text-sm font-bold text-gray-700 mb-2">Tải ảnh từ máy tính</label>
                                            <input type="file" name="imageFile" id="imageFile" accept="image/*"
                                                class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-pink-50 file:text-pink-700 hover:file:bg-pink-100 border rounded-lg p-1"
                                                onchange="previewImage(this)">
                                        </div>
                                        
                                        <div class="relative">
                                            <div class="absolute inset-0 flex items-center" aria-hidden="true">
                                                <div class="w-full border-t border-gray-300"></div>
                                            </div>
                                            <div class="relative flex justify-center text-sm">
                                                <span class="px-2 bg-white text-gray-500 uppercase tracking-wider font-bold text-xs text-gray-400">Hoặc dùng URL</span>
                                            </div>
                                        </div>
        
                                        <div>
                                            <label class="block text-sm font-bold text-gray-700 mb-2">URL Hình ảnh</label>
                                            <input type="text" name="imageUrl" id="imageUrl" value="${product != null ? product.imageUrl : ''}"
                                                class="block w-full rounded-lg border-gray-300 shadow-sm focus:border-pink-500 focus:ring-pink-500 sm:text-sm py-2 px-3 border"
                                                placeholder="VD: images/mochi-dau.jpg">
                                            <p class="mt-2 text-sm text-gray-500">Nếu bạn tải tệp lên ở trên, đường dẫn tệp đó sẽ được tự động cập nhật.</p>
                                        </div>
                                    </div>

                                    <div class="flex flex-col items-center justify-center border-2 border-dashed border-gray-300 rounded-2xl p-4 min-h-[200px] bg-gray-50">
                                        <p class="text-xs font-bold text-gray-400 uppercase mb-3">Xem trước hình ảnh</p>
                                        <div id="imagePreviewContainer" class="w-full flex justify-center">
                                            <c:choose>
                                                <c:when test="${not empty product.imageUrl}">
                                                    <img id="imagePreview" src="${pageContext.request.contextPath}/${product.imageUrl}" 
                                                         class="max-h-48 rounded-lg shadow-sm object-cover border border-white" 
                                                         alt="Preview">
                                                </c:when>
                                                <c:otherwise>
                                                    <div id="no-image-text" class="text-center py-10">
                                                        <svg class="mx-auto h-12 w-12 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                                        </svg>
                                                        <span class="mt-2 block text-sm font-medium text-gray-400">Chưa có ảnh</span>
                                                    </div>
                                                    <img id="imagePreview" src="#" class="hidden max-h-48 rounded-lg shadow-sm object-cover border border-white" alt="Preview">
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <script>
                                function previewImage(input) {
                                    const preview = document.getElementById('imagePreview');
                                    const noImageText = document.getElementById('no-image-text');
                                    
                                    if (input.files && input.files[0]) {
                                        const reader = new FileReader();
                                        
                                        reader.onload = function(e) {
                                            preview.src = e.target.result;
                                            preview.classList.remove('hidden');
                                            if (noImageText) noImageText.classList.add('hidden');
                                        }
                                        
                                        reader.readAsDataURL(input.files[0]);
                                    }
                                }
                            </script>

                            <!-- Mô tả -->
                            <div class="md:col-span-2">
                                <label class="block text-sm font-bold text-gray-700 mb-2">Mô tả sản phẩm</label>
                                <textarea name="description" rows="4"
                                    class="block w-full rounded-lg border-gray-300 shadow-sm focus:border-pink-500 focus:ring-pink-500 sm:text-sm py-2 px-3 border">${product != null ? product.description : ''}</textarea>
                            </div>

                            <!-- Trạng thái -->
                            <div class="md:col-span-2 flex flex-col space-y-4">
                                <div class="flex items-center">
                                    <input type="checkbox" id="isActive" name="isActive"
                                        class="h-4 w-4 text-pink-600 focus:ring-pink-500 border-gray-300 rounded"
                                        ${product==null || product.active ? 'checked' : '' }>
                                    <label for="isActive"
                                        class="ml-2 block text-sm font-bold text-gray-900 cursor-pointer">
                                        Đang kinh doanh (Hiển thị hiển trên trang web)
                                    </label>
                                </div>
                                <div class="flex items-center">
                                    <input type="checkbox" id="isFeatured" name="isFeatured"
                                        class="h-4 w-4 text-pink-600 focus:ring-pink-500 border-gray-300 rounded"
                                        ${product !=null && product.featured ? 'checked' : '' }>
                                    <label for="isFeatured"
                                        class="ml-2 block text-sm font-bold text-gray-900 cursor-pointer">
                                        Sản phẩm nổi bật (Hiển thị trang chủ)
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="pt-6 border-t border-gray-200 flex justify-end">
                            <a href="${pageContext.request.contextPath}/admin/products"
                                class="bg-white py-2 px-4 border border-gray-300 rounded-lg shadow-sm text-sm font-bold text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-pink-500 mr-4 transition-colors">
                                Hủy bớt
                            </a>
                            <button type="submit"
                                class="bg-pink-600 border border-transparent rounded-lg shadow-sm py-2 px-6 inline-flex justify-center text-sm font-bold text-white hover:bg-pink-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-pink-500 transition-colors">
                                Lưu thông tin
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <footer class="bg-white border-t py-4 text-center text-gray-500 text-sm mt-auto">
                MochiGo Admin Panel &copy; 2026
            </footer>

        </body>

        </html>