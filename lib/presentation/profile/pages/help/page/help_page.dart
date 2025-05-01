import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'legal_terms_page.dart';
import 'general_issues_page.dart';
import 'previous_orders_issues_page.dart';
import 'faqs_page.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  // List of help categories
  late final List<HelpCategory> _helpCategories;

  @override
  void initState() {
    super.initState();
    _helpCategories = [
      HelpCategory(
        title: 'Legal Terms & Conditions',
        onTap: () {},
      ),
      HelpCategory(
        title: 'General Issues',
        onTap: () {},
      ),
      HelpCategory(
        title: 'Issues with previous orders',
        onTap: () {},
      ),
      HelpCategory(
        title: 'FAQs',
        onTap: () {},
      ),
    ];
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
          "Help",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView.builder(
        itemCount: _helpCategories.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              _buildHelpCategoryTile(_helpCategories[index]),
              if (index < _helpCategories.length - 1)
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

  Widget _buildHelpCategoryTile(HelpCategory category) {
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

class HelpCategory {
  final String title;
  final VoidCallback onTap;

  HelpCategory({
    required this.title,
    required this.onTap,
  });
}
