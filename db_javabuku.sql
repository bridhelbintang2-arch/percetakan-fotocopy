-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 14 Jul 2026 pada 03.28
-- Versi server: 10.4.22-MariaDB
-- Versi PHP: 7.3.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_javabuku`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `buku`
--

CREATE TABLE `buku` (
  `kd_buku` varchar(10) NOT NULL,
  `judul` varchar(50) NOT NULL,
  `jenis` varchar(10) NOT NULL,
  `penulis` varchar(50) NOT NULL,
  `penerbit` varchar(50) NOT NULL,
  `tahun` varchar(4) NOT NULL,
  `stok` int(3) NOT NULL,
  `harga_pokok` int(5) NOT NULL,
  `harga_jual` int(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `buku`
--

INSERT INTO `buku` (`kd_buku`, `judul`, `jenis`, `penulis`, `penerbit`, `tahun`, `stok`, `harga_pokok`, `harga_jual`) VALUES
('K0001', 'cintaku', 'Novel', 'dwew', 'sqwq', '2000', 54, 20000, 20000);

-- --------------------------------------------------------

--
-- Struktur dari tabel `distributor`
--

CREATE TABLE `distributor` (
  `kd_distributor` varchar(10) NOT NULL,
  `nama_distributor` varchar(50) NOT NULL,
  `alamat` varchar(100) NOT NULL,
  `telepon` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `login`
--

CREATE TABLE `login` (
  `nama` varchar(20) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `login`
--

INSERT INTO `login` (`nama`, `username`, `password`) VALUES
('Zhafari Irsyad', 'admin', 'admin');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pelanggan`
--

CREATE TABLE `pelanggan` (
  `kd_pelanggan` varchar(10) NOT NULL,
  `nama_pelanggan` varchar(50) NOT NULL,
  `jenis_kelamin` varchar(1) NOT NULL,
  `alamat` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `penjualan`
--

CREATE TABLE `penjualan` (
  `kd_pretransaksi` varchar(10) NOT NULL,
  `kd_transaksi` varchar(10) NOT NULL,
  `kd_pelanggan` varchar(10) NOT NULL,
  `kd_buku` varchar(10) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `sub_total` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `penjualan`
--

INSERT INTO `penjualan` (`kd_pretransaksi`, `kd_transaksi`, `kd_pelanggan`, `kd_buku`, `jumlah`, `sub_total`) VALUES
('PS0001', 'TR0001', 'g34', 'wqw', 12, 2332);

--
-- Trigger `penjualan`
--
DELIMITER $$
CREATE TRIGGER `BELI` AFTER INSERT ON `penjualan` FOR EACH ROW UPDATE buku SET
buku.stok = buku.stok - NEW.jumlah WHERE buku.kd_buku = NEW.kd_buku
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Batal` AFTER DELETE ON `penjualan` FOR EACH ROW UPDATE buku
SET stok = stok + OLD.jumlah
WHERE
kd_buku = OLD.kd_buku
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `penjualan2`
--

CREATE TABLE `penjualan2` (
  `kd_transaksi` varchar(10) NOT NULL,
  `nama_pelanggan` varchar(50) NOT NULL,
  `total` int(50) NOT NULL,
  `tanggal_beli` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `penjualan2`
--

INSERT INTO `penjualan2` (`kd_transaksi`, `nama_pelanggan`, `total`, `tanggal_beli`) VALUES
('TR0001', 'bsdhs', 2332, '2026-07-13 15:44:39');

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `perbulan`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `perbulan` (
`kd_buku` varchar(10)
,`judul` varchar(50)
,`jenis` varchar(10)
,`jumlah` int(11)
,`tanggal_beli` timestamp
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `struk`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `struk` (
`nama_pelanggan` varchar(50)
,`total` int(50)
,`tanggal_beli` timestamp
,`kd_transaksi` varchar(10)
,`jumlah` int(11)
,`sub_total` int(20)
,`judul` varchar(50)
);

-- --------------------------------------------------------

--
-- Struktur untuk view `perbulan`
--
DROP TABLE IF EXISTS `perbulan`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `perbulan`  AS SELECT `buku`.`kd_buku` AS `kd_buku`, `buku`.`judul` AS `judul`, `buku`.`jenis` AS `jenis`, `penjualan`.`jumlah` AS `jumlah`, `penjualan2`.`tanggal_beli` AS `tanggal_beli` FROM ((`buku` join `penjualan` on(`buku`.`kd_buku` = `penjualan`.`kd_buku`)) join `penjualan2` on(`buku`.`kd_buku` = `penjualan`.`kd_buku`)) ;

-- --------------------------------------------------------

--
-- Struktur untuk view `struk`
--
DROP TABLE IF EXISTS `struk`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `struk`  AS SELECT `penjualan2`.`nama_pelanggan` AS `nama_pelanggan`, `penjualan2`.`total` AS `total`, `penjualan2`.`tanggal_beli` AS `tanggal_beli`, `penjualan`.`kd_transaksi` AS `kd_transaksi`, `penjualan`.`jumlah` AS `jumlah`, `penjualan`.`sub_total` AS `sub_total`, `buku`.`judul` AS `judul` FROM ((`penjualan2` join `penjualan` on(`penjualan2`.`kd_transaksi` = `penjualan`.`kd_transaksi`)) join `buku` on(`penjualan`.`kd_buku` = `buku`.`kd_buku`)) ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `buku`
--
ALTER TABLE `buku`
  ADD PRIMARY KEY (`kd_buku`);

--
-- Indeks untuk tabel `distributor`
--
ALTER TABLE `distributor`
  ADD PRIMARY KEY (`kd_distributor`);

--
-- Indeks untuk tabel `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`kd_pelanggan`);

--
-- Indeks untuk tabel `penjualan`
--
ALTER TABLE `penjualan`
  ADD PRIMARY KEY (`kd_pretransaksi`);

--
-- Indeks untuk tabel `penjualan2`
--
ALTER TABLE `penjualan2`
  ADD PRIMARY KEY (`kd_transaksi`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
