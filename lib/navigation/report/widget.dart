import 'package:flutter/material.dart';
import 'package:kaist_map/constant/colors.dart';

class ReportTab extends StatelessWidget {
  const ReportTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KMapColors.darkBlue.shade100,
      appBar: AppBar(
        backgroundColor: KMapColors.darkBlue.shade100,
        centerTitle: true,
        title: const Text(
          '제보',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Handle image input
              },
              child: const Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
