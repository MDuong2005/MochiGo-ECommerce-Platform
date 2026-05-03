<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <footer class="bg-pink-800 text-white mt-auto py-8">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <div>
                    <h3 class="text-xl font-bold mb-4">MochiGo🍡</h3>
                    <p class="text-pink-200">Thương hiệu bánh kẹo ngọt ngào nhất, mang đến cho bạn những trải nghiệm
                        tuyệt vời.</p>
                </div>
                <div>
                    <h4 class="text-lg font-semibold mb-4">Liên hệ</h4>
                    <ul class="text-pink-200 space-y-2">
                        <li>Email: maid88391@gmail.com</li>
                        <li>SĐT: 0979705956</li>
                        <li>Địa chỉ: Hà Nội, Việt Nam</li>
                    </ul>
                </div>
                <div>
                    <h4 class="text-lg font-semibold mb-4">Chính sách</h4>
                    <ul class="text-pink-200 space-y-2">
                        <li><a href="${pageContext.request.contextPath}/shipping.jsp" class="hover:text-white">Giao
                                hàng</a></li>
                        <li><a href="${pageContext.request.contextPath}/returns.jsp" class="hover:text-white">Đổi
                                trả</a></li>
                        <li><a href="${pageContext.request.contextPath}/privacy.jsp" class="hover:text-white">Bảo
                                mật</a></li>
                    </ul>
                </div>
            </div>
            <div class="border-t border-pink-700 mt-8 pt-8 text-center text-pink-300">
                <p>&copy; 2026 MochiGo. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <!-- Messenger Plugin chat Code -->
    <div id="fb-root"></div>

    <!-- Your Plugin chat code -->
    <div id="fb-customer-chat" class="fb-customerchat"></div>

    <script>
        var chatbox = document.getElementById('fb-customer-chat');
        chatbox.setAttribute("page_id", "YOUR_PAGE_ID_HERE"); // Thay thế YOUR_PAGE_ID_HERE bằng ID Trang Facebook của shop
        chatbox.setAttribute("attribution", "biz_inbox");
    </script>

    <script>
        window.fbAsyncInit = function () {
            FB.init({
                xfbml: true,
                version: 'v18.0'
            });
        };

        (function (d, s, id) {
            var js, fjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id)) return;
            js = d.createElement(s); js.id = id;
            js.src = 'https://connect.facebook.net/vi_VN/sdk/xfbml.customerchat.js';
            fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));
    </script>