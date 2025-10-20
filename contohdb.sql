-- Buat database dan gunakan
CREATE DATABASE contohdb;
USE contohdb;

-- Buat tabel MHS
CREATE TABLE MHS (
    NIM VARCHAR(10) PRIMARY KEY,
    NAMA VARCHAR(20)
);

-- Insert data
INSERT INTO MHS VALUES ('2025071012', 'Ratna');
INSERT INTO MHS VALUES ('2025071013', '123456789012345');
INSERT INTO MHS VALUES ('2025071014', 'Ratna');

-- Lihat isi tabel
SELECT * FROM MHS;

-- Ubah tipe panjang kolom NAMA
ALTER TABLE MHS MODIFY NAMA VARCHAR(15);

-- Update data
UPDATE MHS SET NAMA = '123456789'
WHERE NIM = '2025071013';

-- Tambah data
INSERT INTO MHS VALUES ('2025071015', 'Dewi');

-- Ganti nama tabel
RENAME TABLE MHS TO mahasiswaa;

-- Tambah kolom dan index
ALTER TABLE mahasiswaa ADD alamat VARCHAR(50);
ALTER TABLE mahasiswaa ADD INDEX index_nama (NAMA);

-- Tambah data baru
INSERT INTO mahasiswaa VALUES ('2025071016', 'Enam Belas', NULL);

-- Update alamat ratna pertama
UPDATE mahasiswa 
SET alamat = 'Alamat Ratna' 
WHERE nim = '2025071012';

-- Update alamat Ratna kedua
UPDATE mahasiswa
SET alamat = 'Jalan Cendrawasih'
WHERE nim = '2025071014';

-- Update seluruh baris (aktifkan SQL_SAFE_UPDATES)
SET SQL_SAFE_UPDATES = 0;
UPDATE mahasiswa SET alamat = 'Alamat Baru' WHERE nim IS NOT NULL;
SET SQL_SAFE_UPDATES = 1;

-- Tampilkan index
SHOW INDEX FROM mahasiswa;

-- Hapus index
DROP INDEX index_nama ON mahasiswaa;

-- Buat stored procedure
DELIMITER //
CREATE PROCEDURE TampilkanSeluruhDataMahasiswa()
BEGIN
	SELECT * FROM mahasiswa;
END //
DELIMITER ;

-- Jalankan procedure
CALL TampilkanSeluruhDataMahasiswa();

-- Buat view
CREATE VIEW mahasiswaa2 AS
SELECT * FROM mahasiswaa
ORDER BY nama;

-- Cek isi view
SELECT * FROM mahasiswa2;

-- hapus table dan database
-- 1. Pastikan berada di server yang benar
SHOW DATABASES;

-- 2. Hapus view dan tabel
USE contohdb;
DROP VIEW IF EXISTS mahasiswa2;
DROP TABLE IF EXISTS mahasiswaa;

-- 3. Hapus seluruh database
DROP DATABASE IF EXISTS contohdb;

