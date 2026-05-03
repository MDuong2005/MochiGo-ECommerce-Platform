<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>Chính Sách Giao Hàng - MochiGo</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body class="bg-gray-50 text-gray-800 min-h-screen flex flex-col">
        <jsp:include page="/common/navbar.jsp" />

        <main class="max-w-4xl mx-auto py-12 px-4 sm:px-6 lg:px-8 flex-grow">
            <div class="bg-white rounded-2xl shadow-sm p-8 md:p-12 mb-8">
                <h1 class="text-3xl md:text-4xl font-extrabold text-pink-700 mb-6 text-center">Chính Sách Giao Hàng 🚚
                </h1>
                <div class="space-y-6 text-base leading-relaxed text-gray-600">
                    <p>Cảm ơn quý khách đã tin tưởng và lựa chọn MochiGo. Chúng tôi luôn cố gắng mang đến trải nghiệm
                        mua sắm tốt nhất với quy trình giao hàng nhanh chóng và đảm bảo chất lượng.</p>

                    <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">1. Phạm vi giao hàng</h2>
                    <ul class="list-disc pl-6 space-y-2">
                        <li>Chúng tôi phục vụ giao hàng tận nơi trên **toàn quốc**.</li>
                        <li>Sản phẩm Mochi lạnh sẽ được đóng gói bằng hộp giữ nhiệt đặc biệt để đảm bảo độ tươi ngon khi
                            đến tay quý khách.</li>
                    </ul>

                    <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">2. Thời gian giao hàng</h2>
                    <ul class="list-disc pl-6 space-y-2">
                        <li>**Khu vực nội thành Hà Nội:** Giao hàng ngay trong ngày hoặc theo khung giờ hẹn trước (tối
                            đa 24h).</li>
                        <li>**Khu vực ngoại thành và các tỉnh chi nhánh khác:** Thời gian giao hàng từ 1 - 3 ngày làm
                            việc (không tính Chủ Nhật và các ngày Lễ/Tết).</li>
                    </ul>

                    <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">3. Cước phí giao hàng</h2>
                    <p>Hệ thống sẽ tự động tính toán cước phí vận chuyển dựa trên khoảng cách và khối lượng đơn hàng.
                        Trong quá trình thanh toán, MochiGo thường xuyên tung ra các **Voucher Miễn phí Vận chuyển** nên
                        quý khách đừng quên áp dụng mã vào nhé.</p>

                    <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">4. Kiểm tra hàng và thanh toán</h2>
                    <p>Khách hàng được quyền kiểm tra sản phẩm trước khi thanh toán (với hình thức COD) hoặc sau khi
                        nhận được hàng (khi đã thanh toán PayOS). Nếu sản phẩm bị móp méo, hỏng hóc trong quá trình vận
                        chuyển, vui lòng tham khảo <a href="returns.jsp"
                            class="text-pink-600 font-semibold hover:underline">Chính sách Đổi Trả</a>.</p>
                </div>
            </div>
        </main>

        <jsp:include page="/common/footer.jsp" />
    </body>

    </html>