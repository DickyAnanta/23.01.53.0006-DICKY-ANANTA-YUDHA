-- ============================================================
-- DATABASE: db_pariwisata
-- ============================================================

CREATE DATABASE IF NOT EXISTS db_pariwisata;
USE db_pariwisata;

-- ============================================================
-- 1️⃣ Tabel: users (akun pengunjung / admin)
-- ============================================================
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(100) NOT NULL,
  role ENUM('admin','user') DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (nama, email, password, role) VALUES
('Admin', 'admin@pariwisata.id', 'admin123', 'admin'),
('Dicky Ananta', 'dicky@user.com', '12345', 'user');

-- ============================================================
-- 2️⃣ Tabel: kategori_wisata
-- ============================================================
CREATE TABLE kategori_wisata (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama_kategori VARCHAR(100) NOT NULL,
  deskripsi TEXT
);

INSERT INTO kategori_wisata (nama_kategori, deskripsi) VALUES
('Pantai', 'Objek wisata yang berlokasi di tepi laut'),
('Gunung', 'Wisata alam pegunungan'),
('Kota', 'Destinasi wisata perkotaan'),
('Budaya', 'Wisata seni dan budaya lokal');

-- ============================================================
-- 3️⃣ Tabel: wisata
-- ============================================================
CREATE TABLE wisata (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_kategori INT,
  nama_wisata VARCHAR(150) NOT NULL,
  lokasi VARCHAR(150),
  deskripsi TEXT,
  gambar VARCHAR(150),
  rating DECIMAL(2,1) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_kategori) REFERENCES kategori_wisata(id) ON DELETE SET NULL
);

INSERT INTO wisata (id_kategori, nama_wisata, lokasi, deskripsi, gambar, rating) VALUES
(1, 'Pantai Kartini', 'Jepara, Jawa Tengah', 'Pantai populer di Jepara dengan pemandangan laut yang indah.', 'kartini.jpg', 4.5),
(2, 'Gunung Merbabu', 'Magelang, Jawa Tengah', 'Gunung favorit pendaki dengan pemandangan indah.', 'merbabu.jpg', 4.7),
(3, 'Kota Lama Semarang', 'Semarang, Jawa Tengah', 'Destinasi wisata bersejarah peninggalan Belanda.', 'kotalama.jpg', 4.4),
(4, 'Candi Borobudur', 'Magelang, Jawa Tengah', 'Candi Buddha terbesar di dunia dan warisan dunia UNESCO.', 'borobudur.jpg', 5.0);

-- ============================================================
-- 4️⃣ Tabel: hotel
-- ============================================================
CREATE TABLE hotel (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_wisata INT,
  nama_hotel VARCHAR(150),
  alamat VARCHAR(200),
  harga_per_malam DECIMAL(10,2),
  kontak VARCHAR(50),
  FOREIGN KEY (id_wisata) REFERENCES wisata(id) ON DELETE CASCADE
);

INSERT INTO hotel (id_wisata, nama_hotel, alamat, harga_per_malam, kontak) VALUES
(1, 'Hotel Kartini Beach', 'Jl. Pantai Kartini No.5 Jepara', 450000, '0291-123456'),
(3, 'Hotel Semarang Indah', 'Jl. Pemuda No.45 Semarang', 500000, '024-654321');

-- ============================================================
-- 5️⃣ Tabel: kuliner
-- ============================================================
CREATE TABLE kuliner (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_wisata INT,
  nama_kuliner VARCHAR(100),
  deskripsi TEXT,
  harga DECIMAL(10,2),
  gambar VARCHAR(100),
  FOREIGN KEY (id_wisata) REFERENCES wisata(id) ON DELETE CASCADE
);

INSERT INTO kuliner (id_wisata, nama_kuliner, deskripsi, harga, gambar) VALUES
(1, 'Pindang Serani', 'Sup ikan khas Jepara yang segar dan pedas.', 25000, 'pindang.jpg'),
(3, 'Lumpia Semarang', 'Camilan khas kota Semarang berisi rebung dan telur.', 15000, 'lumpia.jpg');

-- ============================================================
-- 6️⃣ Tabel: transportasi
-- ============================================================
CREATE TABLE transportasi (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_wisata INT,
  jenis VARCHAR(50),
  nama_operator VARCHAR(100),
  tarif DECIMAL(10,2),
  kontak VARCHAR(50),
  FOREIGN KEY (id_wisata) REFERENCES wisata(id) ON DELETE CASCADE
);

INSERT INTO transportasi (id_wisata, jenis, nama_operator, tarif, kontak) VALUES
(1, 'Kapal', 'Ferry Jepara-Karimunjawa', 120000, '08123456789'),
(2, 'Bus', 'PO Gunung Jaya', 80000, '0811112233');

-- ============================================================
-- 7️⃣ Tabel: ulasan
-- ============================================================
CREATE TABLE ulasan (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_user INT,
  id_wisata INT,
  rating INT CHECK (rating BETWEEN 1 AND 5),
  komentar TEXT,
  tanggal TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_user) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (id_wisata) REFERENCES wisata(id) ON DELETE CASCADE
);

INSERT INTO ulasan (id_user, id_wisata, rating, komentar) VALUES
(2, 1, 5, 'Pantainya bersih dan indah!'),
(2, 3, 4, 'Tempatnya bersejarah dan keren.');

-- ============================================================
-- 8️⃣ Tabel: galeri
-- ============================================================
CREATE TABLE galeri (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_wisata INT,
  file_gambar VARCHAR(100),
  keterangan TEXT,
  FOREIGN KEY (id_wisata) REFERENCES wisata(id) ON DELETE CASCADE
);

INSERT INTO galeri (id_wisata, file_gambar, keterangan) VALUES
(1, 'pantai1.jpg', 'Pemandangan sunset di Pantai Kartini'),
(3, 'kotalama1.jpg', 'Bangunan bersejarah Belanda');

-- ============================================================
-- 9️⃣ Tabel: event
-- ============================================================
CREATE TABLE event (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_wisata INT,
  nama_event VARCHAR(100),
  tanggal DATE,
  deskripsi TEXT,
  FOREIGN KEY (id_wisata) REFERENCES wisata(id) ON DELETE CASCADE
);

INSERT INTO event (id_wisata, nama_event, tanggal, deskripsi) VALUES
(1, 'Festival Kartini', '2025-04-21', 'Festival tahunan memperingati hari Kartini di Jepara'),
(3, 'Semarang Night Carnival', '2025-09-10', 'Karnaval malam bertema budaya lokal');

-- ============================================================
-- 🔟 Tabel: favorit
-- ============================================================
CREATE TABLE favorit (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_user INT,
  id_wisata INT,
  tanggal TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_user) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (id_wisata) REFERENCES wisata(id) ON DELETE CASCADE
);

INSERT INTO favorit (id_user, id_wisata) VALUES
(2, 1),
(2, 3);
