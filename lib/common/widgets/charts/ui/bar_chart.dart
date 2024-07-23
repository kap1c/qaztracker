// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
// import 'package:qaz_tracker/common/widgets/drop_down_menu/app_dropdown_menu.dart';
// import 'package:qaz_tracker/common/widgets/filter/ui/filter_widget.dart';
// import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'package:qaz_tracker/features/data/home/model/home_info_model.dart';
import 'package:qaz_tracker/features/presentation/farm/ui/farm_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarChartWidget extends StatefulWidget {
  final bool isVertical;
  dynamic information;
  BarChartWidget({super.key, required this.isVertical, this.information});

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  List<ChartData> data = [];

  @override
  void initState() {
    if (widget.information.runtimeType == HomeTrackers) {
      widget.information as HomeTrackers;
      (widget.information.homeTrackerList).forEach((element) {
        data.add(ChartData(
            element.regionName,
            element.total,
            const Color(
              0XFF3772FF,
            )));
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(
            0XFFE8E9EE,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, 8.0),
            child: Text(
              "Количество трекеров по областям",
              style: TextStyle(
                color: Color(0XFF1C202C),
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 16,
              bottom: 3,
            ),
            child: AppBarChartWidget(
              data: data,
              isVertical: widget.isVertical,
            ),
          ),
        ],
      ),
    );
  }
}

class AppBarChartWidget extends StatelessWidget {
  AppBarChartWidget({
    super.key,
    required this.data,
    required this.isVertical,
  });
  final bool isVertical;
  final List<ChartData> data;

  double maxValue = 0;
  final TooltipBehavior _tooltip = TooltipBehavior(enable: true);

  @override
  Widget build(BuildContext context) {
    data.forEach((element) {
      if (maxValue < element.y) {
        maxValue = element.y;
      }
    });

    data.removeWhere((element) => element.y == 0 || element.y == null);

    return SfCartesianChart(
      isTransposed: isVertical,
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: maxValue + maxValue * .1,
      ),
      tooltipBehavior: _tooltip,
      title: ChartTitle(
        text: data.isEmpty ? "Нет данных" : "",
        textStyle: const TextStyle(
          color: Color(0XFF1C202C),
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      series: <CartesianSeries<ChartData, String>>[
        BarSeries<ChartData, String>(
          dataSource: data,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          borderRadius: isVertical == true
              ? BorderRadius.circular(0)
              : BorderRadius.circular(8),
          width: 0.25,
          onCreateRenderer: (series) =>
              _CustomColumnSeriesRenderer(isVertical: isVertical),
        )
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}

// class _CustomColumnSeriesRenderer extends BarSeriesRenderer {
//   bool isVertical;
//   _CustomColumnSeriesRenderer({required this.isVertical});

//   @override
//   BarSegment createSegment() {
//     return _ColumnCustomPainter(isVertical: isVertical);
//   }
// }

class _CustomColumnSeriesRenderer extends ColumnSeriesRenderer<ChartData, String> {
  bool isVertical;
  _CustomColumnSeriesRenderer({required this.isVertical});

  @override
  ColumnSegment<ChartData, String> createSegment() {
    return _ColumnCustomPainter(isVertical: isVertical);
  }
}

// class _ColumnCustomPainter extends BarSegment {
//   bool isVertical;

//   _ColumnCustomPainter({required this.isVertical});

//   @override
//   Paint getFillPaint() {
//     final Paint customerFillPaint = Paint();
//     customerFillPaint.isAntiAlias = false;
//     customerFillPaint.color = isVertical == false
//         ? Color(0XFF3772FF)
//         : returnRandomColor(currentSegmentIndex!);
//     customerFillPaint.style = PaintingStyle.fill;

//     return customerFillPaint;
//   }
// }
class _ColumnCustomPainter extends ColumnSegment<ChartData, String> {
      bool isVertical;
      _ColumnCustomPainter({required this.isVertical});

      @override
      int get currentSegmentIndex => super.currentSegmentIndex;

      @override
      Paint getFillPaint() {
        final Paint customerFillPaint = Paint();
        customerFillPaint.color = series.dataSource![currentSegmentIndex].y > 30
          ? Colors.red
          : Colors.green;
        customerFillPaint.style = PaintingStyle.fill;
        return customerFillPaint;
      }

      @override
      void onPaint(Canvas canvas) {
        super.onPaint(canvas);
      }
    }
