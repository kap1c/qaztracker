import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:qaz_tracker/common/widgets/charts/ui/bar_chart.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'dart:math';

import 'package:qaz_tracker/features/data/farm/model/tracking_diagram.dart';
import 'package:qaz_tracker/features/data/farm/model/trackings_model.dart';

class FarmChart extends StatefulWidget {
  FarmChart({
    Key? key,
    required this.dataStream,
  }) : super(key: key);

  final Stream<List<FarmTracking>> dataStream;

  @override
  _FarmChartState createState() => _FarmChartState();
}

enum DataToDisplay { steps, speed, range, network, battery }

class _FarmChartState extends State<FarmChart> {
  bool showLineChart = true;
  List<List<FlSpot>> lineData = [];
  List<ChartData> barData = [];

  DataToDisplay dataToDisplay = DataToDisplay.steps;
  List<FarmTracking> data = [];

  @override
  void initState() {
    widget.dataStream.listen((data) {
      updateLineData(data);
      updateBarData(data);
      setState(() {
        this.data = data;
      });
    });
    super.initState();
  }

  int index = 0;

  void updateLineData(
    List<FarmTracking> data,
  ) {
    lineData.clear();

    for (FarmTracking item in data) {
      List<FlSpot> sublist = [];
      int i = 1;
      if (item.diagram == null || item.diagram!.isEmpty) {
        continue;
      }

      for (TrackingDiagramInformation? diagraminformation in item.diagram!) {
        if (dataToDisplay == DataToDisplay.steps) {
          sublist
              .add(FlSpot(i.toDouble(), diagraminformation!.steps!.toDouble()));
        } else if (dataToDisplay == DataToDisplay.speed) {
          sublist.add(
              FlSpot(i.toDouble(), diagraminformation!.gpsSpeed!.toDouble()));
        } else if (dataToDisplay == DataToDisplay.range) {
          sublist.add(
              FlSpot(i.toDouble(), diagraminformation!.gpsRange!.toDouble()));
        } else if (dataToDisplay == DataToDisplay.network) {
          sublist.add(
              FlSpot(i.toDouble(), diagraminformation!.network!.toDouble()));
        }
        i++;
      }
      lineData.add(sublist);
      i = 1;
    }
    setState(() {});
  }

  void updateBarData(List<FarmTracking> passedBarData) {
    barData.clear();

    for (FarmTracking item in passedBarData) {
      List<ChartData> sublist = [];
      int i = 1;
      if (item.diagram == null || item.diagram!.isEmpty) {
        continue;
      }
      // ignore: unused_local_variable
      TrackingDiagramInformation? diagraminformation = item.diagram?.last;
      if (dataToDisplay == DataToDisplay.steps) {
        sublist.add(
          ChartData(
            item.farmName!,
            diagraminformation!.steps!.toDouble(),
            returnRandomColor(
              passedBarData.indexOf(item),
            ),
          ),
        );
      } else if (dataToDisplay == DataToDisplay.speed) {
        sublist.add(
          ChartData(
            item.farmName!,
            diagraminformation!.gpsSpeed!.toDouble(),
            returnRandomColor(
              passedBarData.indexOf(item),
            ),
          ),
        );
      } else if (dataToDisplay == DataToDisplay.range) {
        sublist.add(
          ChartData(
            item.farmName!,
            diagraminformation!.gpsRange!.toDouble(),
            returnRandomColor(
              passedBarData.indexOf(item),
            ),
          ),
        );
      } else if (dataToDisplay == DataToDisplay.network) {
        sublist.add(
          ChartData(
              item.farmName!,
              diagraminformation!.network!.toDouble(),
              returnRandomColor(
                passedBarData.indexOf(item),
              )),
        );
      }
      i++;
      barData.addAll(sublist);
      i = 1;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.65,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0XFFE8E9EE),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            dataToDisplay = DataToDisplay.steps;
                            updateLineData(data);
                            updateBarData(data);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: dataToDisplay == DataToDisplay.steps
                                ? const Color(0XFF3772FF)
                                : const Color(0XFFF0F1F5),
                          ),
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                          margin: const EdgeInsets.only(right: 10),
                          child: Text(
                            "Шаги",
                            style: TextStyle(
                              color: (dataToDisplay == DataToDisplay.steps
                                  ? Colors.white
                                  : Colors.black),
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            dataToDisplay = DataToDisplay.speed;
                            updateLineData(data);
                            updateBarData(data);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: dataToDisplay == DataToDisplay.speed
                                ? const Color(0XFF3772FF)
                                : const Color(0XFFF0F1F5),
                          ),
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                          child: Text(
                            "Скорость",
                            style: TextStyle(
                              color: (dataToDisplay == DataToDisplay.speed
                                  ? Colors.white
                                  : Colors.black),
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            dataToDisplay = DataToDisplay.range;
                            updateLineData(data);
                            updateBarData(data);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: dataToDisplay == DataToDisplay.range
                                ? const Color(0XFF3772FF)
                                : const Color(0XFFF0F1F5),
                          ),
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                          child: Text(
                            "Расстояние",
                            style: TextStyle(
                              color: (dataToDisplay == DataToDisplay.range
                                  ? Colors.white
                                  : Colors.black),
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            showLineChart = false;
                          });
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: showLineChart == false
                                  ? const Color(0XFF3772FF)
                                  : const Color(0XFFE8E9EE),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Icon(
                            Icons.graphic_eq,
                            size: 15,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () => setState(() {
                          showLineChart = true;
                        }),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: showLineChart == true
                                  ? const Color(0XFF3772FF)
                                  : const Color(0XFFE8E9EE),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Icon(
                            Icons.show_chart,
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: showLineChart
                      ? LineChart(
                          LineChartData(
                            titlesData: FlTitlesData(
                              topTitles: AxisTitles(
                                  axisNameWidget: Text(
                                    lineData.isEmpty ? "Нет данных" : "",
                                    style: const TextStyle(
                                      color: Color(0XFF1C202C),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                  sideTitles: SideTitles(

                                      )),
                              rightTitles: AxisTitles(),
                            ),
                            gridData: FlGridData(
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                    color: const Color(0xffCCCCCC),
                                    strokeWidth: 1,
                                    dashArray: [2, 2]);
                              },
                              getDrawingVerticalLine: (value) {
                                return FlLine(
                                    color: const Color(0xffCCCCCC),
                                    strokeWidth: 1,
                                    dashArray: [2, 2]);
                              },
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            lineBarsData: lineData.map((e) {
                              return LineChartBarData(
                                lineChartStepData: LineChartStepData(
                                  stepDirection:
                                      LineChartStepData.stepDirectionForward,
                                ),
                                spots: e,
                                isCurved: false,
                                barWidth: 3,
                                color: returnRandomColor(lineData.indexOf(e)),
                                dotData: FlDotData(
                                  getDotPainter:
                                      (error, defaultError, code, p3) {
                                    return FlDotCirclePainter(
                                      color: returnRandomColor(
                                          lineData.indexOf(e)),
                                      radius: 2,
                                    );
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                          curve: Curves.decelerate,
                          duration: const Duration(
                            seconds: 1,
                          ),
                        )
                      : AppBarChartWidget(
                          isVertical: true,
                          data: barData,
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 24,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0XFFE8E9EE),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListView(
                padding: const EdgeInsets.only(top: 10),
                children: data.map((e) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16),
                    child: Row(
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: returnRandomColor(data.indexOf(e)),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(e.farmName.toString()),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color returnRandomColor(int number) {
  final random = Random(number);

  return Color.fromRGBO(
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
    1.0,
  );
}
