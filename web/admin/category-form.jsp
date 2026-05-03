<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>${not empty category ? 'SửaDanh mục' : 'Thêm Danh mục mới'} - Admin MochiGo</title>
            <script src="https://cdn.tailwindcss.com"></script>
        </head>

        <body class="bg-gray-100 min-h-screen flex flex-col">

            <jsp:include page="/admin/admin-nav.jsp" />

            <div class="max-w-3xl mx-auto py-10 px-4 sm:px-6 lg:px-8 w-full flex-grow">
                <div class="mb-6 flex items-center justify-between">
                    <h1 class="text-3xl font-extrabold text-gray-900">
                        ${not empty category ? 'Chỉnh sửa Danh mục ✏️' : 'Thêm Danh mục mới ✨'}
                    </h1>
                    <a href="${pageContext.request.contextPath}/admin/categories"
                        class="text-pink-600 hover:text-pink-800 font-medium">← Quay lại danh sách</a>
                </div>

                <div class="bg-white rounded-xl shadow-sm border p-8">
                    <form action="${pageContext.request.contextPath}/admin/categories" method="post" 
                          enctype="multipart/form-data" class="space-y-6">
                        <input type="hidden" name="action" value="${not empty category ? 'update' : 'insert'}">
                        <c:if test="${not empty category}">
                            <input type="hidden" name="categoryId" value="${category.categoryId}">
                        </c:if>
                        
                        <!-- Logo/Image -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 items-start">
                            <div class="space-y-4">
                                <div>
                                    <label class="block text-sm font-bold text-gray-700 mb-2">Ảnh đại diện danh mục</label>
                                    <input type="file" name="imageFile" id="imageFile" accept="image/*"
                                        class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-pink-50 file:text-pink-700 hover:file:bg-pink-100 border rounded-lg p-1"
                                        onchange="previewImage(this)">
                                </div>
                                <div>
                                    <label class="block text-sm font-bold text-gray-700 mb-2">Hoặc URL ảnh</label>
                                    <input type="text" name="imageUrl" value="${category.imageUrl}"
                                        class="block w-full rounded-md border-0 py-2 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-inset focus:ring-pink-600 sm:text-sm px-4">
                                </div>
                            </div>
                            <div class="flex flex-col items-center justify-center border-2 border-dashed border-gray-300 rounded-xl p-4 min-h-[150px] bg-gray-50">
                                <p class="text-[10px] font-bold text-gray-400 uppercase mb-2">Xem trước</p>
                                <div id="imagePreviewContainer">
                                    <c:choose>
                                        <c:when test="${not empty category.imageUrl}">
                                            <img id="imagePreview" src="${pageContext.request.contextPath}/${category.imageUrl}" 
                                                 class="max-h-32 rounded shadow-sm" alt="Preview">
                                        </c:when>
                                        <c:otherwise>
                                            <div id="no-image-text" class="text-gray-400 text-xs italic">Chưa có ảnh</div>
                                            <img id="imagePreview" src="#" class="hidden max-h-32 rounded shadow-sm" alt="Preview">
                                        </c:otherwise>
                                    </c:choose>
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

                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-2">Tên Danh mục *</label>
                            <input type="text" name="name" value="${category.name}" required
                                class="block w-full rounded-md border-0 py-2.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-pink-600 sm:text-sm sm:leading-6 px-4">
                        </div>

                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-2">Mô tả (Tùy chọn)</label>
                            <textarea name="description" rows="3"
                                class="block w-full rounded-md border-0 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-pink-600 sm:py-2.5 sm:text-sm sm:leading-6 px-4">${category.description}</textarea>
                        </div>

                        <div class="flex items-center">
                            <input type="checkbox" name="isActive" id="isActive"
                                class="h-5 w-5 rounded border-gray-300 text-pink-600 focus:ring-pink-600" ${category==null || category.active ? 'checked' : '' }>
                            <label for="isActive" class="ml-3 block text-sm font-bold text-gray-700 cursor-pointer">
                                Đang hoạt động (Khách hàng có thể thấy và bấm vào danh mục này)
                            </label>
                        </div>

                        <div class="pt-4 border-t flex justify-end">
                            <button type="submit"
                                class="bg-pink-600 hover:bg-pink-700 text-white px-6 py-2.5 rounded-lg shadow-sm font-bold transition-colors">
                                ${not empty category ? 'Lưu thay đổi' : 'Tạo mới'}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </body>

        </html>