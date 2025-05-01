import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  // List of about categories
  late final List<AboutCategory> _aboutCategories;

  @override
  void initState() {
    super.initState();
    _aboutCategories = [
      AboutCategory(
        title: 'Terms of Service',
        onTap: () {
          // Navigate to Terms of Service page
          _showDetailsPage('Terms of Service');
        },
      ),
      AboutCategory(
        title: 'Privacy Policy',
        onTap: () {
          // Navigate to Privacy Policy page
          _showDetailsPage('Privacy Policy');
        },
      ),
      AboutCategory(
        title: 'Licenses and Registrations',
        onTap: () {
          // Navigate to Licenses and Registrations page
          _showDetailsPage('Licenses and Registrations');
        },
      ),
    ];
  }

  void _showDetailsPage(String title) {
    // This is a placeholder for navigation to specific pages
    // You can implement actual navigation to specific pages later
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title page will be implemented soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "About",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView.builder(
        itemCount: _aboutCategories.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              _buildAboutCategoryTile(_aboutCategories[index]),
              if (index < _aboutCategories.length - 1)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey[200],
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAboutCategoryTile(AboutCategory category) {
    return InkWell(
      onTap: category.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class AboutCategory {
  final String title;
  final VoidCallback onTap;

  AboutCategory({
    required this.title,
    required this.onTap,
  });
}
