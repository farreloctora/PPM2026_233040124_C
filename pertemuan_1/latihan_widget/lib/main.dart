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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan Widget'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [

              // =========================
              // LATIHAN 1 - TEXT & STYLING
              // =========================

              const Text(
                'Hello Flutter!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Ini teks biasa dengan ukuran kecil',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 40),

              // =========================
              // LATIHAN 2 - CONTAINER
              // =========================

              Container(
                width: 200,
                height: 200,

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.blue,

                  borderRadius: BorderRadius.circular(20),

                  border: Border.all(
                    color: Colors.black,
                    width: 4,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),

                child: const Center(
                  child: Text(
                    'Box',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // =========================
              // LATIHAN 3 - ROW & COLUMN
              // =========================

              const Text(
                'Row & Column',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [

                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.red,
                  ),

                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.green,
                  ),

                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.blue,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Column(
                children: [

                  Container(
                    width: 120,
                    height: 50,
                    color: Colors.orange,
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: 120,
                    height: 50,
                    color: Colors.purple,
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // =========================
              // LATIHAN 4 - ICON
              // =========================

              const Text(
                'Icon & Bottom Bar Mock-up',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),

                decoration: BoxDecoration(
                  color: Colors.white,

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                    ),
                  ],
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children: const [

                    Icon(
                      Icons.home,
                      size: 32,
                      color: Colors.red,
                    ),

                    Icon(
                      Icons.receipt_long,
                      size: 32,
                      color: Colors.green,
                    ),

                    Icon(
                      Icons.favorite,
                      size: 32,
                      color: Colors.purple,
                    ),

                    Icon(
                      Icons.person,
                      size: 32,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}