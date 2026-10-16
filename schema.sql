
-- SPPG PEKIRINGAN - DATABASE SCHEMA V2 SIAP KERJA
-- Copy paste ini ke Supabase SQL Editor

-- 1. Tabel Sekolah Penerima (area Pekiringan)
CREATE TABLE sekolah (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nama TEXT NOT NULL, -- ex: SDN Pekiringan 01
  alamat TEXT,
  jenjang TEXT, -- SD/SMP/SMA/Posyandu
  jumlah_porsi INT NOT NULL,
  penanggung_jawab TEXT,
  no_hp_pj TEXT,
  lat DOUBLE PRECISION,
  lng DOUBLE PRECISION,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Tabel Distribusi Harian (inti kerjaan Aslap)
CREATE TABLE distribusi (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tanggal DATE NOT NULL DEFAULT CURRENT_DATE,
  sekolah_id UUID REFERENCES sekolah(id),
  aslap_id TEXT, -- id kamu Zull
  jumlah_target INT,
  jumlah_terkirim INT,
  jumlah_sisa INT,
  status TEXT CHECK (status IN ('belum','perjalanan','terkirim','kendala')),
  foto_bukti TEXT, -- URL storage
  tanda_tangan TEXT, -- base64 signature
  gps_lat DOUBLE PRECISION,
  gps_lng DOUBLE PRECISION,
  jam_berangkat TIMESTAMPTZ,
  jam_sampai TIMESTAMPTZ,
  catatan TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Tabel Stok Bahan (masuk-keluar)
CREATE TABLE stok (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nama_bahan TEXT NOT NULL, -- beras, ayam, telur, susu
  jumlah_masuk INT,
  jumlah_keluar INT,
  satuan TEXT, -- kg, dus, liter
  kondisi TEXT CHECK (kondisi IN ('baik','rusak','expired')),
  foto TEXT,
  tanggal DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Tabel QC Harian
CREATE TABLE qc_harian (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tanggal DATE DEFAULT CURRENT_DATE,
  suhu_makanan_ok BOOLEAN,
  kemasan_steril BOOLEAN,
  kebersihan_dapur BOOLEAN,
  kendaraan_bersih BOOLEAN,
  foto_bukti TEXT,
  catatan TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Tabel Kendala/Laporan Insiden (penting untuk audit)
CREATE TABLE laporan_kendala (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tanggal DATE DEFAULT CURRENT_DATE,
  kategori TEXT CHECK (kategori IN ('susu_hilang','porsi_kurang','sekolah_libur','kendaraan_mogok','bahan_rusak','lainnya')),
  deskripsi TEXT,
  foto_bukti TEXT,
  status_tindak_lanjut TEXT DEFAULT 'dilaporkan',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert data awal SPPG Pekiringan
INSERT INTO sekolah (nama, alamat, jenjang, jumlah_porsi, penanggung_jawab) VALUES
('SDN Pekiringan 01', 'Jl. Pekiringan Timur No.12, Pekiringan', 'SD', 420, 'Ibu Siti'),
('SDN Pekiringan 02', 'Jl. Raya Pekiringan No.45, Pekiringan', 'SD', 380, 'Pak Budi'),
('SMPN 3 Karangmoncol', 'Jl. Karangmoncol - Pekiringan', 'SMP', 445, 'Bu Ani');

-- Enable RLS
ALTER TABLE sekolah ENABLE ROW LEVEL SECURITY;
ALTER TABLE distribusi ENABLE ROW LEVEL SECURITY;
ALTER TABLE stok ENABLE ROW LEVEL SECURITY;
ALTER TABLE qc_harian ENABLE ROW LEVEL SECURITY;
ALTER TABLE laporan_kendala ENABLE ROW LEVEL SECURITY;

-- Policy sementara: izinkan semua untuk development
CREATE POLICY "allow_all" ON sekolah FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON distribusi FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON stok FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON qc_harian FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON laporan_kendala FOR ALL USING (true) WITH CHECK (true);
