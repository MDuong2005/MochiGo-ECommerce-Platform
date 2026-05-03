<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Báo cáo doanh thu - MochiGo</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body class="bg-gray-100 min-h-screen flex flex-col">

    <jsp:include page="/admin/admin-nav.jsp" />

    <div class="max-w-7xl mx-auto py-10 px-4 sm:px-6 lg:px-8 w-full flex-grow">
        <div class="flex justify-between items-center mb-8">
            <h1 class="text-3xl font-extrabold text-gray-900">Báo cáo doanh thu 📊</h1>
            <a href="${pageContext.request.contextPath}/admin/dashboard"
                class="inline-flex items-center px-4 py-2 bg-gray-600 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-gray-700 active:bg-gray-900 focus:outline-none focus:border-gray-900 focus:ring ring-gray-300 disabled:opacity-25 transition ease-in-out duration-150">
                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                </svg>
                Quay lại Dashboard
            </a>
        </div>

        <!-- Biểu đồ doanh thu -->
        <div class="bg-white rounded-xl shadow-lg p-8 mb-8 border border-gray-100">
            <div class="flex justify-between items-center mb-10">
                <div>
                    <h2 class="text-2xl font-bold text-gray-800">Biểu đồ so sánh doanh thu từng tháng</h2>
                    <p class="text-gray-500 mt-1">Dữ liệu doanh thu năm ${currentYear} (Đơn đã thanh toán/đang giao/hoàn thành)</p>
                </div>
                <div class="text-right">
                    <div class="text-sm text-gray-400 uppercase tracking-wider font-semibold">Đơn vị</div>
                    <div class="text-xl font-bold text-pink-600">VNĐ</div>
                </div>
            </div>
            
            <div class="h-[500px]">
                <canvas id="revenueChart"></canvas>
            </div>
            
            <div class="mt-10 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                <div class="bg-green-50 p-4 rounded-lg border border-green-100">
                    <div class="text-green-600 text-sm font-bold uppercase mb-1">Tổng doanh thu năm</div>
                    <div id="totalYearlyRevenue" class="text-2xl font-extrabold text-gray-900">--</div>
                </div>
                <div class="bg-pink-50 p-4 rounded-lg border border-pink-100">
                    <div class="text-pink-600 text-sm font-bold uppercase mb-1">Tháng cao nhất</div>
                    <div id="maxMonth" class="text-xl font-extrabold text-gray-900">--</div>
                </div>
                <div class="bg-blue-50 p-4 rounded-lg border border-blue-100">
                    <div class="text-blue-600 text-sm font-bold uppercase mb-1">Trung bình tháng</div>
                    <div id="avgRevenue" class="text-xl font-extrabold text-gray-900">--</div>
                </div>
            </div>
        </div>
    </div>

    <footer class="bg-white border-t py-4 text-center text-gray-500 text-sm mt-auto">
        MochiGo Admin Panel &copy; 2026
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const ctx = document.getElementById('revenueChart').getContext('2d');
            const monthlyRevenue = [
                <c:forEach var="i" begin="1" end="12">
                    ${monthlyRevenue[i] != null ? monthlyRevenue[i] : 0}${i < 12 ? ',' : ''}
                </c:forEach>
            ];

            const months = ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'];

            // Calculate stats
            let maxVal = Math.max(...monthlyRevenue);
            let maxIdx = monthlyRevenue.indexOf(maxVal);
            let sum = monthlyRevenue.reduce((a, b) => a + b, 0);
            let avg = sum / 12;

            document.getElementById('totalYearlyRevenue').innerText = new Intl.NumberFormat('vi-VN').format(sum) + ' đ';
            document.getElementById('maxMonth').innerText = months[maxIdx] + ' (' + new Intl.NumberFormat('vi-VN').format(maxVal) + ' đ)';
            document.getElementById('avgRevenue').innerText = new Intl.NumberFormat('vi-VN').format(avg.toFixed(0)) + ' đ';

            // Create Gradient
            const gradient = ctx.createLinearGradient(0, 0, 0, 400);
            gradient.addColorStop(0, 'rgba(236, 72, 153, 0.8)');
            gradient.addColorStop(1, 'rgba(244, 114, 182, 0.2)');

            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: months,
                    datasets: [{
                        label: 'Doanh thu',
                        data: monthlyRevenue,
                        backgroundColor: gradient,
                        borderColor: 'rgba(236, 72, 153, 1)',
                        borderWidth: 2,
                        borderRadius: 10,
                        hoverBackgroundColor: 'rgba(236, 72, 153, 1)',
                        barPercentage: 0.6
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    interaction: {
                        mode: 'index',
                        intersect: false,
                    },
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            backgroundColor: 'rgba(31, 41, 55, 0.9)',
                            titleFont: { size: 14, weight: 'bold' },
                            bodyFont: { size: 14 },
                            padding: 12,
                            cornerRadius: 8,
                            callbacks: {
                                label: function(context) {
                                    let val = context.parsed.y;
                                    return ' Doanh thu: ' + new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val);
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: {
                                color: 'rgba(0, 0, 0, 0.05)',
                                drawBorder: false
                            },
                            ticks: {
                                font: { size: 12 },
                                callback: function(value) {
                                    return new Intl.NumberFormat('vi-VN', { notation: 'compact' }).format(value) + ' đ';
                                }
                            }
                        },
                        x: {
                            grid: {
                                display: false
                            },
                            ticks: {
                                font: { size: 12, weight: '500' }
                            }
                        }
                    },
                    animation: {
                        duration: 1500,
                        easing: 'easeOutBounce'
                    }
                }
            });
        });
    </script>
</body>
</html>
