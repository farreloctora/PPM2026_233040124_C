import 'package:flutter/material.dart';

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
          background: const Color(0xFFF5F9FF),
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
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(
                        'https://avatars.githubusercontent.com/u/9919?v=4',
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'M.Farrel Octora R',
                      style: TextStyle(
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
                  // TUGAS 1: CircleAvatar dengan NetworkImage (foto GitHub)
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://avatars.githubusercontent.com/u/146091477?v=4',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'M.Farrel Octora R',
                    style: TextStyle(
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
            const _SectionCard(
              icon: Icons.info_outline,
              title: 'Tentang Saya',
              content:
              'Saya suka belajar hal baru, terutama yang berkaitan '
                  'dengan teknologi dan data/AI.',
            ),
            const _SectionCard(
              icon: Icons.school,
              title: 'Pendidikan',
              content: 'Universitas Pasundan — Semester 6\nIPK: 3.56',
            ),
            const _SectionCard(
              icon: Icons.favorite,
              title: 'Hobi & Minat',
              content: 'Coding • Membaca • Olahraga • Game',
            ),
            const _SectionCard(
              icon: Icons.email,
              title: 'Kontak',
              content: 'octorarafa11@gmail.com\n+62 857-2249-7432',
            ),

            // TUGAS 3: Section Card ke-5 "Skills" dengan Wrap + Chip
            _SkillsCard(),

            const SizedBox(height: 80),
          ],
        ),
      ),

      // TUGAS 4: FAB → SnackBar "Edit profil belum tersedia"
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Edit profil belum tersedia'),
              backgroundColor: const Color(0xFF6C9BCF),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
        icon: const Icon(Icons.edit),
        label: const Text('Edit'),
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
  final List<String> skills = const [
    'SQL',
    'Excel',
    'Tableau',
    'Git',
    'Phyton',
  ];

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