import 'package:finance_app/modules/analytic/widgets/gradient_line_chart.dart';
import 'package:flutter/material.dart';

class AnalyticView extends StatelessWidget {
  const AnalyticView({super.key});

  @override
  Widget build(BuildContext context) {
    const values = [10.0, 25.0, 18.0];


    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: 700,
          width: double.infinity,
          child: CustomPaint(
            painter: StaticLineChartPainter(
              values: values,
              minYFactor: 0.3,
              gradientColor: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
      ),
    );
  }
}
