import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TipsListScreen extends StatelessWidget {
  const TipsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tips for you',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTipCard(
            context,
            title: 'How to find a perfect job for you',
            author: 'Sarah Bolinas',
            authorTitle: 'Head of Human Capital at Facebook',
            color: const Color(0xFF3366FF),
            imageUrl: '',
          ),
          const SizedBox(height: 16),
          _buildTipCard(
            context,
            title: 'How to build the strong profile',
            author: 'John Doe',
            authorTitle: 'Career Coach',
            color: const Color(0xFFFFB800),
            imageUrl: '',
          ),
          const SizedBox(height: 16),
          _buildTipCard(
            context,
            title: 'Top 10 most searched skills',
            author: 'Jane Smith',
            authorTitle: 'HR Manager at Google',
            color: const Color(0xFFFF6B6B),
            imageUrl: '',
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(
    BuildContext context, {
    required String title,
    required String author,
    required String authorTitle,
    required Color color,
    required String imageUrl,
  }) {
    return GestureDetector(
      onTap: () {
        context.push('/tips-detail', extra: {
          'title': title,
          'author': author,
          'authorTitle': authorTitle,
          'color': color,
          'imageUrl': imageUrl,
        });
      },
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Person illustration area
            Positioned(
              right: 0,
              bottom: 0,
              top: 0,
              width: 150,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: Container(
                  color: Colors.white.withOpacity(0.05),
                  child: Stack(
                    children: [
                      // Background circle decoration
                      Positioned(
                        right: -30,
                        bottom: -20,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                      // Person icon
                      Positioned(
                        right: 10,
                        bottom: 0,
                        child: Icon(
                          Icons.person,
                          size: 120,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Text content area
            Positioned(
              left: 20,
              top: 20,
              bottom: 20,
              child: SizedBox(
                width: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      author,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      authorTitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
