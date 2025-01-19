import 'package:flutter/material.dart';

class KMapRoutingPage extends StatelessWidget {
  const KMapRoutingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0), // set the height here
        child: AppBar(
        
        title: Column(
          children: [
            TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                      ),
            ),
            SizedBox(width: 10),
            TextField(
                      decoration: InputDecoration(
                        hintText: 'Destination...',
                      ),
            ),
          ],
        ),
      ),
      ),
      body: Center(
        child: Text('Welcome to KAIST Map Navigation!'),
      ),
    );
  }
}
