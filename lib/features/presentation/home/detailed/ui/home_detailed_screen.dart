// // ignore_for_file: import_of_legacy_library_into_null_safe

// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_charts/flutter_charts.dart';
// import 'package:flutter_core/core/abstarct/constant/core_common_contant.dart';
// import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
// import 'package:qaz_tracker/common/widgets/app_base_state_widget.dart';
// import 'package:qaz_tracker/common/widgets/app_loading_widget.dart';
// import 'package:qaz_tracker/config/style/app_global_style.dart';
// import 'package:qaz_tracker/features/data/home/model/home_farm_info_model.dart';
// import 'package:qaz_tracker/features/presentation/home/detailed/cubit/home_detailed_cubit.dart';
// import 'package:qaz_tracker/features/presentation/home/detailed/cubit/home_detailed_state.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:qaz_tracker/features/presentation/home/main/cubit/home_main_cubit.dart';
// import 'package:qaz_tracker/features/presentation/home/main/cubit/home_main_state.dart';
// import 'package:qaz_tracker/features/presentation/home/mixin/home_data_mixin.dart';
// import 'package:sizer/sizer.dart';

// class HomeDetailedScreen extends StatefulWidget {
//   const HomeDetailedScreen({super.key, this.animalType, this.isAnimal = true});
//   final int? animalType;
//   final bool? isAnimal;

//   @override
//   State<HomeDetailedScreen> createState() => _HomeDetailedScreenState();
// }

// class _HomeDetailedScreenState extends State<HomeDetailedScreen>
//     with HomeDataMixin {
//   late HomeDetailedCubit _homeDetailedCubit;
//   late HomeCubit _homeCubit;
//   final ScrollController _scrollControllerTable = ScrollController();
//   final ScrollController _scrollControllerDiagram = ScrollController();

//   bool isAnimal = true;
//   String? sortFilter = 'За неделю';
//   String selectedDataType = 'Шаги';

//   @override
//   void initState() {
//     isAnimal = widget.isAnimal ?? false;

//     _homeCubit = context.read<HomeCubit>();
//     _homeDetailedCubit = HomeDetailedCubit();
//     _homeDetailedCubit.getDetailedAnimalInfo(animalTypeId: widget.animalType);

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//             leading: IconButton(
//                 onPressed: () => Navigator.pop(context),
//                 icon: Container(
//                     padding: const EdgeInsets.all(7),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(50),
//                         border: Border.all(
//                             width: 1,
//                             color: AppColors.secondaryTextFieldBorderColor)),
//                     child: const Icon(Icons.arrow_back_ios_new_rounded,
//                         size: 20, color: Colors.black))),
//             title: Text(
//                 isAnimal ? 'База данных животных' : 'База данных трекеров',
//                 style: const TextStyle(
//                     fontSize: 15,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold)),
//             elevation: 0,
//             backgroundColor: Colors.white),
//         body: SafeArea(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 35.h,
//                 child: BlocProvider(
//                     create: (context) => _homeDetailedCubit,
//                     child: BaseUpgradeBlocBuilder<HomeDetailedCubit, CoreState>(
//                         buildWhen: (prevState, curState) =>
//                             curState is HomeDetailState,
//                         builder: (context, state) {
//                           if (state is HomeDetailState) {
//                             if (state.isLoading) {
//                               return const AppLoaderWidget();
//                             }
//                             if (state.detailedAnimalInfoData!.schedule ==
//                                 null) {
//                               return const Center(child: Text('Нет данных'));
//                             }
//                             return Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 10),
//                               child: SizedBox(
//                                 height: 40.h,
//                                 child: Scrollbar(
//                                   controller: _scrollControllerTable,
//                                   child: SingleChildScrollView(
//                                     controller: _scrollControllerTable,
//                                     child: DataTable(
//                                       columnSpacing: 30,
//                                       dividerThickness: 0,
//                                       columns: [
//                                         DataColumn(
//                                             label: Expanded(
//                                           child: Text(
//                                               isAnimal
//                                                   ? 'ID Коровы'
//                                                   : 'ID трекера',
//                                               style: const TextStyle(
//                                                   fontSize: 12,
//                                                   color:
//                                                       AppColors.textGreyColor)),
//                                         )),
//                                         DataColumn(
//                                             label: Expanded(
//                                           child: Text(
//                                               isAnimal
//                                                   ? 'Ср. Скорость'
//                                                   : 'ID животного',
//                                               softWrap: true,
//                                               style: const TextStyle(
//                                                   fontSize: 12,
//                                                   color:
//                                                       AppColors.textGreyColor)),
//                                         )),
//                                         DataColumn(
//                                             label: Expanded(
//                                           child: Text(
//                                               isAnimal
//                                                   ? 'Кол-во Шагов'
//                                                   : 'Уровень Бат.',
//                                               softWrap: true,
//                                               style: const TextStyle(
//                                                   fontSize: 12,
//                                                   color:
//                                                       AppColors.textGreyColor)),
//                                         )),
//                                         DataColumn(
//                                             label: Expanded(
//                                           child: Text(
//                                               isAnimal
//                                                   ? 'Пр.Расстояние'
//                                                   : 'Сост. сети',
//                                               softWrap: true,
//                                               style: const TextStyle(
//                                                   fontSize: 12,
//                                                   color:
//                                                       AppColors.textGreyColor)),
//                                         )),
//                                       ],
//                                       rows: state
//                                           .detailedAnimalInfoData!.schedule
//                                           .map(
//                                             (e) => DataRow(cells: [
//                                               DataCell(Text(e.id.toString(),
//                                                   style: const TextStyle(
//                                                       fontSize: 14))),
//                                               DataCell(Text(
//                                                   isAnimal
//                                                       ? '${e.gpsSpeed} км/ч'
//                                                       : e.trackerId.toString(),
//                                                   style: const TextStyle(
//                                                       fontSize: 14))),
//                                               DataCell(Text(
//                                                   isAnimal
//                                                       ? e.steps.toString()
//                                                       : e.battery.toString(),
//                                                   style: const TextStyle(
//                                                       fontSize: 14))),
//                                               DataCell(Text(
//                                                   isAnimal
//                                                       ? '${e.gpsRange} км'
//                                                       : getNetworkString(
//                                                           e.network),
//                                                   style: const TextStyle(
//                                                       fontSize: 14))),
//                                             ]),
//                                           )
//                                           .toList(),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           } else {
//                             return const SizedBox();
//                           }
//                         })),
//               ),
//               const Divider(
//                   color: AppColors.profileBgGreyColor,
//                   height: 10,
//                   thickness: 10),
//               SingleChildScrollView(
//                 controller: _scrollControllerDiagram,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Column(
//                     children: [
//                       Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text('График',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 16)),
//                             DropdownButton<String>(
//                               iconDisabledColor: AppColors.primaryBlueColor,
//                               iconEnabledColor: AppColors.primaryBlueColor,
//                               underline: const SizedBox(),
//                               // value: sortFilter,
//                               hint: Text(sortFilter!,
//                                   style: const TextStyle(
//                                       color: AppColors.primaryBlueColor,
//                                       fontWeight: FontWeight.w500)),
//                               items: getHomeFilterRange.entries
//                                   .map((MapEntry<String, String> e) {
//                                 return DropdownMenuItem<String>(
//                                   value: e.key,
//                                   child: SizedBox(
//                                       width: 100, child: Text(e.value)),
//                                 );
//                               }).toList(),
//                               onChanged: (String? val) {
//                                 HapticFeedback.mediumImpact();
//                                 log(val!);
//                                 if (val == 'week') {
//                                   sortFilter = 'За неделю';
//                                 } else if (val == 'month') {
//                                   sortFilter = 'За месяц';
//                                 } else if (val == 'all') {
//                                   sortFilter = 'За все время';
//                                 }
//                                 setState(() {});
//                                 _homeCubit.selectHomeFilterRange(val);
//                               },
//                             )
//                           ]),
//                       BaseUpgradeBlocBuilder<HomeCubit, CoreState>(
//                           buildWhen: (prevState, curState) =>
//                               curState is HomeState,
//                           builder: (context, state) {
//                             if (state is HomeState) {
//                               if (state.isLoading) {
//                                 return const AppLoaderWidget();
//                               }
//                               return SizedBox(
//                                   height: 40.h,
//                                   width: double.infinity,
//                                   child: chartToRun(
//                                       state.homeFarmInfoData!.diagram.keys
//                                           .toList(),
//                                       state.homeFarmInfoData!.diagram.values
//                                           .toList()));
//                             } else {
//                               return const SizedBox();
//                             }
//                           })
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }

