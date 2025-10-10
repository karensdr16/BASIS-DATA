CREATE DATABASE IF NOT EXISTS toko_kue;
USE toko_kue;

-- TABEL 1: PELANGGAN
-- Menyimpan data pelanggan termasuk nomor telepon
CREATE TABLE pelanggan (
    id_pelanggan INT PRIMARY KEY AUTO_INCREMENT,
    nama_pelanggan VARCHAR(100) NOT NULL,
    nomor_telepon VARCHAR(15) NOT NULL,  -- Nomor telepon pelanggan
    email VARCHAR(100),
    tanggal_daftar DATETIME DEFAULT CURRENT_TIMESTAMP
);
DROP TABLE IF EXISTS detail_pesanan;
DROP TABLE IF EXISTS pesanan;
DROP TABLE IF EXISTS alamat_pengiriman;
DROP TABLE IF EXISTS produk_kue;
DROP TABLE IF EXISTS pelanggan;
-- TABEL 1: PELANGGAN
-- Menyimpan data pelanggan termasuk nomor telepon
CREATE TABLE pelanggan (
    id_pelanggan INT PRIMARY KEY AUTO_INCREMENT,
    nama_pelanggan VARCHAR(100) NOT NULL,
    nomor_telepon VARCHAR(15) NOT NULL,  -- Nomor telepon pelanggan
    email VARCHAR(100),
    tanggal_daftar DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- TABEL 2: ALAMAT PENGIRIMAN
-- Menyimpan alamat lengkap pengiriman kue
CREATE TABLE alamat_pengiriman (
    id_alamat INT PRIMARY KEY AUTO_INCREMENT,
    id_pelanggan INT NOT NULL,
    alamat_lengkap TEXT NOT NULL,        -- Alamat lengkap pengiriman
    kecamatan VARCHAR(50),
    kota VARCHAR(50) NOT NULL,           -- Kota tujuan pengiriman
    kode_pos VARCHAR(10),
    catatan_alamat TEXT,                 -- Catatan tambahan untuk alamat (patokan, dll)
    FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan)
);

-- TABEL 3: PRODUK KUE
-- Menyimpan daftar kue yang dijual beserta harga
CREATE TABLE produk_kue (
    id_produk INT PRIMARY KEY AUTO_INCREMENT,
    nama_kue VARCHAR(100) NOT NULL,
    kategori VARCHAR(50),                -- Kategori: Birthday Cake, Cupcake, Brownies, dll
    harga DECIMAL(10,2) NOT NULL,        -- Harga kue dalam rupiah
    deskripsi TEXT,
    stok INT DEFAULT 0,                  -- Jumlah stok tersedia
    status_tersedia BOOLEAN DEFAULT TRUE
);

-- TABEL 4: PESANAN
-- Menyimpan informasi pesanan utama
CREATE TABLE pesanan (
    id_pesanan INT PRIMARY KEY AUTO_INCREMENT,
    id_pelanggan INT NOT NULL,
    id_alamat INT NOT NULL,              -- Alamat kemana kue akan dikirim
    tanggal_pesan DATETIME DEFAULT CURRENT_TIMESTAMP,
    tanggal_pengiriman DATETIME,             -- Tanggal dan waktu pengiriman kue
    total_harga DECIMAL(10,2) NOT NULL,  -- Total harga pesanan
    status_pesanan VARCHAR(20) DEFAULT 'Pending', -- Status: Pending, Diproses, Dikirim, Selesai, Dibatalkan
    metode_pembayaran VARCHAR(30),       -- Transfer, COD, E-wallet, dll
    catatan_pesanan TEXT,                -- Catatan khusus dari pelanggan
    FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan),
    FOREIGN KEY (id_alamat) REFERENCES alamat_pengiriman(id_alamat)
);

-- TABEL 5: DETAIL PESANAN
-- Menyimpan item-item apa saja yang dipesan
CREATE TABLE detail_pesanan (
    id_detail INT PRIMARY KEY AUTO_INCREMENT,
    id_pesanan INT NOT NULL,
    id_produk INT NOT NULL,              -- Kue apa yang dipesan
    jumlah INT NOT NULL,                 -- Jumlah item yang dipesan
    harga_satuan DECIMAL(10,2) NOT NULL, -- Harga per item saat pemesanan
    subtotal DECIMAL(10,2) NOT NULL,     -- Total harga untuk item ini (jumlah x harga_satuan)
    catatan_item TEXT,                   -- Catatan khusus: tulisan di kue, request khusus, dll
    FOREIGN KEY (id_pesanan) REFERENCES pesanan(id_pesanan),
    FOREIGN KEY (id_produk) REFERENCES produk_kue(id_produk)
);

