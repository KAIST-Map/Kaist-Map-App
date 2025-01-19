import 'package:flutter/material.dart';

class KMapMyPage extends StatelessWidget {
  const KMapMyPage({super.key});

  Future<String> fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'Hello, KAIST!';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: FutureBuilder<String>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Center(child: Text('Data: ${snapshot.data}'));
            }
          },
        ),
      ),
    );
  }
}
