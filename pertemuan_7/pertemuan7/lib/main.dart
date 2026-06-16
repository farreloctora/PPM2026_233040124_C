import 'package:flutter/material.dart';
import 'api_client.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// ============================================================
// MODEL
// ============================================================
class Catatan {
  final int? id;
  final String judul;
  final String isi;
  final String kategori;
  final String emailPengirim;
  final DateTime dibuatPada;

  Catatan({
    this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.emailPengirim,
    required this.dibuatPada,
  });

  // === Dart object → JSON Map ===
  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'judul': judul,
    'isi': isi,
    'kategori': kategori,
    'email_pengirim': emailPengirim,
    'dibuat_pada': dibuatPada.toUtc().toIso8601String(),
  };

  // === JSON Map → Dart object ===
  static Catatan fromJson(Map<String, dynamic> m) => Catatan(
    id: m['id'] as int?,
    judul: m['judul'] as String,
    isi: m['isi'] as String,
    kategori: m['kategori'] as String,
    emailPengirim: (m['email_pengirim'] as String?) ?? '',
    dibuatPada: DateTime.parse(m['dibuat_pada'] as String),
  );

  // Helper untuk membuat salinan dengan nilai yang diubah (untuk fitur edit)
  Catatan copyWith({
    int? id,
    String? judul,
    String? isi,
    String? kategori,
    String? emailPengirim,
    DateTime? dibuatPada,
  }) {
    return Catatan(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      isi: isi ?? this.isi,
      kategori: kategori ?? this.kategori,
      emailPengirim: emailPengirim ?? this.emailPengirim,
      dibuatPada: dibuatPada ?? this.dibuatPada,
    );
  }
}

// ============================================================
// MY APP
// ============================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/tambah':
            final catatan = settings.arguments as Catatan?;
            return MaterialPageRoute(
                builder: (_) => TambahCatatanPage(catatanEdit: catatan));
          case '/detail':
            final catatan = settings.arguments as Catatan;
            return MaterialPageRoute(
              builder: (_) => DetailCatatanPage(catatan: catatan),
            );
        }
        return null;
      },
    );
  }
}

// ============================================================
// HOME PAGE
// ============================================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // === STATE ===
  late Future<List<Catatan>> _futureCatatan;

  // === TUGAS 2: Filter Kategori ===
  String _filterKategori = 'Semua';
  final _kategoriOpsi = const ['Semua', 'Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    _muatUlang();
  }

  void _muatUlang() {
    setState(() {
      _futureCatatan = ApiClient.instance.getAll();
    });
  }

  String _formatTanggal(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year}';
  }

  Future<void> _bukaForm({Catatan? initial}) async {
    await Navigator.pushNamed(context, '/tambah', arguments: initial);
    _muatUlang();
  }

  Future<void> _konfirmasiHapus(Catatan c) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus catatan?'),
        content: Text('"${c.judul}" akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (yakin == true) {
      try {
        await ApiClient.instance.delete(c.id!);
        if (!mounted) return;
        _muatUlang();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"${c.judul}" dihapus')),
        );
      } on ApiException catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus: ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Mahasiswa'),
        // === TUGAS 2: Dropdown filter di AppBar ===
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _muatUlang,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: DropdownButton<String>(
              value: _filterKategori,
              underline: const SizedBox.shrink(),
              icon: const Icon(Icons.filter_list),
              items: _kategoriOpsi
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) => setState(() => _filterKategori = v!),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/HaimiyaMio.jpg'),
            fit: BoxFit.cover,
            opacity: 0.2, // Transparansi agar teks tetap terbaca
          ),
        ),
        child: FutureBuilder<List<Catatan>>(
          future: _futureCatatan,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              final e = snapshot.error;
              final pesan = e is ApiException ? e.message : 'Terjadi kesalahan: $e';
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 8),
                    Text(pesan, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton(onPressed: _muatUlang, child: const Text('Coba lagi')),
                  ],
                ),
              );
            }
            final data = snapshot.data ?? const [];

            // Terapkan filter kategori
            final tampil = _filterKategori == 'Semua'
                ? data
                : data.where((c) => c.kategori == _filterKategori).toList();

            if (tampil.isEmpty) return const _EmptyState();

            return ListView.builder(
              itemCount: tampil.length,
              itemBuilder: (context, i) {
                final c = tampil[i];
                return ListTile(
                  title: Text(c.judul),
                  subtitle:
                      Text('${c.kategori} • ${_formatTanggal(c.dibuatPada)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _bukaForm(initial: c),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _konfirmasiHapus(c),
                      ),
                    ],
                  ),
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: c,
                    );
                    _muatUlang();
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _bukaForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ============================================================
// EMPTY STATE WIDGET
// ============================================================
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.note_alt_outlined, size: 72, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Belum ada catatan',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Tap tombol + untuk menambahkan catatan baru.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TAMBAH / EDIT CATATAN PAGE
// TUGAS 1: me-reuse halaman ini untuk edit dengan catatanEdit
// TUGAS 3: tambah field Email dengan validasi regex
// ============================================================
class TambahCatatanPage extends StatefulWidget {
  // Jika catatanEdit tidak null → mode Edit, sebaliknya mode Tambah
  final Catatan? catatanEdit;