-- DATA CONTOH: PELANGGAN
-- Memasukkan data pelanggan contoh
INSERT INTO pelanggan (nama_pelanggan, nomor_telepon, email) VALUES
('Budi Santoso', '081234567890', 'budi@email.com'),
('Siti Aminah', '082345678901', 'siti@email.com'),
('Ahmad Rizki', '083456789012', 'ahmad@email.com'),
('Dewi Lestari', '084567890123', 'dewi@email.com');

-- DATA CONTOH: PRODUK KUE DENGAN HARGA
-- Memasukkan berbagai jenis kue dengan harga

-- Birthday Cake (Kue Ulang Tahun)
INSERT INTO produk_kue (nama_kue, kategori, harga, deskripsi, stok) VALUES
('Kue Ulang Tahun Coklat', 'Birthday Cake', 250000, 'Kue coklat 3 lapis dengan buttercream', 5),
('Kue Ulang Tahun Red Velvet', 'Birthday Cake', 300000, 'Kue red velvet dengan cream cheese frosting', 3),
('Kue Ulang Tahun Rainbow', 'Birthday Cake', 350000, 'Kue pelangi 3 lapis dengan buttercream warna-warni', 2),
('Kue Ulang Tahun Vanilla', 'Birthday Cake', 240000, 'Kue vanilla klasik dengan buttercream', 4);

-- Cupcake
INSERT INTO produk_kue (nama_kue, kategori, harga, deskripsi, stok) VALUES
('Cupcake Vanilla', 'Cupcake', 5000, 'Cupcake vanilla dengan topping cream cheese', 50),
('Cupcake Coklat', 'Cupcake', 5500, 'Cupcake coklat dengan topping ganache', 45),
('Cupcake Red Velvet', 'Cupcake', 6000, 'Cupcake red velvet dengan cream cheese', 40),
('Cupcake Matcha', 'Cupcake', 6500, 'Cupcake green tea dengan topping buttercream', 30);

-- Brownies
INSERT INTO produk_kue (nama_kue, kategori, harga, deskripsi, stok) VALUES
('Brownies Panggang', 'Brownies', 75000, 'Brownies coklat panggang ukuran 20x20', 10),
('Brownies Kukus', 'Brownies', 65000, 'Brownies coklat kukus ukuran 20x20', 15),
('Brownies Keju', 'Brownies', 80000, 'Brownies dengan topping keju premium', 8);

-- Tart
INSERT INTO produk_kue (nama_kue, kategori, harga, deskripsi, stok) VALUES
('Tart Buah', 'Tart', 180000, 'Tart dengan topping buah segar', 8),
('Tart Coklat', 'Tart', 200000, 'Tart coklat dengan ganache dan choco chips', 6),
('Tart Keju', 'Tart', 190000, 'Tart dengan topping keju leleh', 7);

-- Kue Tradisional & Kue Kering
INSERT INTO produk_kue (nama_kue, kategori, harga, deskripsi, stok) VALUES
('Kue Lapis Legit', 'Kue Tradisional', 150000, 'Kue lapis legit premium 18 lapis', 4),
('Nastar Premium', 'Kue Kering', 85000, 'Nastar isi nanas per toples (500gr)', 20),
('Putri Salju', 'Kue Kering', 80000, 'Kue putri salju per toples (500gr)', 25),
('Kastengel Keju', 'Kue Kering', 90000, 'Kastengel keju premium per toples (500gr)', 18);

-- Cheese Cake
INSERT INTO produk_kue (nama_kue, kategori, harga, deskripsi, stok) VALUES
('Cheese Cake Original', 'Cheese Cake', 120000, 'Cheese cake lembut ukuran 18cm', 7),
('Tiramisu Cake', 'Cheese Cake', 140000, 'Tiramisu dengan mascarpone cheese', 5),
('Cheese Cake Bluberry', 'Cheese Cake', 135000, 'Cheese cake dengan topping blueberry', 6);

