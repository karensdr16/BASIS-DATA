
CREATE DATABASE IF NOT EXISTS mahasiswa;
USE mahasiswa;


-- PRAKTIKUM 1 : Tabel Jurusan dan Biodata, INSERT, UPDATE

CREATE TABLE IF NOT EXISTS jurusan (
  kd_jurusan VARCHAR(10) PRIMARY KEY,
  nama_jurusan VARCHAR(100),
  ketua VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS biodata (
  no_mahasiswa VARCHAR(20) PRIMARY KEY,
  kd_jurusan VARCHAR(10),
  nama_mahasiswa VARCHAR(255),
  alamat VARCHAR(255),
  ipk DECIMAL(3,1),
  FOREIGN KEY (kd_jurusan) REFERENCES jurusan(kd_jurusan)
    ON UPDATE CASCADE ON DELETE SET NULL
);

INSERT INTO jurusan VALUES
('KD01','Sistem Informasi','Harnaningrum,S.Si'),
('KD02','Teknik Informatika','EnnySela,S.Kom.,M.Kom'),
('KD03','Teknik Komputer','Berta Bednar,S.Si,M.T.')
ON DUPLICATE KEY UPDATE nama_jurusan=VALUES(nama_jurusan);

INSERT INTO biodata VALUES
('210089','KD01','Rina Gunawan','Denpasar',3.0),
('210090','KD03','Gani Suprapto','Singaraja',3.5),
('210012','KD02','Alexandra','Nusa dua',3.0),
('210099','KD02','Nadine','Gianyar',3.2),
('210002','KD01','Rizal Samurai','Denpasar',3.7)
ON DUPLICATE KEY UPDATE nama_mahasiswa=VALUES(nama_mahasiswa);

-- Insert data baru
INSERT INTO biodata VALUES ('210100','KD04','Nama Baru','Alamat Baru',3.1)
ON DUPLICATE KEY UPDATE nama_mahasiswa=VALUES(nama_mahasiswa);

-- Update data
UPDATE biodata SET nama_mahasiswa='Rina Gunawan Astuti' WHERE nama_mahasiswa='Rina Gunawan';
UPDATE jurusan SET kd_jurusan='KM01' WHERE kd_jurusan='KD01';
UPDATE biodata SET no_mahasiswa='210098' WHERE no_mahasiswa='210089';
UPDATE biodata SET ipk=3.3 WHERE ipk=3.0;
UPDATE biodata SET kd_jurusan='KD05' WHERE kd_jurusan='KD03';


-- PRAKTIKUM 2 : JOIN

SELECT b.no_mahasiswa, b.nama_mahasiswa, j.nama_jurusan
FROM biodata b CROSS JOIN jurusan j;

SELECT b.no_mahasiswa, b.nama_mahasiswa, j.nama_jurusan
FROM biodata b
INNER JOIN jurusan j ON b.kd_jurusan=j.kd_jurusan;

SELECT b.no_mahasiswa, b.nama_mahasiswa, j.nama_jurusan
FROM biodata b
LEFT JOIN jurusan j ON b.kd_jurusan=j.kd_jurusan;

SELECT b.no_mahasiswa, b.nama_mahasiswa, j.nama_jurusan
FROM biodata b
RIGHT JOIN jurusan j ON b.kd_jurusan=j.kd_jurusan;


-- PRAKTIKUM 3 : Single Row Functions

SELECT LOWER(nama_mahasiswa) FROM biodata;
SELECT UPPER(nama_mahasiswa) FROM biodata;
SELECT SUBSTRING(nama_mahasiswa,2,5) FROM biodata;
SELECT LTRIM('   contoh'), RTRIM('contoh   ');
SELECT RIGHT(nama_mahasiswa,3), LEFT(nama_mahasiswa,3) FROM biodata;
SELECT nama_mahasiswa, LENGTH(nama_mahasiswa) FROM biodata;
SELECT nama_mahasiswa, REVERSE(nama_mahasiswa) FROM biodata;
SELECT CONCAT('A',SPACE(5),'B');


-- PRAKTIKUM 4 : Aggregate, ORDER BY, GROUP BY, HAVING

SELECT AVG(ipk) AS rata_ipk FROM biodata;
SELECT COUNT(*) AS jumlah_mhs FROM biodata;
SELECT MAX(ipk) AS ipk_max, MIN(ipk) AS ipk_min FROM biodata;

SELECT b.kd_jurusan, COUNT(*) AS jumlah
FROM biodata b
GROUP BY b.kd_jurusan
HAVING COUNT(*)>1
ORDER BY jumlah DESC;


-- PRAKTIKUM 5 : Subquery dan UNION

SELECT no_mahasiswa, nama_mahasiswa, ipk FROM biodata WHERE ipk=(SELECT MAX(ipk) FROM biodata);
SELECT no_mahasiswa, nama_mahasiswa FROM biodata
WHERE kd_jurusan IN (SELECT kd_jurusan FROM jurusan WHERE ketua LIKE '%Harnaningrum%');


-- PRAKTIKUM 6 : VIEW, Variables, Control Flow

CREATE OR REPLACE VIEW laporan_mahasiswa AS
SELECT b.no_mahasiswa,b.nama_mahasiswa,j.nama_jurusan
FROM biodata b LEFT JOIN jurusan j ON b.kd_jurusan=j.kd_jurusan;

SET @t1=1,@t2=2,@t3:=4;
SELECT @t1,@t2,@t3,@t4:=@t1+@t2+@t3;

SELECT IF(ipk>=3.5,'Cumlaude','Biasa') FROM biodata;
SELECT IFNULL((SELECT nama_jurusan FROM jurusan WHERE kd_jurusan='KD99'),'Tidak Ditemukan');

CREATE TEMPORARY TABLE tmp_high_ipk AS SELECT * FROM biodata WHERE ipk>=3.5;
SELECT * FROM tmp_high_ipk;


-- PRAKTIKUM 7 : FUNCTION, PROCEDURE, TRIGGER

DELIMITER $$
CREATE FUNCTION tambah(a INT,b INT) RETURNS INT DETERMINISTIC BEGIN RETURN a+b; END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_mahasiswa_by_ketua(IN p_ketua VARCHAR(255))
BEGIN
  SELECT b.no_mahasiswa,b.nama_mahasiswa,j.nama_jurusan,j.ketua
  FROM biodata b JOIN jurusan j ON b.kd_jurusan=j.kd_jurusan
  WHERE j.ketua LIKE CONCAT('%',p_ketua,'%');
END$$
DELIMITER ;

CREATE TABLE IF NOT EXISTS log_ipk(
 id INT AUTO_INCREMENT PRIMARY KEY,
 no_mahasiswa VARCHAR(20),
 ipk_lama DECIMAL(3,1),
 ipk_baru DECIMAL(3,1),
 changed_at DATETIME
);

DELIMITER $$
CREATE TRIGGER trg_update_ipk AFTER UPDATE ON biodata
FOR EACH ROW
BEGIN
  IF NEW.ipk<>OLD.ipk THEN
    INSERT INTO log_ipk(no_mahasiswa,ipk_lama,ipk_baru,changed_at)
    VALUES(OLD.no_mahasiswa,OLD.ipk,NEW.ipk,NOW());
  END IF;
END$$
DELIMITER ;

