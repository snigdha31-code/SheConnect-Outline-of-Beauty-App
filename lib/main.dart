import 'dart:async';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() {
  runApp(const MyApp());
}

// Main App
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SheConnect',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

// Home Page with auto-sliding, infinite forward PageView + SmoothPageIndicator
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> imageUrls = const [
    'https://plus.unsplash.com/premium_photo-1702598541431-0ae484ec359d?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1634449571010-02389ed0f9b0?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aGFpciUyMHNhbG9ufGVufDB8fDB8fHww',
    'https://images.unsplash.com/photo-1717160675332-1a8d1080ae3d?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fHNhbG9uJTIwaGFpcnxlbnwwfHwwfHx8MA%3D%3D'
  ];

  late PageController _pageController;
  int _currentPage = 1000; // large number for infinite forward scroll
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[500],
        elevation: 4,
        centerTitle: true,
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Column(
          children: const [
            Text(
              'SheConnect',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Your Lifestyle, Your Way',
              style: TextStyle(
                  fontSize: 14, fontStyle: FontStyle.italic, color: Colors.white70),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://media.istockphoto.com/vectors/letter-at-colorful-speech-bubble-and-heart-background-vector-id1182815428?k=6&m=1182815428&s=612x612&w=0&h=o8kVCt2rYANCzCyqmA84dYfxhU_DYFstVow55lLXAfI='),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                color: Colors.black.withOpacity(0.4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'SheConnect',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your Lifestyle, Your Way',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart_outlined, color: Colors.purple),
              title: const Text('Cart'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Appointments(),
                  ),
                );
              },
            ),
            const ListTile(
              leading: Icon(Icons.settings, color: Colors.purple),
              title: Text('Settings'),
            ),
            const ListTile(
              leading: Icon(Icons.wallet_membership_rounded, color: Colors.purple),
              title: Text('Wallet'),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.local_offer_outlined, color: Colors.purple),
              title: Text(
                "COMMUNICATION",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.offline_pin_rounded, color: Colors.purple),
              title: Text('Offers'),
            ),
            const ListTile(
              leading: Icon(Icons.people, color: Colors.purple),
              title: Text('Refer a Friend'),
            ),
            const ListTile(
              leading: Icon(Icons.play_arrow_outlined, color: Colors.purple),
              title: Text('Tie Up'),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 500, // taller images
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PageView.builder(
  controller: _pageController,
  onPageChanged: (index) {
    setState(() {
      _currentPage = index;
    });
  },
  itemBuilder: (context, index) {
    // Use modulo to loop images
    final imageIndex = index % imageUrls.length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrls[imageIndex],
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  },
),

                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: imageUrls.length,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: Colors.purple,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.purple,
        color: Colors.white,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.shopping_cart, title: 'Cart'),
          TabItem(icon: Icons.people, title: 'People'),
        ],
        onTap: (int i) {},
      ),
      
    );
  }
}



// Appointments Page
class Appointments extends StatelessWidget {
  const Appointments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          'Appointments',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: Colors.purple[100],
        height: 500,
        width: double.infinity,
        alignment: Alignment.center,
        child: const Text(
          'YOUR APPOINTMENTS',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
      ),
    );
  }
}
