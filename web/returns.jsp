<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>Chính Sách Đổi Trả - MochiGo</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body class="bg-gray-50 text-gray-800 min-h-screen flex flex-col">
        <jsp:include page="/common/navbar.jsp" />

        <main class="max-w-4xl mx-auto py-12 px-4 sm:px-6 lg:px-8 flex-grow">
            <div class="bg-white rounded-2xl shadow-sm p-8 md:p-12 mb-8">
                <h1 class="text-3xl md:text-4xl font-extrabold text-pink-700 mb-6 text-center">Chính Sách Đổi Trả 🔄
                </h1>
                <div class="space-y-6 text-base leading-relaxed text-gray-600">
                    <p>Sự hài lòng của quý khách là ưu tiên hàng đầu tại MochiGo. Chúng tôi cam kết chất lượng sản phẩm
                        chuẩn xác nhất, tuy nhiên trong một số trường hợp rủi ro bất khả kháng, MochiGo áp dụng chính
                        sách đổi trả hàng hóa rõ ràng như sau:</p>

                    <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">1. Điều kiện áp dụng đổi trả</h2>
                    <p>Quý khách được quyền đổi hoặc trả hàng hoàn tiền 100% khi rơi vào các trường hợp:</p>
                    <ul class="list-disc pl-6 space-y-2">
                        <li>Sản phẩm bị biến dạng, móp méo nặng, biến màu hoặc hư hỏng tính chất trong quá trình vận
                            chuyển.</li>
                        <li>Sản phẩm giao không đúng với loại hoặc số lượng mà khách hàng đã đặt (VD: Đặt Mochi matcha
                            nhưng giao Mochi dâu tây).</li>
                        <li>Sản phẩm bị quá hạn sử dụng khi nhận hàng.</li>
                    </ul>

                    <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">2. Thời gian khiếu nại và đổi trả</h2>
                    <p>Do tính chất đặc biệt của sản phẩm bánh kẹo (đặc biệt là các dòng bánh tươi), quý khách vui lòng:
                    </p>
                    <ul class="list-disc pl-6 space-y-2">
                        <li>Thông báo và gửi hình ảnh/video bằng chứng qua kênh liên hệ của MochiGo <strong>trong vòng
                                24 giờ</strong> kể từ lúc nhận hàng.</li>
                        <li>Sau khi xác nhận từ bộ phận CSKH, MochiGo sẽ tiến hành cử shipper đến thu hồi hàng lỗi và
                            giao lại hàng mới (chi phí đổi hàng MochiGo chịu hoàn toàn).</li>
                    </ul>

                    <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">3. Các trường hợp KHÔNG hỗ trợ đổi trả</h2>
                    <ul class="list-disc pl-6 space-y-2">
                        <li>Sản phẩm bị hỏng do quý khách bảo quản không đúng cách (VD: Để bánh Mochi lạnh ở nhiệt độ
                            thường làm chảy kem).</li>
                        <li>Quý khách tự ý thay đổi quyết định, không thích nữa hoặc đặt nhầm sản phẩm.</li>
                        <li>Thông báo phản ánh hỏng hóc nhưng quá thời gian 24 giờ.</li>
                    </ul>

                    <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">4. Quy trình hoàn tiền (nếu có)</h2>
                    <p>Nếu sản phẩm đổi bị hết hàng hoặc quý khách muốn hoàn tiền, MochiGo sẽ thực hiện chuyển khoản lại
                        phí thanh toán mà khách hàng đã trả (qua Tài Khoản Ngân Hàng/Momo/PayOS) chậm nhất trong vòng
                        2-3 ngày làm việc sau khi xác minh sự việc.</p>
                </div>
            </div>
        </main>

        <jsp:include page="/common/footer.jsp" />
    </body>

    </html>