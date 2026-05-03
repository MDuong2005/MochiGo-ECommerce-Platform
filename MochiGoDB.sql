USE master;
GO

IF DB_ID('MochiGoDB') IS NOT NULL
BEGIN
    ALTER DATABASE MochiGoDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE MochiGoDB;
END
GO

CREATE DATABASE MochiGoDB;
GO

USE MochiGoDB;
GO

/* =========================
   TABLE: categories
========================= */
CREATE TABLE dbo.categories (
    category_id INT IDENTITY(1,1) NOT NULL,
    name NVARCHAR(150) NOT NULL,
    description NVARCHAR(500) NULL,
    is_active BIT NOT NULL CONSTRAINT DF_categories_is_active DEFAULT (1),
    created_at DATETIME NOT NULL CONSTRAINT DF_categories_created_at DEFAULT (GETDATE()),
    updated_at DATETIME NULL,
    CONSTRAINT PK_categories PRIMARY KEY CLUSTERED (category_id),
    CONSTRAINT UQ_categories_name UNIQUE (name)
);
GO

/* =========================
   TABLE: users
========================= */
CREATE TABLE dbo.users (
    user_id INT IDENTITY(1,1) NOT NULL,
    email NVARCHAR(255) NOT NULL,
    password_hash NVARCHAR(255) NOT NULL,
    full_name NVARCHAR(150) NOT NULL,
    phone NVARCHAR(20) NULL,
    role NVARCHAR(20) NOT NULL CONSTRAINT DF_users_role DEFAULT ('USER'),
    is_active BIT NOT NULL CONSTRAINT DF_users_is_active DEFAULT (1),
    created_at DATETIME NOT NULL CONSTRAINT DF_users_created_at DEFAULT (GETDATE()),
    updated_at DATETIME NULL,
    CONSTRAINT PK_users PRIMARY KEY CLUSTERED (user_id),
    CONSTRAINT UQ_users_email UNIQUE (email),
    CONSTRAINT CK_users_role CHECK (role IN ('USER', 'ADMIN'))
);
GO

/* =========================
   TABLE: products
========================= */
CREATE TABLE dbo.products (
    product_id INT IDENTITY(1,1) NOT NULL,
    category_id INT NOT NULL,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(2000) NULL,
    price DECIMAL(12,2) NOT NULL,
    stock INT NOT NULL CONSTRAINT DF_products_stock DEFAULT (0),
    image_url NVARCHAR(500) NULL,
    is_active BIT NOT NULL CONSTRAINT DF_products_is_active DEFAULT (1),
    created_at DATETIME NOT NULL CONSTRAINT DF_products_created_at DEFAULT (GETDATE()),
    updated_at DATETIME NULL,
    is_featured BIT NULL CONSTRAINT DF_products_is_featured DEFAULT (0),
    discount_percent INT NOT NULL CONSTRAINT DF_products_discount_percent DEFAULT (0),
    CONSTRAINT PK_products PRIMARY KEY CLUSTERED (product_id),
    CONSTRAINT CK_products_price CHECK (price >= 0),
    CONSTRAINT CK_products_stock CHECK (stock >= 0),
    CONSTRAINT CK_products_discount_percent CHECK (discount_percent >= 0 AND discount_percent <= 100)
);
GO

/* =========================
   TABLE: orders
========================= */
CREATE TABLE dbo.orders (
    order_id INT IDENTITY(1,1) NOT NULL,
    user_id INT NOT NULL,
    receiver_name NVARCHAR(150) NOT NULL,
    receiver_phone NVARCHAR(20) NOT NULL,
    shipping_address NVARCHAR(500) NOT NULL,
    note NVARCHAR(1000) NULL,
    payment_method NVARCHAR(30) NOT NULL CONSTRAINT DF_orders_payment_method DEFAULT ('COD'),
    status NVARCHAR(30) NOT NULL CONSTRAINT DF_orders_status DEFAULT ('PENDING'),
    total_amount DECIMAL(12,2) NOT NULL,
    created_at DATETIME NOT NULL CONSTRAINT DF_orders_created_at DEFAULT (GETDATE()),
    updated_at DATETIME NULL,
    CONSTRAINT PK_orders PRIMARY KEY CLUSTERED (order_id),
    CONSTRAINT CK_orders_payment_method CHECK (payment_method IN ('BANK_TRANSFER', 'COD')),
    CONSTRAINT CK_orders_status CHECK (status IN ('PENDING', 'PAID', 'SHIPPING', 'COMPLETED', 'CANCELLED')),
    CONSTRAINT CK_orders_total_amount CHECK (total_amount >= 0)
);
GO

