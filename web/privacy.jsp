<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>Chính Sách Bảo Mật - MochiGo</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body class="bg-gray-50 text-gray-800 min-h-screen flex flex-col">
        <jsp:include page="/common/navbar.jsp" />

        <main class="max-w-4xl mx-auto py-12 px-4 sm:px-6 lg:px-8 flex-grow">
            <div class="bg-white rounded-2xl shadow-sm p-8 md:p-12 mb-8">
                <h1 class="text-3xl md:text-4xl font-extrabold text-pink-700 mb-6 text-center">Chính Sách Bảo Mật 🔒
                </h1>
                <div class="space-y-6 text-base leading-relaxed text-gray-600">
                    <p>Việc bảo vệ dữ liệu cá nhân của quý khách là cam kết nghiêm túc của MochiGo. Chúng tôi tôn trọng
                        quyền riêng tư và chỉ thu thập những thông tin thực sự cần thiết.</p>

                    <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">1. Mục đích thu thập thông tin cá nhân</h2>
                    <p>Thông tin của quý khách (Họ Tên, Số điện thoại, Địa chỉ nhận hàng, Email) chỉ được MochiGo thu
                        thập nhằm mục đích:</p>
                    <ul class="list-disc pl-6 space-y-2">
                        <li>Thực hiện xử lý đơn đặt hàng, cung cấp dịch vụ giao hàng.</li>
                        <li>Giải quyết các vấn đề, khiếu nại phát sinh từ dịch vụ.</li>
                        <li>Gửi các thông báo về trạng thái đơn hàng (Xác nhận Đang giao, Phát thành công, Mã giảm giá
                            đặc biệt nếu bạn đăng ký nhận thư).</li>
                    </ul>

                    <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">2. Phạm vi sử dụng thông tin</h2>
                    <p>MochiGo <strong>tuyệt đối không</strong> chia sẻ, bán, hoặc trao đổi thông tin cá nhân của khách
                        hàng với bất kỳ bên thứ 3 nào ngoại trừ:</p>
                    <ul class="list-disc pl-6 space-y-2">
                        <li>Đối tác vận chuyển (Viettel Post, GHTK, v.v...) để phục vụ việc giao hàng tận nhà.</li>
                        <li>Yêu cầu bắt buộc từ cơ quan pháp luật có thẩm quyền.</li>
                    </ul>

                    <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">3. Lưu trữ và bảo mật dữ liệu</h2>
                    <p>Hệ thống dữ liệu Website MochiGo (bao gồm thông tin Khách hàng, Lịch sử Mua, Giỏ Hàng) đều được
                        số hóa, mã hóa và lưu trữ định kỳ tại hệ CSDL an toàn có Firewall bảo vệ.</p>
                    <p><strong>Lưu ý:</strong> Mọi thông tin thanh toán nội địa qua PayOS đều diễn ra trên cổng của đối
                        tác chuẩn quốc tế, MochiGo không nắm giữ số thẻ tín dụng và/hoặc mật khẩu thanh toán của quý
                        khách.</p>

                    <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">4. Quyền của khách hàng</h2>
                    <p>Mỗi khách hàng đều có tài khoản bảo vệ bởi mật khẩu và được áp dụng cơ chế mã hóa. Quý khách có
                        quyền truy cập, chỉnh sửa các thông tin đăng ký dễ dàng ở phần Hồ Sơ Tài Khoản, hoặc có thể yêu
                        cầu MochiGo xóa hoàn toàn thông tin nếu không có nhu cầu sử dụng dịch vụ tiếp.</p>
                </div>
            </div>
        </main>

        <jsp:include page="/common/footer.jsp" />
    </body>

    </html>