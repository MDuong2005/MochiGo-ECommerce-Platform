<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Thêm Voucher - Admin MochiGo</title>
            <!-- Tailwind -->
            <script src="https://cdn.tailwindcss.com"></script>
            <!-- Select2 for User Search -->
            <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
            <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
        </head>

        <body class="bg-gray-100 min-h-screen flex flex-col">

            <jsp:include page="/admin/admin-nav.jsp" />

            <div class="max-w-3xl mx-auto py-10 px-4 sm:px-6 lg:px-8 w-full flex-grow">
                <div class="mb-8 flex items-center">
                    <a href="${pageContext.request.contextPath}/admin/vouchers"
                        class="text-gray-500 hover:text-pink-600 mr-4 font-bold flex items-center">
                        Quay lại
                    </a>
                    <h1 class="text-3xl font-extrabold text-gray-900">
                        <c:choose>
                            <c:when test="${not empty voucher}">Cập Nhật Voucher 🎟️</c:when>
                            <c:otherwise>Tạo Voucher Mới 🎟️</c:otherwise>
                        </c:choose>
                    </h1>
                </div>

                <c:if test="${not empty error}">
                    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4"
                        role="alert">
                        <span class="block sm:inline">${error}</span>
                    </div>
                </c:if>

                <div class="bg-white shadow-md rounded-2xl p-8 border border-gray-200">
                    <form action="${pageContext.request.contextPath}/admin/voucher-create" method="post"
                        class="space-y-6">

                        <c:if test="${not empty voucher}">
                            <input type="hidden" name="voucherId" value="${voucher.voucherId}">
                        </c:if>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-sm font-bold text-gray-700 mb-2">Mã Voucher</label>
                                <input type="text" name="code" value="${voucher.code}" placeholder="Để trống tự sinh mã"
                                    class="block w-full rounded-lg border-gray-300 shadow-sm focus:border-pink-500 focus:ring-pink-500 sm:text-sm py-2 px-3 border">
                            </div>

                            <div>
                                <label class="block text-sm font-bold text-gray-700 mb-2">Tổng số lượng phát hành <span
                                        class="text-red-500">*</span></label>
                                <input type="number" name="totalQuantity"
                                    value="${not empty voucher ? voucher.totalQuantity : 100}" min="1" required
                                    class="block w-full rounded-lg border-gray-300 shadow-sm focus:border-pink-500 sm:text-sm py-2 px-3 border">
                            </div>

                            <div>
                                <label class="block text-sm font-bold text-gray-700 mb-2">Loại Giảm Giá <span
                                        class="text-red-500">*</span></label>
                                <select id="discountType" name="discountType"
                                    class="block w-full rounded-lg border-gray-300 shadow-sm py-2 px-3 border" required>
                                    <option value="FIXED" ${voucher.discountType=='FIXED' ? 'selected' : '' }>Giá tiền
                                        trực tiếp (VNĐ)</option>
                                    <option value="PERCENT" ${voucher.discountType=='PERCENT' ? 'selected' : '' }>Phần
                                        trăm (%)</option>
                                </select>
                            </div>

                            <div>
                                <label class="block text-sm font-bold text-gray-700 mb-2">Giá Trị Giảm <span
                                        class="text-red-500">*</span></label>
                                <input type="number" name="discountValue" value="${voucher.discountValue}" step="0.01"
                                    required
                                    class="block w-full rounded-lg border-gray-300 shadow-sm sm:text-sm py-2 px-3 border">
                            </div>

                            <div id="maxDiscountContainer"
                                style="display: ${voucher.discountType == 'PERCENT' ? 'block' : 'none'};">
                                <label class="block text-sm font-bold text-gray-700 mb-2">Mức giảm tối đa (VNĐ)</label>
                                <input type="number" name="maxDiscountValue" value="${voucher.maxDiscountValue}"
                                    step="0.01"
                                    class="block w-full rounded-lg border-gray-300 shadow-sm sm:text-sm py-2 px-3 border">
                            </div>

                            <div>
                                <label class="block text-sm font-bold text-gray-700 mb-2">Đơn Hàng Tối Thiểu
                                    (VNĐ)</label>
                                <input type="number" name="minOrderValue"
                                    value="${not empty voucher ? voucher.minOrderValue : 0}" step="0.01"
                                    class="block w-full rounded-lg border-gray-300 shadow-sm sm:text-sm py-2 px-3 border">
                            </div>

                            <div>
                                <label class="block text-sm font-bold text-gray-700 mb-2">Giới Hạn Lần Dùng/Người <span
                                        class="text-red-500">*</span></label>
                                <input type="number" name="maxUsesPerUser"
                                    value="${not empty voucher ? voucher.maxUsesPerUser : 1}" min="1" required
                                    class="block w-full rounded-lg border-gray-300 shadow-sm sm:text-sm py-2 px-3 border">
                            </div>

                            <div>
                                <label class="block text-sm font-bold text-gray-700 mb-2">Mục Tiêu Áp Dụng <span
                                        class="text-red-500">*</span></label>
                                <select id="targetType" name="targetType"
                                    class="block w-full rounded-lg border-gray-300 shadow-sm py-2 px-3 border" required>
                                    <option value="PUBLIC" ${voucher.targetType=='PUBLIC' ? 'selected' : '' }>Tất cả
                                        khách hàng</option>
                                    <option value="SPECIFIC_USER" ${voucher.targetType=='SPECIFIC_USER' ? 'selected'
                                        : '' }>Chỉ định User cụ thể</option>
                                    <option value="CUSTOMER_GROUP" ${voucher.targetType=='CUSTOMER_GROUP' ? 'selected'
                                        : '' }>Theo Nhóm Khách hàng</option>
                                </select>
                            </div>

                            <div id="targetGroupContainer"
                                style="display: ${voucher.targetType == 'CUSTOMER_GROUP' ? 'block' : 'none'};">
                                <label class="block text-sm font-bold text-gray-700 mb-2">Chọn Nhóm</label>
                                <select name="targetGroup"
                                    class="block w-full rounded-lg border-gray-300 shadow-sm py-2 px-3 border">
                                    <option value="NEW_CUSTOMER" ${voucher.targetGroup=='NEW_CUSTOMER' ? 'selected' : ''
                                        }>Khách hàng mới</option>
                                    <option value="VIP" ${voucher.targetGroup=='VIP' ? 'selected' : '' }>Khách VIP
                                    </option>
                                    <option value="INACTIVE_30D" ${voucher.targetGroup=='INACTIVE_30D' ? 'selected' : ''
                                        }>Khách hàng >30 ngày chưa mua</option>
                                </select>
                            </div>

                            <div id="specificUserContainer" class="md:col-span-2"
                                style="display: ${voucher.targetType == 'SPECIFIC_USER' ? 'block' : 'none'};">
                                <label class="block text-sm font-bold text-gray-700 mb-2">Tìm & Chọn Khách Hàng</label>
                                <select id="userSearch" name="selectedUsers" multiple="multiple"
                                    class="w-full"></select>
                            </div>

                            <div>
                                <label class="block text-sm font-bold text-gray-700 mb-2">Bắt đầu <span
                                        class="text-red-500">*</span></label>
                                <input type="datetime-local" name="startDate" required
                                    value="${not empty voucher.startDate ? voucher.startDate.toString().substring(0, 16) : ''}"
                                    class="block w-full rounded-lg border-gray-300 shadow-sm sm:text-sm py-2 px-3 border">
                            </div>

                            <div>
                                <label class="block text-sm font-bold text-gray-700 mb-2">Hết hạn <span
                                        class="text-red-500">*</span></label>
                                <input type="datetime-local" name="endDate" required
                                    value="${not empty voucher.endDate ? voucher.endDate.toString().substring(0, 16) : ''}"
                                    class="block w-full rounded-lg border-gray-300 shadow-sm sm:text-sm py-2 px-3 border">
                            </div>
                        </div>

                        <div class="pt-6 border-t border-gray-200 flex justify-end">
                            <button type="submit"
                                class="bg-pink-600 rounded-lg shadow-sm py-2 px-6 text-sm font-bold text-white hover:bg-pink-700 transition-colors">
                                Lưu Voucher
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <script>
                $(document).ready(function () {
                    // UI Toggle Logic
                    $('#discountType').change(function () {
                        if ($(this).val() === 'PERCENT') {
                            $('#maxDiscountContainer').show();
                        } else {
                            $('#maxDiscountContainer').hide();
                        }
                    });

                    $('#targetType').change(function () {
                        const val = $(this).val();
                        if (val === 'SPECIFIC_USER') {
                            $('#specificUserContainer').show();
                            $('#targetGroupContainer').hide();
                        } else if (val === 'CUSTOMER_GROUP') {
                            $('#targetGroupContainer').show();
                            $('#specificUserContainer').hide();
                        } else {
                            $('#specificUserContainer').hide();
                            $('#targetGroupContainer').hide();
                        }
                    });

                    // Select2 Ajax setup
                    $('#userSearch').select2({
                        ajax: {
                            url: '${pageContext.request.contextPath}/admin/voucher-search-users',
                            dataType: 'json',
                            delay: 250,
                            data: function (params) {
                                return { q: params.term };
                            },
                            processResults: function (data) {
                                return { results: data };
                            },
                            cache: true
                        },
                        placeholder: 'Gõ Email hoặc Tên để tìm kiếm...',
                        minimumInputLength: 1
                    });
                });
            </script>
        </body>

        </html>