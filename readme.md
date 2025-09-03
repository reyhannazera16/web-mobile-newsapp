# Laravel API + Flutter Mobile (CRUD)

Dokumentasi langkah demi langkah untuk menjalankan **Backend (Laravel API)** yang bisa diakses oleh **aplikasi Mobile (Flutter)**. Fokus pada skenario pengembangan lokal menggunakan **Laragon** atau **XAMPP** di Windows (berlaku juga untuk macOS/Linux dengan penyesuaian path).

> **Tujuan:** Setelah mengikuti panduan ini, Anda dapat:
>
> 1. Menjalankan API Laravel secara lokal, 2) Menghubungkan Flutter ke API tersebut, 3) Melakukan operasi **CRUD** dari mobile ke backend.

---

## Struktur Repositori (Contoh)

```
root/
├─ backend-laravel/       # Proyek Laravel (API)
└─ mobile-flutter/        # Proyek Flutter (client)
```

> Jika repositori Anda hanya berisi salah satu (hanya Laravel atau hanya Flutter), ikuti bagian yang relevan saja.

---

## Prasyarat

### Umum

* Git terbaru
* Editor (VS Code/PhpStorm/Android Studio, dsb.)

### Backend (Laravel)

* PHP ≥ 8.2
* Composer
* MySQL/MariaDB (tersedia di Laragon/XAMPP)
* **Laragon** (direkomendasikan di Windows) **atau** **XAMPP**

### Mobile (Flutter)

* Flutter SDK stable (cek dengan `flutter --version`)
* Android Studio (Android SDK/Emulator) / Xcode (iOS Simulator)

---

## 1) Clone Repositori

```bash
# Ganti REPO_URL dengan URL GitHub Anda
git clone REPO_URL
cd root
```

> Jika Laravel & Flutter berada di repositori terpisah, clone keduanya.

---

## 2) Menjalankan **Backend (Laravel API)** dengan **Laragon**

> Lokasi default Laragon: `C:\\laragon\\www`

### 2.1. Salin Proyek ke Laragon

1. Pindahkan folder `backend-laravel` ke `C:\\laragon\\www`. Misal menjadi `C:\\laragon\\www\\my-api`.
2. Jalankan **Laragon** → **Start All** (Apache & MySQL).

### 2.2. Buat Database

* **Laragon** → Menu → **MySQL** → **Create database…** → masukkan nama, misal: `my_api_db`.

  * Alternatif: buka `http://localhost/phpmyadmin` → **New** → masukkan `my_api_db` → Create.

### 2.3. Instal Dependensi & Konfigurasi `.env`

```bash
cd C:\laragon\www\my-api
copy .env.example .env   # Windows (PowerShell: cp .env.example .env)
composer install
php artisan key:generate
```

Edit file **.env** (nilai contoh):

