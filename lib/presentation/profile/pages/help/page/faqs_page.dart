import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FAQsPage extends StatelessWidget {
  const FAQsPage({Key? key}) : super(key: key);

  final List<Map<String, String>> faqs = const [
    {
      'question': 'How do I track my order?',
      'answer': 'You can track your order by going to the "Orders" section in your profile and selecting the order you want to track.'
    },
    {
      'question': 'How can I change my delivery address?',
      'answer': 'You can change your delivery address by going to your profile, selecting "Address Book", and adding or editing your addresses.'
    },
    {
      'question': 'What payment methods are accepted?',
      'answer': 'We accept credit/debit cards, digital wallets, and cash on delivery in select areas.'
    },
    {
      'question': 'How do I contact customer support?',
      'answer': 'You can contact our customer support team through the "Help" section in your profile or by emailing support@example.com.'
    },
    {
      'question': 'Can I cancel my order?',
      'answer': 'Yes, you can cancel your order before it is prepared. Go to your order details and select "Cancel Order".'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "FAQs",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(
              faqs[index]['question']!,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                  faqs[index]['answer']!,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
