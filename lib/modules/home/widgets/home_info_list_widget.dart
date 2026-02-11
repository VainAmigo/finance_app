import 'package:finance_app/themes/themes.dart';
import 'package:flutter/material.dart';

class HomeInfoListWidget extends StatelessWidget {
  const HomeInfoListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizing.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSizing.spaceBtwElements,
        children: [
          Container(height: 200, color: Colors.red),
          Container(height: 500, color: Colors.blue),
          Container(height: 300, color: Colors.green),
        ],
      ),
    );
  }
}
