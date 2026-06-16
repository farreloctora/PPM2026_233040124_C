import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Helper to handle Assets, Local Files (Mobile), and Blob URLs (Web)
ImageProvider _getImageProvider(String path) {
  if (path.startsWith('assets/')) {
    return AssetImage(path);
  } else if (kIsWeb || path.startsWith('http') || path.startsWith('blob:')) {
    return NetworkImage(path);
  } else {
    return FileImage(File(path));
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // TUGAS 2: theme color soft menggunakan Color(0xFF...)
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C9BCF),
          primary: const Color(0xFF6C9BCF),
          secondary: const Color(0xFF91C8E4),
          surface: const Color(0xFFF5F9FF),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F9FF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF6C9BCF),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const ProfilePage(),
    );
  }
}

// =====================================================================
// PROFILE PAGE — StatefulWidget untuk NavigationBar (Bonus Tugas 6)
// =====================================================================
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 1; // tab Profil aktif

  // State data (Tugas 1 & 2)
  String _imageUrl = 'assets/profile.png';
  String _name = 'M.Farrel Octora R';
  String _about = 'Saya suka belajar hal baru, terutama yang berkaitan dengan teknologi dan data/AI.';
  String _education = 'Universitas Pasundan — Semester 6\nIPK: 3.56';
  String _location = 'Bandung, Indonesia';
  String _contact = 'octorarafa11@gmail.com\n+62 857-2249-7432';
  List<String> _skills = ['SQL', 'Excel', 'Tableau', 'Git', 'Phyton'];

  // Experience (Bonus Tugas 6)
  String _expImage = 'assets/experience.png';
  String _expTitle = 'Intern Flutter Developer';
  String _expDesc = 'Developing mobile applications using Flutter framework.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),

      // ── DRAWER ──────────────────────────────────────────────────────
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // TUGAS 2: DrawerHeader dengan warna soft gradient
            Container(
              height: 160,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6C9BCF), Color(0xFF91C8E4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: _getImageProvider(_imageUrl),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const ListTile(leading: Icon(Icons.home), title: Text('Beranda')),
            const ListTile(leading: Icon(Icons.person), title: Text('Profil')),

            // TUGAS 5: Pengaturan → tampilkan AlertDialog placeholder
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context); // tutup drawer dulu
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Pengaturan'),
                    content: const Text(
                      'Halaman pengaturan belum tersedia.\n'
                          'Fitur ini akan hadir di pembaruan berikutnya.',
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Menu Widget Gallery
            ListTile(
              leading: const Icon(Icons.widgets),
              title: const Text('Widget Gallery'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GalleryHome()),
                );
              },
            ),

            // Menu Edit Pengalaman (Bonus 3b)
            ListTile(
              leading: const Icon(Icons.edit_note),
              title: const Text('Edit Pengalaman'),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditExperiencePage(
                      initialData: {
                        'image': _expImage,
                        'title': _expTitle,
                        'desc': _expDesc,
                      },
                    ),
                  ),
                );

                if (result != null) {
                  setState(() {
                    _expImage = result['image'];
                    _expTitle = result['title'];
                    _expDesc = result['desc'];
                  });
                }
              },
            ),
          ],
        ),
      ),

      // ── BODY ────────────────────────────────────────────────────────
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // === HEADER PROFIL ===
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE8F4FD), Color(0xFFD6EAF8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // TUGAS 1: CircleAvatar dengan Gambar Dinamis (Asset/File)
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _getImageProvider(_imageUrl),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mahasiswa Teknik Informatika',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // === BARIS STATISTIK ===
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Expanded(child: _StatBox(label: 'Post', value: '12')),
                  _VerticalDivider(),
                  Expanded(child: _StatBox(label: 'Teman', value: '128')),
                  _VerticalDivider(),
                  Expanded(child: _StatBox(label: 'Like', value: '1.2K')),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // === SECTION CARD ===
            _SectionCard(
              icon: Icons.info_outline,
              title: 'Tentang Saya',
              content: _about,
            ),
            _SectionCard(
              icon: Icons.school,
              title: 'Pendidikan',
              content: _education,
            ),
            _SectionCard(
              icon: Icons.location_on,
              title: 'Lokasi',
              content: _location,
            ),
            const _SectionCard(
              icon: Icons.favorite,
              title: 'Hobi & Minat',
              content: 'Coding • Membaca • Olahraga • Game',
            ),
            _SectionCard(
              icon: Icons.email,
              title: 'Kontak',
              content: _contact,
            ),

            // TUGAS 3: Section Card ke-5 "Skills" dengan Wrap + Chip
            _SkillsCard(skills: _skills),

            // BONUS 3a: Section Card Pengalaman
            _ExperienceCard(
              image: _expImage,
              title: _expTitle,
              description: _expDesc,
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),

      // TUGAS 4: FAB → Halaman Edit Profil
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditProfilePage(
                initialData: {
                  'imageUrl': _imageUrl,
                  'name': _name,
                  'about': _about,
                  'education': _education,
                  'location': _location,
                  'contact': _contact,
                  'skills': _skills,
                },
              ),
            ),
          );

          if (result != null) {
            setState(() {
              _imageUrl = result['imageUrl'];
              _name = result['name'];
              _about = result['about'];
              _education = result['education'];
              _location = result['location'];
              _contact = result['contact'];
              _skills = result['skills'];
            });
          }
        },
        icon: const Icon(Icons.edit),
        label: const Text('Edit Profil'),
        backgroundColor: const Color(0xFF6C9BCF),
        foregroundColor: Colors.white,
      ),

      // TUGAS 6 BONUS: NavigationBar (Material 3) menggantikan BottomNavigationBar
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFD6EAF8),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
          NavigationDestination(icon: Icon(Icons.message), label: 'Pesan'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }
}

