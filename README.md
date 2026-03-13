# Tutorial 3

## Fitur yang Diimplementasikan

1. **Double Jump**: Pemain dapat melompat dua kali berturut-turut.
2. **Dashing (Double Tap)**: Gerakan cepat sementara dengan menekan tombol arah dua kali.
3. **Crouching**: Karakter berjongkok dengan kecepatan lambat dan menggunakan *collision* ganda agar tidak mengalami *glitch* saat menapak.
4. **Wall Jump**: Pemain dapat melompat berlawanan arah saat menempel pada dinding.
5. **Sistem Animasi**: Sinkronisasi otomatis untuk animasi (Idle, Walk, Jump, Fall, Crouch) dan pembalikan arah *sprite*.

## Penjelasan Proses Pengerjaan

### 1. Double Jump dan Wall Jump
Variabel `jumps_left` direset menjadi 2 saat di lantai. Menekan lompat akan mengubah kecepatan vertikal dan mengurangi sisa lompatan. Untuk *Wall Jump*, `is_on_wall()` mendeteksi dinding, dan karakter diberi gaya dorong berlawanan menggunakan `get_wall_normal().x`.

### 2. Dashing (Double Tap)
Menggunakan `tap_timer` untuk mendeteksi penekanan tombol ganda. Jika berhasil, status `is_dashing` aktif dan pergerakan biasa diambil alih oleh `dash_speed` selama durasi `dash_timer`.

### 3. Crouching (Dua Collision)
Menggunakan dua `CollisionShape2D` secara bergantian. Saat tombol jongkok ditekan, `CollisionStanding` dimatikan dan `CollisionCrouching` dihidupkan, memastikan fisik karakter tetap menempel sempurna di lantai dengan kecepatan `crouch_speed`.

### 4. Sinkronisasi Animasi (AnimatedSprite2D)
Prioritas pengecekan animasi di akhir fungsi `_physics_process`:
* **Di lantai**: Cek apakah sedang jongkok (`crouch`), bergerak (`walk`), atau diam (`idle`).
* **Di udara**: Cek arah vertikal untuk mendarat (`fall`) atau naik (`jump`).
Arah pandang disesuaikan dengan mengubah properti `flip_h` berdasarkan *input* pergerakan.

---

# Tutorial 5

## Fitur yang Diimplementasikan

1. **Patroli Zombie**: Zombie bergerak bolak-balik secara otomatis, berbalik saat menabrak dinding, dan melompat di ujung pijakan.
2. **Animasi Zombie**: Sinkronisasi animasi (Idle, Walk, Jump, Fall) menggunakan `AnimatedSprite2D`.
3. **Collision Dinamis**: Pemisahan layer fisik agar karakter dan zombie tidak saling menabrak, tapi serangan tetap mengenai pemain.
4. **Health Point (HP) & HUD**: Tampilan sisa HP di layar yang selalu mengikuti kamera menggunakan `CanvasLayer`.
5. **Efek Audio**: Pemutaran suara saat terkena serangan (`UGHH.wav`) dan saat kalah (`horn_fail.wav`).
6. **Game Over & Transisi Scene**: Layar otomatis berpindah ke `LoseScreen.tscn` saat HP habis dan melakukan *reset* level setelah beberapa detik.

## Penjelasan Proses Pengerjaan

### 1. Animasi dan Pergerakan Zombie
Menggunakan node `AnimatedSprite2D` untuk memutar state animasi (Walk, Idle, Jump, Fall) sesuai kondisi. Pergerakan diatur oleh variabel `direction` yang berbalik nilai (`direction *= -1`) setiap kali `is_on_wall()` terdeteksi. Node `RayCast2D` (`LedgeCheck`) digunakan untuk mendeteksi ujung lantai agar zombie bisa melompat secara otomatis.

### 2. Pengaturan Collision Layer & Mask

Untuk menghindari benturan fisik (saling dorong) antara pemain dan zombie, pengaturan fisiknya dipisah:
* **Ground**: Layer 1.
* **Player**: Layer 2, Mask 1 (Hanya berpijak ke tanah).
* **Zombie (Karakter)**: Layer 3, Mask 1 (Hanya berpijak ke tanah).
* **Zombie (Hitbox Area2D)**: Tanpa Layer, dengan Mask 2. Ini berfungsi sebagai sensor khusus untuk mendeteksi sentuhan dengan Layer 2 (Player) tanpa menimbulkan efek dorongan fisik.

### 3. Sistem HP dan UI (HUD)
Variabel `hp` dideklarasikan pada script Player. Agar teks UI tidak ikut bergerak bersama karakter di *viewport*, node `Label` diletakkan di dalam `CanvasLayer` pada scene utama (`Main.tscn`). Script Player mengakses label ini menggunakan jalur *path* relatif (`$"../CanvasLayer/HPLabel"`) untuk memperbarui sisa HP di layar.

### 4. Interaksi Damage dan Transisi Layar
Sinyal `body_entered` dari Hitbox Zombie mendeteksi sentuhan dengan Player dan memanggil fungsi `take_damage()`. Fungsi ini akan mengurangi nilai HP, memutar `HurtAudio`, dan mengecek kondisi HP. Jika HP mencapai 0, `get_tree().change_scene_to_file()` dipanggil untuk memuat `LoseScreen.tscn`. Di scene layar kalah, suara `FailAudio` diputar secara otomatis, dan game dihentikan sejenak selama 2 detik menggunakan *coroutine* (`await get_tree().create_timer(2.0).timeout`) sebelum di-reset kembali ke scene level utama.