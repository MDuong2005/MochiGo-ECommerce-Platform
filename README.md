<div align="center">

  <img src="https://capsule-render.vercel.app/api?type=waving&color=timeGradient&height=200&section=header&text=MochiGo%20E-Commerce&fontSize=50&fontAlignY=35&animation=twinkling" width="100%" />

  # 🍡 MochiGo - Premium Japanese Mochi E-Commerce Platform

  **A modern web application built on Java Servlet/JSP, designed for an optimized and seamless dessert shopping experience.**

  ![Java](https://img.shields.io/badge/Java_17-ED8B00?style=for-the-badge&logo=java&logoColor=white)
  ![Servlet/JSP](https://img.shields.io/badge/Java_EE_10-007396?style=for-the-badge&logo=java&logoColor=white)
  ![SQL Server](https://img.shields.io/badge/SQL_Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
  ![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white)
  ![Tomcat](https://img.shields.io/badge/Apache_Tomcat-F8DC75?style=for-the-badge&logo=apache-tomcat&logoColor=black)

</div>

---

## 🌟 Key Features

Unlike typical CRUD-focused web applications, **MochiGo** offers a robust, production-ready e-commerce workflow with real-world business logics, secure cryptographic algorithms, and modern API integrations.

<table>
  <tr>
    <td align="center" width="50%">
      <h3>🛍️ Customer Experience</h3>
    </td>
    <td align="center" width="50%">
      <h3>👑 Admin Management</h3>
    </td>
  </tr>
  <tr>
    <td valign="top">
      ✔️ <b>Live Payment Integration (PayOS):</b> Seamless checkout via bank transfer QR codes.<br><br>
      ✔️ <b>Smart Cart System:</b> Real-time add, update, and remove functionalities.<br><br>
      ✔️ <b>Advanced Security:</b> Passwords secured with <b>SHA-256</b> hashing algorithm.<br><br>
      ✔️ <b>Promo Codes (Voucher):</b> Automated discount calculations applied at checkout.<br><br>
      ✔️ <b>OTP Password Recovery:</b> Secure verification codes dispatched through active SMTP Email service.
    </td>
    <td valign="top">
      ✔️ <b>Analytics Dashboard:</b> Visually rich charts providing real-time revenue and sales tracking.<br><br>
      ✔️ <b>Inventory Control:</b> Automated stock adjustments managed via <b>SQL Rollback Transactions</b>.<br><br>
      ✔️ <b>Order Dispatching:</b> Comprehensive order detail analysis with multi-stage processing.<br><br>
      ✔️ <b>Route Protection:</b> Strict <b>Servlet Filters</b> protecting the admin panel from unauthorized breaches.<br><br>
      ✔️ <b>User Management:</b> Role delegation, custom discount issuance, and account banning capabilities.
    </td>
  </tr>
</table>

---

## 🛠️ Architecture & Technologies

<p align="center">
  <img src="https://img.shields.io/badge/Architecture-MVC_%7C_DAO_%7C_DTO-blue?style=flat-square&logo=gitbook">
  <img src="https://img.shields.io/badge/Database-Raw_JDBC_%2B_Transactions-red?style=flat-square&logo=databricks">
  <img src="https://img.shields.io/badge/Frontend-JSP_%2B_TailwindCSS-teal?style=flat-square&logo=tailwindcss">
</p>

The project strictly adheres to the **MVC (Model-View-Controller)** pattern, utilizing **DAO (Data Access Object)** and **DTO (Data Transfer Object)** to maintain clean decoupling. High-risk actions such as payment state mutations and checkout orders are wrapped within strict **SQL Transactions (Commit/Rollback)** to prevent partial-state corruption and data anomalies.

---

## 🚀 Installation & Local Setup

Follow these simple steps to run the application locally on your machine:

> **1. Clone the repository**
```bash
git clone [https://github.com/MDuong2005/MochiGo-ECommerce-Platform.git](https://github.com/MDuong2005/MochiGo-ECommerce-Platform.git)