  const TambahCatatanPage({super.key, this.catatanEdit});

  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _judulCtrl;
  late final TextEditingController _isiCtrl;
  late final TextEditingController _emailCtrl;

  late String _kategori;
  final _kategoriOpsi = const ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  bool get _isEditMode => widget.catatanEdit != null;

  @override
  void initState() {
    super.initState();
    // Jika mode edit, isi field dengan data lama
    final c = widget.catatanEdit;
    _judulCtrl = TextEditingController(text: c?.judul ?? '');
    _isiCtrl = TextEditingController(text: c?.isi ?? '');
    _emailCtrl = TextEditingController(text: c?.emailPengirim ?? '');
    _kategori = c?.kategori ?? 'Kuliah';
  }

  @override
  void dispose() {
    // PENTING: bebaskan resource controller agar tidak memory leak.
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    final catatanBaru = Catatan(
      id: widget.catatanEdit?.id,
      judul: _judulCtrl.text.trim(),
      isi: _isiCtrl.text.trim(),
      kategori: _kategori,
      emailPengirim: _emailCtrl.text.trim(),
      // Pertahankan tanggal asli saat edit, buat baru saat tambah
      dibuatPada: widget.catatanEdit?.dibuatPada ?? DateTime.now(),
    );

    try {
      if (_isEditMode) {
        await ApiClient.instance.update(catatanBaru);
      } else {
        await ApiClient.instance.insert(catatanBaru);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditMode
              ? 'Catatan "${catatanBaru.judul}" diperbarui'
              : 'Catatan "${catatanBaru.judul}" ditambahkan'),
        ),
      );
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: ${e.message}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Catatan' : 'Tambah Catatan'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/HaimiyaMio.jpg'),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // --- Judul ---
              TextFormField(
                controller: _judulCtrl,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Judul wajib diisi';
                  if (v.trim().length < 3) return 'Minimal 3 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // --- Kategori ---
              DropdownButtonFormField<String>(
                value: _kategori,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items: _kategoriOpsi
                    .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                    .toList(),
                onChanged: (v) => setState(() => _kategori = v!),
              ),
              const SizedBox(height: 16),

              // --- Isi ---
              TextFormField(
                controller: _isiCtrl,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Isi',
                  prefixIcon: Icon(Icons.notes),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Isi wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // === TUGAS 3: Field Email Pengirim dengan validasi regex ===
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Pengirim',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Email wajib diisi';
                  }
                  // Validasi regex format email
                  final regexEmail = RegExp(
                    r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
                  );
                  if (!regexEmail.hasMatch(v.trim())) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // --- Tombol Simpan ---
              FilledButton.icon(
                onPressed: _simpan,
                icon: const Icon(Icons.save),
                label: Text(_isEditMode ? 'Perbarui' : 'Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// DETAIL CATATAN PAGE
// TUGAS 1: ada tombol Edit yang membawa kembali ke TambahCatatanPage
// ============================================================
class DetailCatatanPage extends StatelessWidget {
  final Catatan catatan;

  const DetailCatatanPage({
    super.key,
    required this.catatan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        // === TUGAS 1: Tombol Edit di AppBar ===
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Catatan',
            onPressed: () async {
              await Navigator.pushNamed(context, '/tambah', arguments: catatan);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/HaimiyaMio.jpg'),
            fit: BoxFit.cover,
            opacity: 0.2,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(catatan.judul,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Chip(label: Text(catatan.kategori)),
              const SizedBox(height: 4),
              // Tampilkan email pengirim (Tugas 3)
              Row(
                children: [
                  const Icon(Icons.email_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    catatan.emailPengirim,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const Divider(height: 32),
              Text(catatan.isi,
                  style: const TextStyle(fontSize: 16, height: 1.5)),
              const SizedBox(height: 32),
              // Tombol kembali
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali ke Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}