/* =========================
   TABLE: order_items
========================= */
CREATE TABLE dbo.order_items (
    order_item_id INT IDENTITY(1,1) NOT NULL,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    line_total DECIMAL(12,2) NOT NULL,
    CONSTRAINT PK_order_items PRIMARY KEY CLUSTERED (order_item_id),
    CONSTRAINT CK_order_items_quantity CHECK (quantity > 0),
    CONSTRAINT CK_order_items_unit_price CHECK (unit_price >= 0),
    CONSTRAINT CK_order_items_line_total CHECK (line_total >= 0)
);
GO

/* =========================
   TABLE: product_reviews
========================= */
CREATE TABLE dbo.product_reviews (
    review_id INT IDENTITY(1,1) NOT NULL,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    order_id INT NOT NULL,
    rating INT NOT NULL,
    comment NVARCHAR(1000) NULL,
    created_at DATETIME NOT NULL CONSTRAINT DF_product_reviews_created_at DEFAULT (GETDATE()),
    is_read BIT NOT NULL CONSTRAINT DF_product_reviews_is_read DEFAULT (0),
    CONSTRAINT PK_product_reviews PRIMARY KEY CLUSTERED (review_id),
    CONSTRAINT UQ_product_reviews UNIQUE (user_id, product_id, order_id),
    CONSTRAINT CK_product_reviews_rating CHECK (rating >= 1 AND rating <= 5)
);
GO

/* =========================
   TABLE: wishlists
========================= */
CREATE TABLE dbo.wishlists (
    wishlist_id INT IDENTITY(1,1) NOT NULL,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    created_at DATETIME NULL CONSTRAINT DF_wishlists_created_at DEFAULT (GETDATE()),
    CONSTRAINT PK_wishlists PRIMARY KEY CLUSTERED (wishlist_id),
    CONSTRAINT UQ_User_Product UNIQUE (user_id, product_id)
);
GO

/* =========================
   TABLE: vouchers
========================= */
CREATE TABLE dbo.vouchers (
    voucher_id INT IDENTITY(1,1) NOT NULL,
    code NVARCHAR(50) NOT NULL,
    discount_type NVARCHAR(20) NOT NULL,
    discount_value DECIMAL(12,2) NOT NULL,
    min_order_value DECIMAL(12,2) NOT NULL CONSTRAINT DF_vouchers_min_order_value DEFAULT (0),
    max_discount_value DECIMAL(12,2) NULL,
    total_quantity INT NOT NULL,
    used_quantity INT NOT NULL CONSTRAINT DF_vouchers_used_quantity DEFAULT (0),
    max_uses_per_user INT NOT NULL CONSTRAINT DF_vouchers_max_uses_per_user DEFAULT (1),
    target_type NVARCHAR(30) NOT NULL,
    target_group NVARCHAR(50) NULL,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    is_active BIT NOT NULL CONSTRAINT DF_vouchers_is_active DEFAULT (1),
    created_at DATETIME NOT NULL CONSTRAINT DF_vouchers_created_at DEFAULT (GETDATE()),
    updated_at DATETIME NULL,
    CONSTRAINT PK_vouchers PRIMARY KEY CLUSTERED (voucher_id),
    CONSTRAINT UQ_vouchers_code UNIQUE (code),
    CONSTRAINT CK_discount_type CHECK (discount_type IN ('PERCENT', 'FIXED')),
    CONSTRAINT CK_target_type CHECK (target_type IN ('PUBLIC', 'SPECIFIC_USER', 'CUSTOMER_GROUP'))
);
GO

/* =========================
   TABLE: voucher_users
========================= */
CREATE TABLE dbo.voucher_users (
    voucher_id INT NOT NULL,
    user_id INT NOT NULL,
    assigned_at DATETIME NULL CONSTRAINT DF_voucher_users_assigned_at DEFAULT (GETDATE()),
    CONSTRAINT PK_voucher_users PRIMARY KEY CLUSTERED (voucher_id, user_id)
);
GO

/* =========================
   TABLE: voucher_history
========================= */
CREATE TABLE dbo.voucher_history (
    history_id INT IDENTITY(1,1) NOT NULL,
    voucher_id INT NOT NULL,
    user_id INT NOT NULL,
    order_id INT NOT NULL,
    discount_amount DECIMAL(12,2) NOT NULL,
    used_at DATETIME NULL CONSTRAINT DF_voucher_history_used_at DEFAULT (GETDATE()),
    CONSTRAINT PK_voucher_history PRIMARY KEY CLUSTERED (history_id)
);
GO

