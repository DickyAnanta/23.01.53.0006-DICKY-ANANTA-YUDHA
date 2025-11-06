const API_URL = "http://localhost/pariwisata_api/api.php/records/wisata";

// ==============================
// 1️⃣ READ: tampilkan semua wisata
// ==============================
if (document.getElementById("wisataList")) {
  fetch(API_URL)
    .then((res) => res.json())
    .then((data) => {
      const container = document.getElementById("wisataList");
      container.innerHTML = "";
      data.records.forEach((item) => {
        container.innerHTML += `
          <div class="col-md-4">
            <div class="card shadow-sm h-100">
              <img src="../uploads/${
                item.gambar || "noimg.jpg"
              }" class="card-img-top" alt="${item.nama_wisata}">
              <div class="card-body">
                <h5 class="card-title">${item.nama_wisata}</h5>
                <p class="card-text text-muted">${item.lokasi}</p>
                <div class="d-flex justify-content-between">
                  <a href="form.html?id=${
                    item.id
                  }" class="btn btn-warning btn-sm">✏️ Edit</a>
                  <button onclick="hapusWisata(${
                    item.id
                  })" class="btn btn-danger btn-sm">🗑️ Hapus</button>
                </div>
              </div>
            </div>
          </div>
        `;
      });
    })
    .catch((err) => console.error(err));
}

// ==============================
// 2️⃣ CREATE / UPDATE
// ==============================
if (document.getElementById("wisataForm")) {
  const form = document.getElementById("wisataForm");
  const urlParams = new URLSearchParams(window.location.search);
  const id = urlParams.get("id");

  // Jika mode edit → ambil data lama
  if (id) {
    document.getElementById("formTitle").innerText = "Edit Wisata";
    fetch(`${API_URL}/${id}`)
      .then((res) => res.json())
      .then((data) => {
        document.getElementById("id").value = data.id;
        document.getElementById("nama_wisata").value = data.nama_wisata;
        document.getElementById("lokasi").value = data.lokasi;
        document.getElementById("deskripsi").value = data.deskripsi;
        document.getElementById("id_kategori").value = data.id_kategori;
      });
  }

  // Simpan data baru / edit
  form.addEventListener("submit", (e) => {
    e.preventDefault();
    const wisata = {
      nama_wisata: document.getElementById("nama_wisata").value,
      lokasi: document.getElementById("lokasi").value,
      deskripsi: document.getElementById("deskripsi").value,
      id_kategori: document.getElementById("id_kategori").value,
    };

    const method = id ? "PUT" : "POST";
    const url = id ? `${API_URL}/${id}` : API_URL;

    fetch(url, {
      method: method,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(wisata),
    })
      .then((res) => res.json())
      .then(() => {
        alert("Data berhasil disimpan!");
        window.location.href = "index.html";
      })
      .catch((err) => console.error(err));
  });
}

// ==============================
// 3️⃣ DELETE
// ==============================
function hapusWisata(id) {
  if (confirm("Yakin ingin menghapus data ini?")) {
    fetch(`${API_URL}/${id}`, { method: "DELETE" })
      .then(() => {
        alert("Data berhasil dihapus!");
        location.reload();
      })
      .catch((err) => console.error(err));
  }
}