```env
APP_NAME="My API"
APP_ENV=local
APP_KEY=base64:GENERATED_KEY
APP_DEBUG=true
APP_URL=http://my-api.test   # jika pakai virtual host Laragon
# APP_URL=http://127.0.0.1:8000  # jika pakai `php artisan serve`

# Database
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=my_api_db
DB_USERNAME=root
DB_PASSWORD=        # (kosong default Laragon)

# CORS (sesuaikan jika perlu)
# Di config/cors.php pastikan paths mencakup `api/*`
```

### 2.4. Migrasi & Seed (opsional)

```bash
php artisan migrate --seed
php artisan storage:link
```

### 2.5. Menjalankan Server Backend

**Opsi A – Virtual Host Laragon (nyaman untuk web/admin):**

* Laragon otomatis membuat domain `http://my-api.test` (cek Menu → www → my-api). API Anda akan di `http://my-api.test/api/...`.

**Opsi B – Artisan Serve (nyaman untuk mobile di LAN):**

```bash
# listen ke semua interface agar device di jaringan yang sama bisa akses
php artisan serve --host 0.0.0.0 --port 8000
# API base URL: http://{IP_KOMPUTER_ANDA}:8000/api
```

> Catatan Windows Firewall: bila diminta, **Allow access** untuk PHP agar port bisa diakses dari device lain.

---

## 3) Menjalankan **Backend (Laravel API)** dengan **XAMPP**

> Lokasi default XAMPP: `C:\\xampp\\htdocs`

### 3.1. Salin Proyek ke XAMPP

1. Pindahkan folder `backend-laravel` ke `C:\\xampp\\htdocs`. Misal menjadi `C:\\xampp\\htdocs\\my-api`.
2. Jalankan **XAMPP Control Panel** → **Start** Apache & MySQL.

### 3.2. Buat Database

* Buka `http://localhost/phpmyadmin` → **New** → buat DB `my_api_db`.

### 3.3. Instal Dependensi & Konfigurasi `.env`

```bash
cd C:\xampp\htdocs\my-api
copy .env.example .env
composer install
php artisan key:generate
```

Edit **.env** seperti pada bagian Laragon (sesuaikan kredensial XAMPP; default user `root`, password kosong).

### 3.4. Atur Document Root ke `public/` (Direkomendasikan)

**Opsi A – VirtualHost Apache** (file `httpd-vhosts.conf`):

```apache
<VirtualHost *:80>
    ServerName my-api.local
    DocumentRoot "C:/xampp/htdocs/my-api/public"
    <Directory "C:/xampp/htdocs/my-api/public">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

* Tambahkan di `C:\Windows\System32\drivers\etc\hosts`:

```
127.0.0.1   my-api.local
```

* Akses: `http://my-api.local`

**Opsi B – Artisan Serve** (paling cepat):

```bash
php artisan serve --host 0.0.0.0 --port 8000
```

### 3.5. Migrasi & Seed

```bash
php artisan migrate --seed
php artisan storage:link
```

---

## 4) URL, Port, dan Alamat IP untuk Akses dari Mobile

Tentukan **API Base URL** yang dipakai oleh Flutter:

| Lingkungan                                    | Contoh Base URL               | Keterangan                                                              |
| --------------------------------------------- | ----------------------------- | ----------------------------------------------------------------------- |
| Laravel via Artisan (host 0.0.0.0, port 8000) | `http://192.168.1.7:8000/api` | Gunakan **IP LAN** PC Anda. Cek via `ipconfig`/`ifconfig`               |
| Laragon VirtualHost (port 80)                 | `http://192.168.1.7/api`      | Nama domain `.test`/`.local` tidak dikenal di device; pakai IP langsung |
| Android Emulator (default)                    | `http://10.0.2.2:8000/api`    | 10.0.2.2 = alias `localhost` host pada emulator Android                 |
| Android Genymotion                            | `http://10.0.3.2:8000/api`    | Alias `localhost` untuk Genymotion                                      |
| iOS Simulator                                 | `http://127.0.0.1:8000/api`   | Simulator iOS berbagi loopback host                                     |

> **Penting:** Device (HP) dan PC **harus berada di jaringan Wi‑Fi yang sama**. Pastikan firewall tidak memblokir port (misal 8000).

### Catatan HTTP/HTTPS pada Mobile

* **Android 9+ (Cleartext)**: HTTP non-HTTPS diblok secara default.

  * Tambahkan di `AndroidManifest.xml` (app/src/main):

    ```xml
    <application
        android:usesCleartextTraffic="true" ...>
    </application>
    ```
  * Atau konfigurasi **Network Security Config** per domain.
* **iOS (ATS)**: Untuk HTTP, tambahkan pengecualian di `Info.plist` (dev saja):

  ```xml
  <key>NSAppTransportSecurity</key>
  <dict>
    <key>NSAllowsArbitraryLoads</key><true/>
  </dict>
  ```

> Produksi: gunakan **HTTPS** yang valid (mis. lewat reverse proxy/Ngrok/tunnel untuk testing cepat).

---

## 5) Menjalankan **Mobile (Flutter)**

```bash
cd mobile-flutter
flutter pub get
```

### 5.1. Konfigurasi Base URL & Port di Flutter

**Opsi A – `--dart-define` (sederhana):**

```bash
flutter run \
  --dart-define=API_BASE_URL=http://192.168.1.7:8000/api
```

Akses di kode Dart:

```dart
const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');
```

**Opsi B – `flutter_dotenv` (file .env):**

1. Tambah dependency di `pubspec.yaml`:

   ```yaml
   dependencies:
     http: ^1.2.0
     flutter_dotenv: ^5.1.0
   ```
2. Buat file `.env` di root proyek Flutter:

   ```env
   API_BASE_URL=http://192.168.1.7:8000/api
   ```
3. Muat env di `main.dart`:

   ```dart
   import 'package:flutter_dotenv/flutter_dotenv.dart';

   void main() async {
     await dotenv.load(fileName: '.env');
     runApp(const MyApp());
   }
   ```
4. Pakai di kode:

   ```dart
   final apiBaseUrl = dotenv.env['API_BASE_URL']!;
   ```

### 5.2. Contoh Service Flutter (CRUD)

`lib/services/api_client.dart`

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl; // contoh: http://192.168.1.7:8000/api
  ApiClient(this.baseUrl);

  Future<List<dynamic>> listItems() async {
    final res = await http.get(Uri.parse('$baseUrl/items'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List<dynamic>;
    }
    throw Exception('Failed to load items: ${res.statusCode}');
  }

  Future<Map<String, dynamic>> getItem(int id) async {
    final res = await http.get(Uri.parse('$baseUrl/items/$id'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to get item');
  }

  Future<Map<String, dynamic>> createItem(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/items'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to create item');
  }

  Future<Map<String, dynamic>> updateItem(int id, Map<String, dynamic> data) async {
    final res = await http.put(
      Uri.parse('$baseUrl/items/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to update item');
  }

  Future<void> deleteItem(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/items/$id'));
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Failed to delete item');
    }
  }
}
```

> Pastikan endpoint (`/items`) disesuaikan dengan API Anda.

---

## 6) Contoh Routing Laravel (CRUD)

Di `routes/api.php`:

```php
use App\Http\Controllers\ItemController;

Route::apiResource('items', ItemController::class);
```

Contoh minimal `ItemController` (cuplikan):

```php
public function index() {
    return Item::all();
}

public function store(Request $request) {
    $item = Item::create($request->all());
    return response()->json($item, 201);
}

public function show(Item $item) {
    return $item;
}

public function update(Request $request, Item $item) {
    $item->update($request->all());
    return response()->json($item, 200);
}

public function destroy(Item $item) {
    $item->delete();
    return response()->noContent();
}
```

> Pastikan **fillable** di Model, validasi request, dan auth/security sesuai kebutuhan.

---

## 7) CORS (Agar Mobile Bisa Akses API)

* Laravel 10/11 sudah menyertakan konfigurasi CORS di `config/cors.php`.
* Untuk pengembangan, Anda dapat melonggarkan asal (origin):

```php
// config/cors.php
return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['*'], // Produksi: batasi ke domain tertentu
    'allowed_headers' => ['*'],
    'supports_credentials' => false,
];
```

* Setelah mengubah konfigurasi: `php artisan config:clear`.

---

## 8) Uji Coba API (Postman/cURL)

```bash
# List items
curl http://127.0.0.1:8000/api/items

# Create item
curl -X POST http://127.0.0.1:8000/api/items \
  -H "Content-Type: application/json" \
  -d '{"name":"Contoh","price":10000}'
```

---

## 9) Troubleshooting

**Port sudah dipakai**

* Ganti port artisan: `php artisan serve --host 0.0.0.0 --port 9000`
* Atau ubah Apache Listen port (XAMPP `httpd.conf`), contoh ke 8080.

**Akses dari HP gagal**

* Pastikan HP & PC satu jaringan Wi‑Fi.
* Gunakan **IP LAN** PC (misal `192.168.x.x`) bukan `localhost`.
* Izinkan firewall Windows untuk PHP/Apache & port yang digunakan.

**CORS error**

* Periksa `config/cors.php`. Setelah edit, `php artisan config:clear`.

**404 di root / (XAMPP)**

* Pastikan DocumentRoot mengarah ke folder `public/` atau gunakan artisan serve.

**Env tidak terbaca**

* Jalankan `php artisan config:clear` dan `php artisan cache:clear`.

**Ekstensi PHP**

* Error seperti `Class "PDO" not found` → aktifkan ekstensi terkait (pdo\_mysql) di `php.ini`.

---

## 10) Build/Release Singkat

**Backend (dev → prod)**

* Gunakan server dengan HTTPS valid.
* Set `APP_ENV=production`, `APP_DEBUG=false`.
* `php artisan migrate --force`
* `php artisan config:cache && php artisan route:cache`

**Mobile**

* Android: `flutter build apk` / `flutter build appbundle`
* iOS: `flutter build ipa` (butuh macOS/Xcode)

---

## 11) Skrip Ringkas (Cheatsheet)

```bash
# Laravel
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate --seed
php artisan serve --host 0.0.0.0 --port 8000

# Flutter
flutter pub get
flutter run --dart-define=API_BASE_URL=htt
```
