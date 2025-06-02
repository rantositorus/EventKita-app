# event_kita_app

Final Project Mata Kuliah "Mobile Programming"

## Cara Menggunakan

### Step 1: Clone Repository
```bash
git pull https://github.com/rantositorus/EventKita-app
```

### Step 2: Install Firebase CLI & FlutterFire CLI

Dalam direktori proyek flutter, jalankan command di bawah

```bash
npm install -g firebase-tools
```

Lakukan ini sekali saja.

Selanjutnya, login ke firebase menggunakan

```bash
firebase login
```

Jika sudah login, aktivasi `flutterfire_cli` menggunakan

```bash
flutter pub global activate flutterfire_cli
```

Dan hubungkan proyek dengan firebase dengan
```bash
flutterfire configure
```

## Step 3: Jalankan flutter pub get
Untuk instalasi semua package yang diperlukan proyek, jalankan
```bash
flutter pub get
```