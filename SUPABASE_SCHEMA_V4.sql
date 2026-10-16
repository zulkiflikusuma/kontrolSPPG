
-- SPPG PEKIRINGAN V4 - DATABASE + QC DINAMIS
-- Jalankan ini di Supabase SQL Editor

-- 1. Sekolah
CREATE TABLE IF NOT EXISTS sekolah (
  id TEXT PRIMARY KEY,
  nama TEXT NOT NULL,
  alamat TEXT,
  jumlah_porsi INT,
  penanggung_jawab TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. QC Tasks Dinamis (bisa tambah tugas kapan aja)
CREATE TABLE IF NOT EXISTS qc_tasks (
  id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  deskripsi TEXT,
  required BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Distribusi
CREATE TABLE IF NOT EXISTS distribusi (
  id TEXT PRIMARY KEY,
  sekolah_id TEXT REFERENCES sekolah(id),
  status TEXT,
  jam_berangkat TIMESTAMPTZ,
  jam_sampai TIMESTAMPTZ,
  gps_lat DOUBLE PRECISION,
  gps_lng DOUBLE PRECISION,
  catatan TEXT,
  foto_bukti TEXT,
  tanda_tangan TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Stok
CREATE TABLE IF NOT EXISTS stok (
  id TEXT PRIMARY KEY,
  bahan TEXT,
  jumlah_masuk INT,
  satuan TEXT,
  kondisi TEXT,
  foto TEXT,
  tgl TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. QC History (snapshot harian)
CREATE TABLE IF NOT EXISTS qc_history (
  id TEXT PRIMARY KEY,
  tgl TIMESTAMPTZ DEFAULT NOW(),
  tasks JSONB,
  foto TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. Kendala
CREATE TABLE IF NOT EXISTS laporan_kendala (
  id TEXT PRIMARY KEY,
  kategori TEXT,
  deskripsi TEXT,
  foto TEXT,
  tgl TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert QC tasks awal Pekiringan
INSERT INTO qc_tasks (id, label, deskripsi, required) VALUES
('qt1', 'Suhu makanan >60°C', 'Pakai termometer food grade', true),
('qt2', 'Kemasan steril & tertutup', 'Cek segel box', true),
('qt3', 'Kebersihan dapur & alat', 'Lantai, meja, wastafel bersih', true),
('qt4', 'Kendaraan bersih & suhu terjaga', 'Box pendingin nyala', true)
ON CONFLICT (id) DO NOTHING;

-- Insert sekolah awal
INSERT INTO sekolah (id, nama, alamat, jumlah_porsi, penanggung_jawab) VALUES
('s1', 'SDN Pekiringan 01', 'Jl. Pekiringan Timur No.12', 420, 'Ibu Siti'),
('s2', 'SDN Pekiringan 02', 'Jl. Raya Pekiringan 45', 380, 'Pak Budi'),
('s3', 'SMPN 3 Karangmoncol', 'Jl. Karangmoncol - Pekiringan', 445, 'Bu Ani')
ON CONFLICT (id) DO NOTHING;

-- Enable RLS & allow all for dev (ganti nanti untuk production)
ALTER TABLE sekolah ENABLE ROW LEVEL SECURITY;
ALTER TABLE qc_tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE distribusi ENABLE ROW LEVEL SECURITY;
ALTER TABLE stok ENABLE ROW LEVEL SECURITY;
ALTER TABLE qc_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE laporan_kendala ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "allow_all" ON sekolah;
CREATE POLICY "allow_all" ON sekolah FOR ALL USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "allow_all" ON qc_tasks;
CREATE POLICY "allow_all" ON qc_tasks FOR ALL USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "allow_all" ON distribusi;
CREATE POLICY "allow_all" ON distribusi FOR ALL USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "allow_all" ON stok;
CREATE POLICY "allow_all" ON stok FOR ALL USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "allow_all" ON qc_history;
CREATE POLICY "allow_all" ON qc_history FOR ALL USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "allow_all" ON laporan_kendala;
CREATE POLICY "allow_all" ON laporan_kendala FOR ALL USING (true) WITH CHECK (true);
