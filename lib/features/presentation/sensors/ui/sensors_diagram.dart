import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:qaz_tracker/common/widgets/app_base_state_widget.dart';
import 'package:qaz_tracker/common/widgets/charts/ui/bar_chart.dart';
import 'package:qaz_tracker/common/widgets/filter/cubit/filter_cubit.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'dart:math';

import 'package:qaz_tracker/features/data/farm/model/tracking_diagram.dart';
import 'package:qaz_tracker/features/data/farm/model/trackings_model.dart';
import 'package:qaz_tracker/features/presentation/farm/ui/farm_chart.dart';

class SensorsChart extends StatefulWidget {
  SensorsChart({
    Key? key,
    required this.dataStream,
    required this.queryParameter,
  }) : super(key: key);
  ValueNotifier<Map<String, dynamic>> queryParameter;
  final Stream<List<FarmTracking>> dataStream;

  @override
  _FarmChartState createState() => _FarmChartState();
}

enum DataToDisplay { steps, speed, range, network, battery }

class _FarmChartState extends State<SensorsChart> {
  bool showLineChart = false;
  List<List<FlSpot>> lineData = [];
  List<ChartData> barData = [];
  late FilterCubit _filterCubit;
  DataToDisplay dataToDisplay = DataToDisplay.network;
  List<FarmTracking> data = [];

  @override
  void initState() {
    super.initState();
    _filterCubit = context.read<FilterCubit>();
    widget.dataStream.listen((data) {
      setState(() {
        updateBarData(data);
        updateLineData(data);
        this.data = data;
      });
    });
  }

  void updateLineData(
    List<FarmTracking> data,
  ) {
    lineData = [];

    for (FarmTracking item in data) {
      List<FlSpot> sublist = [];
      int i = 1;
      if (item.diagram == null || item.diagram!.isEmpty) {
        continue;
      }
      // ignore: unused_local_variable
      if (item.diagram!.isNotEmpty) {
        for (TrackingDiagramInformation? diagraminformation in item.diagram!) {
          if (dataToDisplay == DataToDisplay.battery) {
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
    }
    setState(() {});
  }

  void updateBarData(List<FarmTracking> passedBarData) {
    barData.clear();
    int i = 0;
    for (FarmTracking item in passedBarData) {
      List<ChartData> sublist = [];
      if (item.diagram == null || item.diagram!.isEmpty) {
        continue;
      }
      if (dataToDisplay == DataToDisplay.battery) {
        sublist.add(
          ChartData(
            item.farmName!,
            item.battery!.toDouble(),
            returnRandomColor(passedBarData.indexOf(item)),
          ),
        );
      } else if (dataToDisplay == DataToDisplay.network) {
        sublist.add(
          ChartData(
            item.farmName!,
            item.network!.toDouble(),
            returnRandomColor(passedBarData.indexOf(item)),
          ),
        );
      }
      barData.addAll(sublist);
      i++;
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
                            dataToDisplay = DataToDisplay.network;
                            updateBarData(data);
                            updateLineData(data);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: dataToDisplay == DataToDisplay.network
                                ? const Color(0XFF3772FF)
                                : const Color(0XFFF0F1F5),
                          ),
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                          margin: const EdgeInsets.only(right: 10),
                          child: Text(
                            "Сеть",
                            style: TextStyle(
                              color: (dataToDisplay == DataToDisplay.network
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
                            dataToDisplay = DataToDisplay.battery;
                            updateBarData(data);
                            updateLineData(data);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: dataToDisplay == DataToDisplay.battery
                                ? const Color(0XFF3772FF)
                                : const Color(0XFFF0F1F5),
                          ),
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                          child: Text(
                            "Батарея",
                            style: TextStyle(
                              color: (dataToDisplay == DataToDisplay.battery
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
                                  sideTitles: SideTitles()),
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
                                      // strokeWidth: 1,
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
          Provider(
            create: (context) => FilterCubit(),
            child: BaseUpgradeBlocBuilder<FilterCubit, FilterState>(
              builder: (context, state) {
                if (state is FilterState) {
                  return Expanded(
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
                          // when a user taps on the element, send a request to server for table entries
                          return InkWell(
                            onTap: () {
                              _filterCubit.setFarmIdToFetchTrackings(e.farmId!);
                              widget.queryParameter.value =
                                  _filterCubit.returnQueryParams();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    _filterCubit.state.farmIdToFetchTrackings ==
                                            e.farmId
                                        ? const Color.fromARGB(25, 55, 114, 255)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 8),
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
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
