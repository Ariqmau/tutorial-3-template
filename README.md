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