/* =========================
   TABLE: coupons
========================= */
CREATE TABLE dbo.coupons (
    coupon_id INT IDENTITY(1,1) NOT NULL,
    code VARCHAR(50) NOT NULL,
    discount_percent INT NOT NULL,
    max_discount DECIMAL(18,2) NOT NULL,
    min_order DECIMAL(18,2) NOT NULL,
    is_active BIT NULL CONSTRAINT DF_coupons_is_active DEFAULT (1),
    user_id INT NULL,
    is_used BIT NULL CONSTRAINT DF_coupons_is_used DEFAULT (0),
    CONSTRAINT PK_coupons PRIMARY KEY CLUSTERED (coupon_id),
    CONSTRAINT UQ_coupons_code UNIQUE (code)
);
GO

/* =========================
   FOREIGN KEYS
========================= */
ALTER TABLE dbo.products
ADD CONSTRAINT FK_products_categories
FOREIGN KEY (category_id) REFERENCES dbo.categories(category_id);
GO

ALTER TABLE dbo.orders
ADD CONSTRAINT FK_orders_users
FOREIGN KEY (user_id) REFERENCES dbo.users(user_id);
GO

ALTER TABLE dbo.order_items
ADD CONSTRAINT FK_order_items_orders
FOREIGN KEY (order_id) REFERENCES dbo.orders(order_id);
GO

ALTER TABLE dbo.order_items
ADD CONSTRAINT FK_order_items_products
FOREIGN KEY (product_id) REFERENCES dbo.products(product_id);
GO

ALTER TABLE dbo.product_reviews
ADD CONSTRAINT FK_product_reviews_products
FOREIGN KEY (product_id) REFERENCES dbo.products(product_id);
GO

ALTER TABLE dbo.product_reviews
ADD CONSTRAINT FK_product_reviews_users
FOREIGN KEY (user_id) REFERENCES dbo.users(user_id);
GO

ALTER TABLE dbo.product_reviews
ADD CONSTRAINT FK_product_reviews_orders
FOREIGN KEY (order_id) REFERENCES dbo.orders(order_id);
GO

ALTER TABLE dbo.wishlists
ADD CONSTRAINT FK_wishlists_users
FOREIGN KEY (user_id) REFERENCES dbo.users(user_id);
GO

ALTER TABLE dbo.wishlists
ADD CONSTRAINT FK_wishlists_products
FOREIGN KEY (product_id) REFERENCES dbo.products(product_id);
GO

ALTER TABLE dbo.voucher_users
ADD CONSTRAINT FK_voucher_users_vouchers
FOREIGN KEY (voucher_id) REFERENCES dbo.vouchers(voucher_id) ON DELETE CASCADE;
GO

ALTER TABLE dbo.voucher_users
ADD CONSTRAINT FK_voucher_users_users
FOREIGN KEY (user_id) REFERENCES dbo.users(user_id) ON DELETE CASCADE;
GO

ALTER TABLE dbo.voucher_history
ADD CONSTRAINT FK_voucher_history_vouchers
FOREIGN KEY (voucher_id) REFERENCES dbo.vouchers(voucher_id);
GO

ALTER TABLE dbo.voucher_history
ADD CONSTRAINT FK_voucher_history_users
FOREIGN KEY (user_id) REFERENCES dbo.users(user_id);
GO

ALTER TABLE dbo.voucher_history
ADD CONSTRAINT FK_voucher_history_orders
FOREIGN KEY (order_id) REFERENCES dbo.orders(order_id);
GO

ALTER TABLE dbo.coupons
ADD CONSTRAINT FK_coupons_users
FOREIGN KEY (user_id) REFERENCES dbo.users(user_id);
GO

/* =========================
   VIEWS
========================= */
CREATE VIEW dbo.vw_product_list AS
SELECT
    p.product_id,
    p.name AS product_name,
    c.name AS category_name,
    p.price,
    p.stock,
    p.image_url,
    p.is_active,
    p.created_at
FROM dbo.products p
JOIN dbo.categories c ON p.category_id = c.category_id;
GO

CREATE VIEW dbo.vw_order_summary AS
SELECT
    o.order_id,
    u.full_name AS customer_name,
    u.email,
    o.receiver_name,
    o.receiver_phone,
    o.shipping_address,
    o.payment_method,
    o.status,
    o.total_amount,
    o.created_at
FROM dbo.orders o
JOIN dbo.users u ON o.user_id = u.user_id;
GO