-- DATA CONTOH: ALAMAT PENGIRIMAN
-- Memasukkan alamat pengiriman pelanggan
INSERT INTO alamat_pengiriman (id_pelanggan, alamat_lengkap, kecamatan, kota, kode_pos, catatan_alamat) VALUES
(1, 'Jl. Merpati No. 15', 'Kebayoran Baru', 'Jakarta Selatan', '12345', 'Rumah cat hijau, depan minimarket'),
(2, 'Jl. Anggrek Raya No. 88 Blok A5', 'Cengkareng', 'Jakarta Barat', '11730', 'Komplek Perumahan Anggrek Residence'),
(3, 'Jl. Melati No. 99', 'Tebet', 'Jakarta Selatan', '12820', 'Sebelah kantor pos'),
(4, 'Jl. Mawar Indah No. 45', 'Kelapa Gading', 'Jakarta Utara', '14240', 'Ruko warna putih');

-- DATA CONTOH: PESANAN
-- Memasukkan contoh pesanan

-- Pesanan 1: Budi pesan kue ulang tahun dan cupcake
INSERT INTO pesanan (id_pelanggan, id_alamat, tanggal_pengiriman, total_harga, status_pesanan, metode_pembayaran, catatan_pesanan) 
VALUES (1, 1, '2025-10-05 09:00:00', 265000, 'Diproses', 'Transfer Bank', 'Mohon dikirim pagi hari');

-- Detail item pesanan 1
INSERT INTO detail_pesanan (id_pesanan, id_produk, jumlah, harga_satuan, subtotal, catatan_item) VALUES
(1, 1, 1, 250000, 250000, 'Tulisan: Happy Birthday Mom, warna pink'),
(1, 5, 3, 5000, 15000, NULL);

-- Pesanan 2: Siti pesan nastar
INSERT INTO pesanan (id_pelanggan, id_alamat, tanggal_pengiriman, total_harga, status_pesanan, metode_pembayaran) 
VALUES (2, 2, '2025-10-03 14:00:00', 85000, 'Dikirim', 'COD');

-- Detail item pesanan 2
INSERT INTO detail_pesanan (id_pesanan, id_produk, jumlah, harga_satuan, subtotal) VALUES
(2, 16, 1, 85000, 85000);

-- Pesanan 3: Ahmad pesan brownies dan cupcake
INSERT INTO pesanan (id_pelanggan, id_alamat, tanggal_pengiriman, total_harga, status_pesanan, metode_pembayaran, catatan_pesanan) 
VALUES (3, 3, '2025-10-04 16:30:00', 111000, 'Pending', 'E-wallet', 'Tolong dipacking rapi');

-- Detail item pesanan 3
INSERT INTO detail_pesanan (id_pesanan, id_produk, jumlah, harga_satuan, subtotal, catatan_item) VALUES
(3, 9, 1, 75000, 75000, NULL),
(3, 6, 6, 6000, 36000, 'Mix varian');

-- VIEW: PESANAN LENGKAP
-- Melihat pesanan dengan detail pelanggan dan alamat
CREATE OR REPLACE VIEW view_pesanan_lengkap AS
SELECT 
    p.id_pesanan,
    p.tanggal_pesan,
    p.tanggal_pengiriman,
    pel.nama_pelanggan,
    pel.nomor_telepon,              -- Nomor telepon pelanggan
    a.alamat_lengkap,               -- Alamat pengiriman
    a.kota,
    p.total_harga,
    p.status_pesanan,
    p.metode_pembayaran
FROM pesanan p
JOIN pelanggan pel ON p.id_pelanggan = pel.id_pelanggan
JOIN alamat_pengiriman a ON p.id_alamat = a.id_alamat;

-- VIEW: DETAIL PESANAN LENGKAP
-- Melihat item-item dalam setiap pesanan
CREATE OR REPLACE VIEW view_detail_pesanan_lengkap AS
SELECT 
    d.id_pesanan,
    k.nama_kue,                     -- Nama kue yang dipesan
    k.kategori,
    d.jumlah,                       -- Jumlah item
    d.harga_satuan,                 -- Harga per item
    d.subtotal,                     -- Total harga item
    d.catatan_item                  -- Catatan khusus item