// =====================================================================
// TUGAS 3: Skills Card dengan Wrap + Chip
// =====================================================================
class _SkillsCard extends StatelessWidget {
  final List<String> skills;

  const _SkillsCard({required this.skills});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.star, color: Color(0xFF6C9BCF), size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Skills',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: skills
                        .map(
                          (skill) => Chip(
                        label: Text(skill),
                        backgroundColor: const Color(0xFFE8F4FD),
                        labelStyle: const TextStyle(
                          color: Color(0xFF2C7BB6),
                          fontWeight: FontWeight.w500,
                        ),
                        side: const BorderSide(
                          color: Color(0xFF91C8E4),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// HELPER WIDGETS — PROFILE PAGE
// =====================================================================
class _StatBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.shade300,
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF6C9BCF), size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(content, style: const TextStyle(height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// WIDGET GALLERY
// =====================================================================
class GalleryHome extends StatelessWidget {
  const GalleryHome({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      ('Display', Icons.image, const Color(0xFF6C9BCF)),
      ('Input', Icons.edit, const Color(0xFF58D68D)),
      ('Button', Icons.smart_button, const Color(0xFFF39C12)),
      ('Feedback', Icons.notifications, const Color(0xFF9B59B6)),
      ('Layout', Icons.dashboard, const Color(0xFF1ABC9C)),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Widget Gallery')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final (name, icon, color) = categories[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color,
                child: Icon(icon, color: Colors.white),
              ),
              title: Text(name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryPage(name: name),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String name;

  const CategoryPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final body = switch (name) {
      'Display' => const _DisplayDemo(),
      'Input' => const _InputDemo(),
      'Button' => const _ButtonDemo(),
      'Feedback' => const _FeedbackDemo(),
      'Layout' => const _LayoutDemo(),
      _ => const Center(child: Text('?')),
    };

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: body,
      ),
    );
  }
}

// =====================================================================
// DEMO — DISPLAY
// =====================================================================
class _DisplayDemo extends StatelessWidget {
  const _DisplayDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Card', style: TextStyle(fontWeight: FontWeight.bold)),
        const Card(
          child: ListTile(
            leading: Icon(Icons.album),
            title: Text('Judul Item'),
            subtitle: Text('Sub-judul'),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Chip', style: TextStyle(fontWeight: FontWeight.bold)),
        const Wrap(
          spacing: 8,
          children: [
            Chip(label: Text('Flutter')),
            Chip(label: Text('Dart')),
            Chip(label: Text('Mobile')),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Divider', style: TextStyle(fontWeight: FontWeight.bold)),
        const Divider(thickness: 2),
        const SizedBox(height: 16),
        const Text('CircleAvatar & Icon',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: const [
            CircleAvatar(child: Text('A')),
            SizedBox(width: 12),
            CircleAvatar(
                backgroundColor: Colors.green, child: Icon(Icons.check)),
            SizedBox(width: 12),
            Icon(Icons.star, color: Colors.amber, size: 40),
          ],
        ),
      ],
    );
  }
}

// =====================================================================
// DEMO — INPUT
// =====================================================================
class _InputDemo extends StatefulWidget {
  const _InputDemo();

  @override
  State<_InputDemo> createState() => _InputDemoState();
}

class _InputDemoState extends State<_InputDemo> {
  bool _checked = false;
  bool _switched = true;
  double _slider = 0.5;
  String? _dropdown = 'Apel';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TextField'),
        const SizedBox(height: 4),
        const TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nama',
            hintText: 'Ketik nama Anda',
          ),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Checkbox'),
          value: _checked,
          onChanged: (v) => setState(() => _checked = v ?? false),
        ),
        SwitchListTile(
          title: const Text('Switch'),
          value: _switched,
          onChanged: (v) => setState(() => _switched = v),
        ),
        const Text('Slider'),
        Slider(
          value: _slider,
          onChanged: (v) => setState(() => _slider = v),
        ),
        const SizedBox(height: 8),
        const Text('Dropdown'),
        DropdownButton<String>(
          value: _dropdown,
          items: ['Apel', 'Jeruk', 'Mangga']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => _dropdown = v),
        ),
      ],
    );
  }
}

