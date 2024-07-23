import 'package:flutter/material.dart';

class AppLoaderWidget extends StatelessWidget {
  const AppLoaderWidget({
    Key? key,
    this.color,
  }) : super(key: key);
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child:
          SizedBox(height: 22, width: 22, child: CircularProgressIndicator()),
    );
  }
}
