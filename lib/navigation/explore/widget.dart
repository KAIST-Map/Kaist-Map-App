import 'package:flutter/material.dart';

class KMapExplore extends StatefulWidget {
  const KMapExplore({super.key});

  @override
  State<KMapExplore> createState() => _KMapExploreState();
}

class _KMapExploreState extends State<KMapExplore> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Explore KAIST Map'),
    );
  }
}
