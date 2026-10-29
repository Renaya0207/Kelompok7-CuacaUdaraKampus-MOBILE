# 🌿 KabarLangit - Cuaca Udara Kota Kampus

Aplikasi Flutter pemantau **cuaca dan kualitas udara** yang fokus utamanya adalah untuk delapan kota kampus di Indonesia.
Dibuat berdasarkan *Studi Kasus 13: Cuaca Kampus*, dengan tambahan **Open-Meteo Air Quality API**.

## Anggota Kelompok 7

| No | Nama | NIM |
|----|------|-----|
| 1 | Rusdiana | 2409106021 |
| 2 | Renaya Putri Alika | 2409106002 |
| 3 | Andi Fachry Alam Tengko | 2409106006 |

## Fitur

| Bagian | Fitur |
|--------|-------|
| Pilihan kota | *Chip* Jakarta, Bandung, Yogyakarta, Surabaya, Denpasar, Samarinda, Makassar, dan Medan |
| Cuaca saat ini | Suhu, suhu terasa, kondisi (cerah, berawan, hujan, ...), kelembapan, kecepatan angin, peluang hujan, dan jam diperbarui |
| Kualitas udara | US AQI, kategori + saran kesehatan, skala warna, PM2.5, PM10, O₃, NO₂, SO₂, dan CO |
| Prakiraan 7 hari | Kondisi, suhu tertinggi dan terendah, serta peluang hujan setiap hari |
| Jelajahi Indonesia | Pencarian kota/provinsi dan 23 kota lain sebagai tambahan |
| Interaksi | Tarik ke bawah untuk menyegarkan; tombol **Coba lagi** saat gagal |
| Tampilan | Tema terang & gelap (tombol di header), warna kartu cuaca mengikuti kondisi dan warna kartu udara mengikuti tingkat polusi |

## Coba di HP

Pindai QR di bawah dengan kamera HP untuk membuka versi web aplikasi, tanpa perlu memasang apa pun.

<p align="center">
  <img src="https://api.qrserver.com/v1/create-qr-code/?size=240x240&margin=10&data=https%3A%2F%2Fkabarlangit.web.app" alt="QR Code KabarLangit" width="240">
  <br>
  <a href="https://kabarlangit.web.app">https://kabarlangit.web.app</a>
</p>

## Sumber data