FROM detail_pesanan d
JOIN produk_kue k ON d.id_produk = k.id_produk;

-- MENAMPILKAN ISI SEMUA TABEL

-- Menampilkan semua data pelanggan
SELECT '=== DATA PELANGGAN ===' AS Info;
SELECT * FROM pelanggan;

-- Menampilkan semua data produk kue dengan harga
SELECT '=== DATA PRODUK KUE DAN HARGA ===' AS Info;
SELECT id_produk, nama_kue, kategori, harga, stok, status_tersedia 
FROM produk_kue 
ORDER BY kategori, harga;

-- Menampilkan semua alamat pengiriman
SELECT '=== DATA ALAMAT PENGIRIMAN ===' AS Info;
SELECT 
    a.id_alamat,
    p.nama_pelanggan,
    a.alamat_lengkap,
    a.kecamatan,
    a.kota,
    a.kode_pos,
    a.catatan_alamat
FROM alamat_pengiriman a
JOIN pelanggan p ON a.id_pelanggan = p.id_pelanggan;

-- Menampilkan semua pesanan
SELECT * FROM view_pesanan_lengkap ORDER BY tanggal_pesan DESC;

-- Menampilkan detail item pesanan
SELECT * FROM view_detail_pesanan_lengkap;

-- Laporan penjualan per kategori
SELECT '=== LAPORAN PENJUALAN PER KATEGORI ===' AS Info;
SELECT 
    k.kategori,
    COUNT(d.id_detail) as total_item_terjual,
    SUM(d.subtotal) as total_pendapatan
FROM detail_pesanan d
JOIN produk_kue k ON d.id_produk = k.id_produk
JOIN pesanan p ON d.id_pesanan = p.id_pesanan
WHERE p.status_pesanan != 'Dibatalkan'
GROUP BY k.kategori
ORDER BY total_pendapatan DESC;

-- Cek stok kue yang hampir habis (stok < 10)
SELECT '=== STOK KUE YANG HAMPIR HABIS ===' AS Info;
SELECT nama_kue, kategori, stok, harga 
FROM produk_kue 
WHERE stok < 10 
ORDER BY stok ASC;

-- STORED PROCEDURES

-- 1. TAMBAH PELANGGAN BARU
DELIMITER //
CREATE PROCEDURE sp_tambah_pelanggan(
    IN p_nama VARCHAR(100),
    IN p_telepon VARCHAR(15),
    IN p_email VARCHAR(100)
)
BEGIN
    INSERT INTO pelanggan (nama_pelanggan, nomor_telepon, email) 
    VALUES (p_nama, p_telepon, p_email);
    SELECT LAST_INSERT_ID() AS id_baru;
END //
DELIMITER ;


-- 2. TAMBAH PRODUK KUE BARU
DELIMITER //
CREATE PROCEDURE sp_tambah_produk(
    IN p_nama_kue VARCHAR(100),
    IN p_kategori VARCHAR(50),
    IN p_harga DECIMAL(10,2),
    IN p_deskripsi TEXT,
    IN p_stok INT
)
BEGIN
    INSERT INTO produk_kue (nama_kue, kategori, harga, deskripsi, stok) 
    VALUES (p_nama_kue, p_kategori, p_harga, p_deskripsi, p_stok);
    SELECT LAST_INSERT_ID() AS id_baru;
END //
DELIMITER ;

-- 3. TAMBAH ALAMAT PENGIRIMAN
DELIMITER //
CREATE PROCEDURE sp_tambah_alamat(
    IN p_id_pelanggan INT,
    IN p_alamat TEXT,
    IN p_kecamatan VARCHAR(50),
    IN p_kota VARCHAR(50),
    IN p_kode_pos VARCHAR(10),
    IN p_catatan TEXT
)
BEGIN
    INSERT INTO alamat_pengiriman (id_pelanggan, alamat_lengkap, kecamatan, kota, kode_pos, catatan_alamat) 
    VALUES (p_id_pelanggan, p_alamat, p_kecamatan, p_kota, p_kode_pos, p_catatan);
    SELECT LAST_INSERT_ID() AS id_baru;
END //
DELIMITER ;