//   String getNetworkString(int? networkState) {
//     String res = CoreConstant.empty;
//     if (networkState != null) {
//       if (networkState >= 7) {
//         res = 'Высокий';
//       } else if (networkState <= 5 && networkState > 3) {
//         res = 'Средний';
//       } else {
//         res = 'Низкий';
//       }
//     }
//     return res;
//   }

//   Widget chartToRun(List<String> xUserLabels, List<FarmDiagram> values) {
//     late List<double> listOfValues = [];
//     late List<String> listOfKeys = [];
//     late bool? isEmpty = false;

//     for (int i = 0; i < xUserLabels.length; i++) {
//       final res = xUserLabels[i].substring(xUserLabels[i].length - 2);
//       listOfKeys.add(res);
//     }

//     for (int i = 0; i < values.length; i++) {
//       double? res = double.tryParse(values[i].steps);
//       listOfValues.add(res!);
//     }

//     if (listOfValues.isEmpty && listOfKeys.isEmpty) {
//       isEmpty = true;
//     }

//     LabelLayoutStrategy? xContainerLabelLayoutStrategy;
//     ChartData chartData;
//     ChartOptions chartOptions = const ChartOptions();
//     // Example shows how to create ChartOptions instance
//     //   which will request to start Y axis at data minimum.
//     // Even though startYAxisAtDataMinRequested is set to true, this will not be granted on bar chart,
//     //   as it does not make sense there.
//     chartOptions = const ChartOptions(
//       dataContainerOptions: DataContainerOptions(
//           startYAxisAtDataMinRequested: true,
//           gridLinesColor: AppColors.profileBgGreyColor),
//     );
//     chartData = ChartData(
//       dataRows: isEmpty
//           ? [
//               [0]
//             ]
//           : [listOfValues],
//       xUserLabels: isEmpty ? ['Нет данных'] : listOfKeys,
//       dataRowsColors: const [AppColors.primaryBlueColor],
//       dataRowsLegends: [selectedDataType],
//       chartOptions: chartOptions,
//     );
//     final verticalBarChartContainer = VerticalBarChartTopContainer(
//         chartData: chartData,
//         xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy);

//     final verticalBarChart = VerticalBarChart(
//         painter: VerticalBarChartPainter(
//             verticalBarChartContainer: verticalBarChartContainer),
//         child: isEmpty
//             ? const Center(child: Text('Нет данных'))
//             : const SizedBox());
//     return verticalBarChart;
//   }
// }
