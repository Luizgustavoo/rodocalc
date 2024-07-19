import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class CustomChart extends StatelessWidget {
  const CustomChart({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      {'type': 'A', 'value': 3},
      {'type': 'B', 'value': 6},
      {'type': 'C', 'value': 8},
      {'type': 'D', 'value': 5},
    ];

    final colorMap = {
      'A': Colors.greenAccent,
      'B': Colors.lightBlueAccent,
      'C': Colors.greenAccent,
      'D': Colors.lightBlueAccent,
    };

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Chart(
        data: data,
        variables: {
          'type': Variable(
            accessor: (Map datum) => datum['type'] as String,
            scale: OrdinalScale(inflate: true),
          ),
          'value': Variable(
            accessor: (Map datum) => datum['value'] as num,
            scale: LinearScale(min: 0, max: 10),
          ),
        },
        marks: [
          IntervalMark(
            position: Varset('type') * Varset('value'),
            color: ColorEncode(
              variable: 'type',
              values: colorMap.values.toList(),
            ),
          ),
        ],
        axes: [
          Defaults.horizontalAxis,
          Defaults.verticalAxis,
        ],
        selections: {
          'tap': PointSelection(
            on: {GestureType.tap},
            dim: Dim.x,
          ),
        },
        tooltip: TooltipGuide(
          followPointer: [true, true],
          align: Alignment.topLeft,
          variables: ['type', 'value'],
        ),
        crosshair: CrosshairGuide(
          followPointer: [false, true],
        ),
      ),
    );
  }
}