[Open-Meteo](https://open-meteo.com/) (gratis, tanpa API key). Dua permintaan dijalankan **bersamaan** untuk setiap kota:

```
GET https://api.open-meteo.com/v1/forecast
    ?latitude=..&longitude=..
    &current=temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m
    &daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max
    &timezone=auto&forecast_days=7

GET https://air-quality-api.open-meteo.com/v1/air-quality
    ?latitude=..&longitude=..
    &current=us_aqi,pm2_5,pm10,ozone,nitrogen_dioxide,sulphur_dioxide,carbon_monoxide
    &timezone=auto
```

Bagian `daily` berupa **larik sejajar**; *Model* memeriksa panjangnya sama sebelum membentuk prakiraan harian.
Bila API kualitas udara gagal, *Repository* mengubahnya menjadi `null` sehingga **cuaca tetap tampil**.

| US AQI | Kategori |
|--------|----------|
| 0–50 | Baik |
| 51–100 | Sedang |
| 101–150 | Tidak sehat bagi kelompok sensitif |
| 151–200 | Tidak sehat |
| 201–300 | Sangat tidak sehat |
| 301+ | Berbahaya |

## Arti polutan

Nilai polutan di aplikasi ditampilkan dalam **µg/m³** (mikrogram per meter kubik udara). Semakin besar angkanya, semakin pekat polutan tersebut.

| Polutan | Kepanjangan | Penjelasan | Sumber umum |
|---------|-------------|------------|-------------|
| **US AQI** | *Air Quality Index* (standar US EPA) | Satu angka 0–500 yang merangkum tingkat polusi dari semua polutan. Makin tinggi, makin tidak sehat. | Gabungan seluruh polutan |
| **PM2.5** | *Particulate Matter* ≤ 2,5 µm | Partikel sangat halus, sekitar 30 kali lebih kecil dari lebar rambut. Dapat masuk jauh ke paru-paru dan aliran darah. | Asap kendaraan, pembakaran sampah, kebakaran hutan dan lahan |
| **PM10** | *Particulate Matter* ≤ 10 µm | Partikel debu yang lebih besar. Terutama mengiritasi hidung, tenggorokan, dan saluran napas atas. | Debu jalan, pembangunan, serbuk |
| **O₃** | Ozon permukaan | Gas yang terbentuk dari reaksi polutan kendaraan dengan sinar matahari, biasanya tertinggi di siang hari. Dapat memicu batuk dan kambuhnya asma. | Reaksi gas buang dan sinar matahari |
| **NO₂** | Nitrogen dioksida | Gas yang mengiritasi saluran napas dan memperburuk asma. | Knalpot kendaraan, pembakaran bahan bakar |
| **SO₂** | Sulfur dioksida | Gas berbau tajam yang mengiritasi mata dan saluran napas. | Pembakaran batu bara dan minyak, industri, gunung berapi |
| **CO** | Karbon monoksida | Gas tak berwarna dan tak berbau yang mengurangi kemampuan darah membawa oksigen. | Pembakaran tidak sempurna, terutama kendaraan |

## Struktur

```
lib/
├── main.dart                  # MultiProvider lalu runApp
├── app_theme.dart             # Warna merek, palet terang/gelap, ThemeData
├── app_theme_controller.dart  # Status mode terang/gelap
├── models/
│   ├── weather_model.dart     # WeatherModel, DailyForecast, kode cuaca -> teks/emoji
│   └── air_quality_model.dart # AirQuality (US AQI + polutan, siap nilai null)
├── services/
│   └── weather_service.dart   # HTTP: fetchForecast, fetchAirQuality, ApiException
├── repositories/
│   └── weather_repository.dart # Menggabungkan cuaca + udara menjadi satu model
├── viewmodels/
│   └── weather_viewmodel.dart # Daftar kota, status memuat/berhasil/gagal, nomor permintaan
└── views/
    ├── home_view.dart         # Halaman utama: chip kota, RefreshIndicator, pencarian
    └── widgets.dart           # Kartu cuaca, kartu udara, prakiraan, ilustrasi
test/
└── weather_repository_test.dart  # Pengujian repository dengan MockClient
assets/images/campus_air.png      # Ilustrasi untuk mode gelap
```

## Cara menjalankan (VS Code)

```bash
flutter create cuaca_kampus      # buat proyek kosong
# salin folder lib/, test/, assets/ dan pubspec.yaml dari repo ini ke dalamnya (timpa)
cd cuaca_kampus
flutter pub get
flutter run -d chrome            # atau pilih perangkat Android
```

> **Penting untuk APK rilis:** pastikan izin internet ada di
> `android/app/src/main/AndroidManifest.xml`, di atas tag `<application>`:
> `<uses-permission android:name="android.permission.INTERNET"/>`
>
> Membuat APK: `flutter build apk --release`
> (hasil: `build/app/outputs/flutter-apk/app-release.apk`)

## Pengujian

```bash
flutter test
```

Tiga pengujian repository memakai `MockClient`, jadi tidak membutuhkan internet:
cuaca + prakiraan tujuh hari terbaca, kualitas udara terbaca, dan **cuaca tetap dimuat saat API kualitas udara gagal**.

## Uji mandiri

- [ ] `flutter test` menampilkan tiga pengujian lulus.
- [ ] Memilih chip kota lain menampilkan indikator memuat, lalu cuaca dan udara kota itu.
- [ ] Memilih dua kota dengan sangat cepat tidak pernah menampilkan kota yang **pertama** dipilih.
- [ ] Menarik halaman ke bawah menyegarkan data, dan jam "Diperbarui" berubah.
- [ ] Baris pertama prakiraan bertuliskan "Hari ini".
- [ ] Mematikan internet lalu menekan kota lain menampilkan pesan ramah dan tombol **Coba lagi**.
- [ ] Dalam mode gelap, semua teks tetap terbaca.

## Tampilan aplikasi

| Mode terang | Mode gelap | Gagal terhubung (Galat) |
|:---:|:---:|:---:|
| <img width="250" alt="Mode terang" src="https://github.com/user-attachments/assets/e3ad9089-aa38-4b0d-b406-ba9699b71479" /> | <img width="250" alt="Mode gelap" src="https://github.com/user-attachments/assets/bdf9fb0c-2219-4842-9dd6-0e9439c24e69" /> | <img width="250" alt="Gagal terhubung" src="https://github.com/user-attachments/assets/ca91cbc9-572b-4119-ba94-9cb62d3ee8bd" /> |

| Kualitas udara | Prakiraan 7 hari | Jelajah kota |
|:---:|:---:|:---:|
| <img width="250" alt="Kualitas udara" src="https://github.com/user-attachments/assets/b1e8626a-63da-45eb-8808-2ae8c81f357c" /> | <img width="250" alt="Prakiraan 7 hari" src="https://github.com/user-attachments/assets/eacbc38a-7e02-49da-bcb6-2d87908665e5" /> | <img width="250" alt="Jelajah kota" src="https://github.com/user-attachments/assets/cbf685ff-5466-4979-99a6-55ee35702434" /> |

## Kesimpulan

**KabarLangit** adalah aplikasi mobile berbasis Flutter yang membantu mahasiswa mengetahui cuaca dan kualitas udara di kota kampusnya dalam satu layar, sebelum berangkat atau beraktivitas di luar ruangan.

- **Mudah dipakai:** pengguna cukup memilih salah satu dari delapan kota kampus, lalu langsung melihat suhu, kondisi cuaca, kelembapan, kecepatan angin, peluang hujan, dan prakiraan tujuh hari.
- **Informasi udara yang mudah dipahami:** angka US AQI diterjemahkan menjadi kategori (Baik sampai Berbahaya) dengan warna dan saran kesehatan, lengkap dengan kadar PM2.5, PM10, O₃, NO₂, SO₂, dan CO. Pengguna bisa tahu apakah aman berolahraga, bersepeda, atau berjalan kaki ke kampus.
- **Data terkini dan gratis:** seluruh data diambil langsung dari Open-Meteo tanpa API key, dan bisa disegarkan kapan saja dengan menarik layar ke bawah.
- **Nyaman di berbagai kondisi:** tersedia mode terang dan gelap, tampilan menyesuaikan lebar layar HP maupun browser, dan saat internet bermasalah aplikasi menampilkan pesan yang ramah beserta tombol **Coba lagi**.
- **Bisa dicoba siapa saja:** aplikasi dapat dibuka dari HP lewat QR tanpa perlu dipasang.

**Keterbatasan:** aplikasi membutuhkan internet dan hanya bergantung pada satu penyedia data. Lokasi yang dipakai adalah titik pusat kota, jadi angkanya adalah perkiraan model, bukan pengukuran langsung di area kampus.

**Pengembangan selanjutnya:** prakiraan AQI per hari, menyimpan kota terakhir yang dipilih, lokasi otomatis lewat GPS, dan notifikasi saat udara tidak sehat.
