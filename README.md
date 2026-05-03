<div align="center">

  <img src="https://capsule-render.vercel.app/api?type=waving&color=timeGradient&height=200&section=header&text=MochiGo%20E-Commerce&fontSize=50&fontAlignY=35&animation=twinkling" width="100%" />

  # 🍡 MochiGo - Đỉnh Cao Thương Mại Điện Tử

  **Dự án Website bán bánh Mochi hiện đại xây dựng bằng Java Servlet/JSP**

  ![Java](https://img.shields.io/badge/Java_17-ED8B00?style=for-the-badge&logo=java&logoColor=white)
  ![Servlet/JSP](https://img.shields.io/badge/Java_EE_10-007396?style=for-the-badge&logo=java&logoColor=white)
  ![SQL Server](https://img.shields.io/badge/SQL_Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
  ![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white)
  ![Tomcat](https://img.shields.io/badge/Apache_Tomcat-F8DC75?style=for-the-badge&logo=apache-tomcat&logoColor=black)

</div>

---

## 🌟 Tại sao MochiGo lại khác biệt?

Không chỉ là một trang web quanh quẩn Thêm-Sửa-Xóa thông thường, **MochiGo** mang đến một trải nghiệm E-Commerce hoàn chỉnh với luồng nghiệp vụ kinh doanh thực tế, tích hợp công nghệ mã hóa và API hiện đại nhất.

<table>
  <tr>
    <td align="center" width="50%">
      <h3>🛍️ Dành Cho Khách Hàng</h3>
    </td>
    <td align="center" width="50%">
      <h3>👑 Dành Cho Admin</h3>
    </td>
  </tr>
  <tr>
    <td valign="top">
      ✔️ <b>Thanh toán thật (PayOS):</b> Quét mã QR thanh toán qua ngân hàng.<br><br>
      ✔️ <b>Giỏ hàng thông minh:</b> Thêm, sửa, xóa mượt mà.<br><br>
      ✔️ <b>Bảo mật tuyệt đối:</b> Password mã hóa <b>SHA-256</b>.<br><br>
      ✔️ <b>Mã giảm giá (Voucher):</b> Tự động tính toán và giảm tiền.<br><br>
      ✔️ <b>Quên mật khẩu OTP:</b> Gửi mã xác nhận qua Email thật.
    </td>
    <td valign="top">
      ✔️ <b>Thống kê doanh thu:</b> Biểu đồ cực đẹp, theo dõi real-time.<br><br>
      ✔️ <b>Quản lý tồn kho:</b> Tự động trừ hàng (Rollback Transaction).<br><br>
      ✔️ <b>Kiểm soát Đơn hàng:</b> Duyệt đơn, xem chi tiết từng món.<br><br>
      ✔️ <b>Bảo vệ trang Admin:</b> Hệ thống Filter chặn hacker truy cập trái phép.<br><br>
      ✔️ <b>Quản lý User:</b> Phân quyền, phát Voucher, khóa tài khoản.
    </td>
  </tr>
</table>

---

## 🛠️ Kiến Trúc Hệ Thống (Architecture)

<p align="center">
  <img src="https://img.shields.io/badge/Architecture-MVC_%7C_DAO_%7C_DTO-blue?style=flat-square&logo=gitbook">
  <img src="https://img.shields.io/badge/Database-JDBC_Thuần_%2B_Transaction-red?style=flat-square&logo=databricks">
  <img src="https://img.shields.io/badge/Frontend-JSP_%2B_TailwindCSS-teal?style=flat-square&logo=tailwindcss">
</p>

Dự án tuân thủ nghiêm ngặt mô hình **MVC (Model-View-Controller)**, kết hợp **DAO Pattern** để tách biệt logic xử lý dữ liệu. Luồng thanh toán và đặt hàng được bọc trong các **SQL Transactions** (Commit/Rollback) để đảm bảo không bao giờ có sự cố mất tiền hay rác dữ liệu.

---

## 🚀 Hướng dẫn Cài đặt & Khởi chạy

Chỉ với 4 bước đơn giản để tự build hệ thống tại máy của bạn:

> **1. Tải source code**
```bash
git clone https://github.com/MDuong2005/MochiGo-ECommerce-Platform.git
