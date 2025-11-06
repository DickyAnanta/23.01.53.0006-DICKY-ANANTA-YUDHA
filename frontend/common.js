// ============================================================
// common.js — Helper CRUD Universal (tanpa PATCH, full support XAMPP)
// ============================================================

// Base URL untuk API
const API_BASE = "http://localhost/pariwisata_api/api.php/records";
const UPLOAD_URL = "http://localhost/pariwisata_api/upload.php";

// --- CRUD functions ---
async function listRecords(table) {
  const res = await fetch(`${API_BASE}/${table}`);
  if (!res.ok) throw new Error(`Gagal ambil data ${table}: ${res.status}`);
  return res.json();
}

async function getRecord(table, id) {
  const res = await fetch(`${API_BASE}/${table}/${id}`);
  if (!res.ok)
    throw new Error(`Gagal ambil data ${table}/${id}: ${res.status}`);
  return res.json();
}

async function createRecord(table, data) {
  const res = await fetch(`${API_BASE}/${table}`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(data),
  });
  if (!res.ok) throw new Error(`Gagal menambah data: ${res.status}`);
  return res.json();
}

async function updateRecord(table, id, data) {
  // Gunakan PUT saja — aman di semua server XAMPP
  const res = await fetch(`${API_BASE}/${table}/${id}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(data),
  });
  if (!res.ok) throw new Error(`Gagal update data: ${res.status}`);
  return res.json();
}

async function deleteRecord(table, id) {
  const res = await fetch(`${API_BASE}/${table}/${id}`, { method: "DELETE" });
  if (!res.ok) throw new Error(`Gagal hapus data: ${res.status}`);
  return res.json();
}

// --- Upload file ---
async function uploadFile(file) {
  const fd = new FormData();
  fd.append("file", file);
  const res = await fetch(UPLOAD_URL, { method: "POST", body: fd });
  const result = await res.json();
  if (!result.success) throw new Error(result.message || "Upload gagal");
  return result.filename;
}