// =====================================================================
// DEMO — BUTTON
// =====================================================================
class _ButtonDemo extends StatelessWidget {
  const _ButtonDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
        const SizedBox(height: 8),
        FilledButton(onPressed: () {}, child: const Text('Filled')),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
        const SizedBox(height: 8),
        TextButton(onPressed: () {}, child: const Text('Text Button')),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.send),
          label: const Text('Dengan Icon'),
        ),
        const SizedBox(height: 8),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.favorite, color: Colors.red),
        ),
      ],
    );
  }
}

// =====================================================================
// DEMO — FEEDBACK
// =====================================================================
class _FeedbackDemo extends StatelessWidget {
  const _FeedbackDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Halo dari SnackBar!')),
            );
          },
          child: const Text('Tampilkan SnackBar'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Konfirmasi'),
                content: const Text('Yakin ingin lanjut?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ya'),
                  ),
                ],
              ),
            );
          },
          child: const Text('Tampilkan Dialog'),
        ),
        const SizedBox(height: 16),
        const Text('Progress Indicator:'),
        const SizedBox(height: 8),
        const LinearProgressIndicator(value: 0.6),
        const SizedBox(height: 12),
        const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

// =====================================================================
// DEMO — LAYOUT
// =====================================================================
class _LayoutDemo extends StatelessWidget {
  const _LayoutDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Stack — widget bertumpuk'),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: Stack(
            children: [
              Container(
                  width: double.infinity, color: Colors.blue.shade100),
              Positioned(
                top: 12,
                left: 12,
                child:
                Container(width: 50, height: 50, color: Colors.red),
              ),
              const Positioned(
                bottom: 12,
                right: 12,
                child: Icon(Icons.star, size: 40, color: Colors.amber),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('Wrap — auto-pindah baris saat penuh'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            8,
                (i) => Container(
              padding: const EdgeInsets.all(12),
              color: Colors.teal.shade100,
              child: Text('Item ${i + 1}'),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('GridView (count: 3)'),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: List.generate(
              6,
                  (i) => Container(
                color: Colors.purple.shade100,
                alignment: Alignment.center,
                child: Text('${i + 1}'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// BONUS: EXPERIENCE CARD
// =====================================================================
class _ExperienceCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const _ExperienceCard({
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.work, color: Color(0xFF6C9BCF), size: 28),
                SizedBox(width: 16),
                Text(
                  'Pengalaman',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: image.startsWith('assets/')
                  ? Image.asset(
                      image,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 150,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.broken_image),
                      ),
                    )
                  : (kIsWeb || image.startsWith('http') || image.startsWith('blob:'))
                      ? Image.network(
                          image,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 150,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.broken_image),
                          ),
                        )
                      : Image.file(
                          File(image),
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 150,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(description),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// EDIT PROFILE PAGE
// =====================================================================
class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> initialData;

  const EditProfilePage({super.key, required this.initialData});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _urlController;
  late TextEditingController _nameController;
  late TextEditingController _aboutController;
  late TextEditingController _eduController;
  late TextEditingController _locController;
  late TextEditingController _contactController;
  late TextEditingController _skillsController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.initialData['imageUrl']);
    _nameController = TextEditingController(text: widget.initialData['name']);
    _aboutController = TextEditingController(text: widget.initialData['about']);
    _eduController = TextEditingController(text: widget.initialData['education']);
    _locController = TextEditingController(text: widget.initialData['location']);
    _contactController = TextEditingController(text: widget.initialData['contact']);
    _skillsController = TextEditingController(text: widget.initialData['skills'].join(', '));
  }

  @override
  void dispose() {
    _urlController.dispose();
    _nameController.dispose();
    _aboutController.dispose();
    _eduController.dispose();
    _locController.dispose();
    _contactController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- BAGIAN PEMILIH GAMBAR ---
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: _getImageProvider(_urlController.text),
                    onBackgroundImageError: (_, __) {},
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 20,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image =
                              await picker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              _urlController.text = image.path;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                )),
            const SizedBox(height: 16),
            TextField(
                controller: _aboutController,
                decoration: const InputDecoration(
                  labelText: 'Tentang Saya',
                  prefixIcon: Icon(Icons.info_outline),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3),
            const SizedBox(height: 16),
            TextField(
                controller: _eduController,
                decoration: const InputDecoration(
                  labelText: 'Pendidikan',
                  prefixIcon: Icon(Icons.school),
                  border: OutlineInputBorder(),
                ),
                maxLines: 2),
            const SizedBox(height: 16),
            TextField(
                controller: _locController,
                decoration: const InputDecoration(
                  labelText: 'Lokasi',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                )),
            const SizedBox(height: 16),
            TextField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Kontak',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                maxLines: 2),
            const SizedBox(height: 16),
            TextField(
                controller: _skillsController,
                decoration: const InputDecoration(
                  labelText: 'Skills (pisahkan dengan koma)',
                  prefixIcon: Icon(Icons.star_border),
                  border: OutlineInputBorder(),
                )),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C9BCF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(context, {
                    'imageUrl': _urlController.text,
                    'name': _nameController.text,
                    'about': _aboutController.text,
                    'education': _eduController.text,
                    'location': _locController.text,
                    'contact': _contactController.text,
                    'skills': _skillsController.text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList(),
                  });
                },
                child: const Text('Simpan Perubahan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// EDIT EXPERIENCE PAGE
// =====================================================================
class EditExperiencePage extends StatefulWidget {
  final Map<String, String> initialData;
  const EditExperiencePage({super.key, required this.initialData});

  @override
  State<EditExperiencePage> createState() => _EditExperiencePageState();
}

class _EditExperiencePageState extends State<EditExperiencePage> {
  late TextEditingController _imgController;
  late TextEditingController _titleController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _imgController = TextEditingController(text: widget.initialData['image']);
    _titleController = TextEditingController(text: widget.initialData['title']);
    _descController = TextEditingController(text: widget.initialData['desc']);
  }

  @override
  void dispose() {
    _imgController.dispose();
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Pengalaman')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- PRATINJAU GAMBAR PENGALAMAN ---
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 180,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _imgController.text.startsWith('assets/')
                        ? Image.asset(
                            _imgController.text,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image, size: 50, color: Colors.grey),
                          )
                        : (kIsWeb || _imgController.text.startsWith('blob:'))
                            ? Image.network(
                                _imgController.text,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                    Icons.image,
                                    size: 50,
                                    color: Colors.grey),
                              )
                            : Image.file(
                                File(_imgController.text),
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                    Icons.image,
                                    size: 50,
                                    color: Colors.grey),
                              ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: FloatingActionButton.small(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              _imgController.text = image.path;
                            });
                          }
                        },
                        child: const Icon(Icons.edit_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Pengalaman',
                  border: OutlineInputBorder(),
                )),
            const SizedBox(height: 16),
            TextField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Singkat',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C9BCF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(context, {
                    'image': _imgController.text,
                    'title': _titleController.text,
                    'desc': _descController.text,
                  });
                },
                child: const Text('Simpan Pengalaman', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