/* =========================
   INDEXES
========================= */
CREATE NONCLUSTERED INDEX IX_order_items_order_id   ON dbo.order_items(order_id);
GO
CREATE NONCLUSTERED INDEX IX_order_items_product_id ON dbo.order_items(product_id);
GO
CREATE NONCLUSTERED INDEX IX_orders_status          ON dbo.orders(status);
GO
CREATE NONCLUSTERED INDEX IX_orders_user_id         ON dbo.orders(user_id);
GO
CREATE NONCLUSTERED INDEX IX_products_category_id   ON dbo.products(category_id);
GO
CREATE NONCLUSTERED INDEX IX_products_is_active     ON dbo.products(is_active);
GO

/* =========================
   SAMPLE DATA: categories
========================= */
INSERT INTO dbo.categories (name, description)
VALUES
(N'Bánh Mochi', N'Các loại bánh mochi Nhật Bản'),
(N'Kẹo Nhật', N'Các loại kẹo nhập khẩu từ Nhật'),
(N'Snack', N'Các loại snack ăn vặt'),
(N'Chocolate', N'Chocolate cao cấp'),
(N'Trà & Đồ uống', N'Trà matcha và đồ uống Nhật');
GO

/* =========================
   SAMPLE DATA: users
========================= */
INSERT INTO dbo.users (email, password_hash, full_name, phone, role)
VALUES
(N'admin@mochigo.com', N'123456', N'Admin MochiGo', N'0900000000', N'ADMIN'),
(N'user1@gmail.com',   N'123456', N'Nguyễn Văn A',  N'0911111111', N'USER'),
(N'user2@gmail.com',   N'123456', N'Trần Thị B',    N'0922222222', N'USER'),
(N'user3@gmail.com',   N'123456', N'Lê Văn C',      N'0933333333', N'USER'),
(N'user4@gmail.com',   N'123456', N'Phạm Thị D',    N'0944444444', N'USER');
GO

/* =========================
   SAMPLE DATA: products
========================= */
INSERT INTO dbo.products
(category_id, name, description, price, stock, image_url, is_featured, discount_percent)
VALUES
(1, N'Mochi Matcha',        N'Mochi nhân trà xanh',                25000, 100, N'img/mochi_matcha.jpg',        1, 10),
(1, N'Mochi Dâu',           N'Mochi nhân dâu tây',                 25000, 120, N'img/mochi_strawberry.jpg',    0,  0),
(1, N'Mochi Socola',        N'Mochi nhân socola',                  26000,  80, N'img/mochi_choco.jpg',         1,  5),
(1, N'Mochi Xoài',          N'Mochi nhân xoài',                    27000,  70, N'img/mochi_mango.jpg',         0,  0),

(2, N'Kẹo Sữa Hokkaido',    N'Kẹo sữa Nhật Bản',                   35000, 200, N'img/candy_hokkaido.jpg',      0,  0),
(2, N'Kẹo Dẻo Trái Cây',    N'Kẹo dẻo mix vị trái cây',            30000, 150, N'img/candy_fruit.jpg',         0,  0),
(2, N'Kẹo Matcha',          N'Kẹo vị trà xanh Nhật',               32000, 110, N'img/candy_matcha.jpg',        0,  3),

(3, N'Snack Rong Biển',     N'Snack rong biển giòn',               20000, 180, N'img/snack_seaweed.jpg',       0,  0),
(3, N'Snack Khoai Tây',     N'Snack khoai tây Nhật',               22000, 170, N'img/snack_potato.jpg',        0,  0),
(3, N'Bánh Que Socola',     N'Bánh que phủ socola',                28000, 130, N'img/biscuit_stick.jpg',       1,  8),

(4, N'Chocolate Matcha',    N'Chocolate vị matcha',                50000,  90, N'img/choco_matcha.jpg',        1, 15),
(4, N'Chocolate Hạnh Nhân', N'Chocolate hạnh nhân',                55000,  70, N'img/choco_almond.jpg',        0,  0),
(4, N'Chocolate Dâu',       N'Chocolate vị dâu',                   48000,  85, N'img/choco_strawberry.jpg',    0,  5),

(5, N'Trà Matcha Nhật',     N'Bột matcha nguyên chất',            120000,  50, N'img/matcha.jpg',              1,  0),
(5, N'Sữa Dâu Nhật',        N'Sữa dâu nhập khẩu',                  32000,  95, N'img/strawberry_milk.jpg',     0,  0),
(5, N'Trà Sữa Matcha',      N'Trà sữa vị matcha',                  40000,  60, N'img/matcha_milk_tea.jpg',     1, 12);
GO