-- 4. BUAT PESANAN BARU
DELIMITER //
CREATE PROCEDURE sp_buat_pesanan(
    IN p_id_pelanggan INT,
    IN p_id_alamat INT,
    IN p_tanggal_kirim DATETIME,
    IN p_metode_bayar VARCHAR(30),
    IN p_catatan TEXT
)
BEGIN
    INSERT INTO pesanan (id_pelanggan, id_alamat, tanggal_pengiriman, total_harga, metode_pembayaran, catatan_pesanan) 
    VALUES (p_id_pelanggan, p_id_alamat, p_tanggal_kirim, 0, p_metode_bayar, p_catatan);
    SELECT LAST_INSERT_ID() AS id_pesanan_baru;
END //
DELIMITER ;

-- 5. TAMBAH ITEM PESANAN
DELIMITER //
CREATE PROCEDURE sp_tambah_item_pesanan(
    IN p_id_pesanan INT,
    IN p_id_produk INT,
    IN p_jumlah INT,
    IN p_catatan TEXT
)
BEGIN
    DECLARE v_harga DECIMAL(10,2);
    DECLARE v_subtotal DECIMAL(10,2);
    
    SELECT harga INTO v_harga FROM produk_kue WHERE id_produk = p_id_produk;
    SET v_subtotal = v_harga * p_jumlah;
    
    INSERT INTO detail_pesanan (id_pesanan, id_produk, jumlah, harga_satuan, subtotal, catatan_item) 
    VALUES (p_id_pesanan, p_id_produk, p_jumlah, v_harga, v_subtotal, p_catatan);
    
    UPDATE pesanan SET total_harga = (
        SELECT SUM(subtotal) FROM detail_pesanan WHERE id_pesanan = p_id_pesanan
    ) WHERE id_pesanan = p_id_pesanan;
    
    SELECT LAST_INSERT_ID() AS id_detail_baru;
END //
DELIMITER ;


-- 6. UPDATE STATUS PESANAN
DELIMITER //
CREATE PROCEDURE sp_update_status_pesanan(
    IN p_id_pesanan INT,
    IN p_status VARCHAR(20)
)
BEGIN
    UPDATE pesanan SET status_pesanan = p_status WHERE id_pesanan = p_id_pesanan;
    SELECT 'Status updated' AS hasil;
END //
DELIMITER ;


-- 7. UPDATE STOK PRODUK
DELIMITER //
CREATE PROCEDURE sp_update_stok(
    IN p_id_produk INT,
    IN p_stok_baru INT
)
BEGIN
    UPDATE produk_kue SET stok = p_stok_baru WHERE id_produk = p_id_produk;
    SELECT 'Stok updated' AS hasil;
END //
DELIMITER ;


-- 8. LAPORAN PENJUALAN HARIAN
DELIMITER //
CREATE PROCEDURE sp_laporan_harian(IN p_tanggal DATE)
BEGIN
    SELECT 
        k.kategori,
        COUNT(d.id_detail) AS total_item,
        SUM(d.subtotal) AS total_penjualan
    FROM detail_pesanan d
    JOIN produk_kue k ON d.id_produk = k.id_produk
    JOIN pesanan p ON d.id_pesanan = p.id_pesanan
    WHERE DATE(p.tanggal_pesan) = p_tanggal
      AND p.status_pesanan != 'Dibatalkan'
    GROUP BY k.kategori
    ORDER BY total_penjualan DESC;
END //
DELIMITER ;


-- 9. CEK STOK MENIPIS
-- 9. CEK STOK MENIPIS
-- 9. CEK STOK MENIPIS
DELIMITER //

CREATE PROCEDURE sp_cek_stok_menipis()
BEGIN
    SELECT nama_kue, kategori, stok, harga
    FROM produk_kue
    WHERE stok < 10
    ORDER BY stok ASC;
END //

DELIMITER ;

-- 10. RIWAYAT PESANAN PELANGGAN
DELIMITER //

CREATE PROCEDURE sp_riwayat_pelanggan_v2(IN p_id_pelanggan INT)
BEGIN
    SELECT *
    FROM view_pesanan_lengkap
    WHERE id_pelanggan = p_id_pelanggan
    ORDER BY tanggal_pesan DESC;
END //

DELIMITER ;