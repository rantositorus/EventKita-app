# event_kita_app

Final Project Mata Kuliah "Mobile Programming"

Event Kita merupakan aplikasi RSVP dan menejemen acara. User dapat membuat acara, mengatur acara yang sudah dibuat, mencari acara yang mau di datangi, melakukan konfirmasi kehadianr (RSVP) dan mengatur RSVP yang sudah dibuat. Aplikasi ini juga dirancang untuk mengatur acara skala besar maupun skala kecil.

### Home Page
![image](https://github.com/user-attachments/assets/28c2c605-48d3-49bc-9ebe-f544ead543dd)

### Search Page
![image](https://github.com/user-attachments/assets/77bb97ab-d8fa-4090-9269-761fcf29d0d5)

### Details Page
![image](https://github.com/user-attachments/assets/41ef9306-5be0-471f-8475-342ffe3c7dd4)

### My Events Page
![image](https://github.com/user-attachments/assets/d98a1d60-8999-4d68-8e40-665ec15b1729)


## Member's Contribution
5025221017 - Valentino Reswara Ajiputra
- Manajemen profil
- Register Page
- Home Page
- Splash Screen & Icon
- CRUD: Personal Information

5025221227 - Gavrila Nirwasita
- Search Page
- Details Page
- Lihat RSVP Saya Page
- RSVP page
- CRUD: RSVP

5025221228 - Ranto Sitorus
- Buat Acara Page
- Login Page
- My Events Page
- CRUD: Events



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
