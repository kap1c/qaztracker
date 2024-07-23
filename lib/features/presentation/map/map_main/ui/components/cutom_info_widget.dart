import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qaz_tracker/common/widgets/app_main_button_widget.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'package:qaz_tracker/features/data/map/model/map_animal_history_model.dart';
import 'package:qaz_tracker/features/data/map/model/map_item_model.dart';
import 'package:qaz_tracker/features/presentation/map/map_history/ui/map_animal_history_screen.dart';
import 'dart:math' as math;

import 'package:qaz_tracker/features/presentation/map/map_main/cubit/map_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';

class CustomWindowWidget extends StatelessWidget {
  final MapElement mapElement;

  const CustomWindowWidget({
    super.key,
    required this.mapElement,
  });

  Color get color {
    if (mapElement.battery < 33) {
      return Color(0XFFFF5656);
    } else if (mapElement.battery > 33 && mapElement.battery < 66) {
      return Color(0XFFFFCD44);
    } else {
      return Color(0XFF55C153);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Уровень заряда",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          SizedBox(
            height: 35,
            child: SemicircularIndicator(
              color: color,
              progress: mapElement.battery.toDouble() * 0.01,
              strokeWidth: 10,
              child: Text(
                mapElement.battery.toString() + "%",
                style: TextStyle(
                    color: color, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          const SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(
                      (0.1 * 255).toInt(),
                      55,
                      114,
                      255,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "ID Трекера",
                        style: TextStyle(
                            color: Color(
                              0XFF1C202C,
                            ),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        mapElement.trackerId,
                        style: const TextStyle(
                            color: Color(
                              0XFF3772FF,
                            ),
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(
                      (0.1 * 255).toInt(),
                      55,
                      114,
                      255,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ID ${mapElement.type!.name}",
                        style: TextStyle(
                            color: Color(
                              0XFF1C202C,
                            ),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ), // ??
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        mapElement.id.toString(),
                        style: const TextStyle(
                            color: Color(
                              0XFF3772FF,
                            ),
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(
                      (0.1 * 255).toInt(),
                      55,
                      114,
                      255,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Тип ${mapElement.type!.name}",
                        style: const TextStyle(
                            color: Color(
                              0XFF1C202C,
                            ),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        mapElement.breed != null ? mapElement.breed!.name! : "",
                        style: const TextStyle(
                            color: Color(
                              0XFF3772FF,
                            ),
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(
                      (0.1 * 255).toInt(),
                      55,
                      114,
                      255,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Ферма",
                        style: TextStyle(
                            color: Color(
                              0XFF1C202C,
                            ),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        mapElement.farm,
                        style: const TextStyle(
                            color: Color(
                              0XFF3772FF,
                            ),
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: AppMainButtonWidget(
              text: "История перемещений",
              bgColor: Colors.white,
              borderColor: AppColors.primaryBlueColor,
              textColor: AppColors.primaryBlueColor,
              onPressed: () {
                final mapCubit = context.read<MapCubit>();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: mapCubit,
                        child: MapAnimalHistoryScreen(
                          animalId: mapElement.id,
                        ),
                      ),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SemicirclePainter extends CustomPainter {
  final double strokeWidth;
  final Color strokeColor;

  SemicirclePainter({this.strokeWidth = 10, this.strokeColor = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      3.14,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SemicircleWidget extends StatelessWidget {
  final double width;
  final double height;
  final double strokeWidth;
  final Color strokeColor;

  SemicircleWidget({
    this.width = 200,
    this.height = 100,
    this.strokeWidth = 10,
    this.strokeColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SemicirclePainter(
        strokeWidth: strokeWidth,
        strokeColor: strokeColor,
      ),
      size: Size(width, height),
    );
  }
}
