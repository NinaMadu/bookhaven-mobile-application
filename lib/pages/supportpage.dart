import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatelessWidget {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // Dummy send email function
  Future<void> _sendEmail() async {
    final String subject = _subjectController.text;
    final String message = _messageController.text;
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@example.com',
      queryParameters: {
        'subject': subject,
        'body': message,
      },
    );
    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      throw 'Could not launch email client';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Support & Help"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 251, 251, 251),
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Contact Us Section
            const Text(
              "Need More Help?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.phone, size: 40, color: Colors.blue),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Contact Us",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text("Phone: +123 456 7890"),
                        Text("Email: support@example.com"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // FAQ Section with Dropdown Answers
            const Text(
              "Frequently Asked Questions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ..._buildFaqItems(),

            const SizedBox(height: 20),

            // Subject TextField
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: "Subject",
                labelStyle: const TextStyle(color: Color.fromARGB(255, 30, 85, 131)), // Blue label
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 30, 85, 131)), // Blue focused border
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Message TextField
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Message",
                labelStyle: const TextStyle(color: Color.fromARGB(255, 30, 85, 131)), // Blue label
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 30, 85, 131)), // Blue focused border
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Send Email Button
            ElevatedButton(
              onPressed: _sendEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 31, 92, 143), 
                foregroundColor: Colors.white// Blue button
              ),
              child: const Text("Send Email"),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build FAQ items with dropdown answers
  List<Widget> _buildFaqItems() {
    final faqData = [
      {
        "question": "How do I track my order?",
        "answer": "You can track your order in the 'My Orders' section of your account. Once an order is shipped, a tracking ID will be provided."
      },
      {
        "question": "What are the payment options?",
        "answer": "We accept credit/debit cards, online wallets, and cash on delivery in selected regions."
      },
      {
        "question": "How do I return a product?",
        "answer": "Go to the 'My Orders' section, select the order, and click on the 'Return' option to start the process."
      },
      {
        "question": "How do I reset my password?",
        "answer": "Click on 'Forgot Password' on the login page and follow the instructions sent to your email."
      },
    ];

    return faqData.map((faq) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 3,
        child: ExpansionTile(
          title: Text(
            faq["question"]!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          leading: const Icon(Icons.question_answer, color: Colors.blue),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                faq["answer"]!,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
