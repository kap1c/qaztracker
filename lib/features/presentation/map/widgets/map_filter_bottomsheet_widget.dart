// // ignore_for_file: import_of_legacy_library_into_null_safe

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_core/core/abstarct/constant/core_common_contant.dart';
// import 'package:flutter_core/core/presentation/abstract/bloc/core_bloc_builder.dart';
// import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
// import 'package:provider/provider.dart';
// import 'package:qaz_tracker/common/widgets/app_keyboard_hide_widget.dart';
// import 'package:qaz_tracker/common/widgets/app_loading_widget.dart';
// import 'package:qaz_tracker/common/widgets/app_main_button_widget.dart';
// import 'package:qaz_tracker/common/widgets/app_text_field_widget.dart';
// import 'package:qaz_tracker/config/style/app_global_style.dart';
// import 'package:qaz_tracker/features/presentation/map/map_main/cubit/map_cubit.dart';
// import 'package:qaz_tracker/features/presentation/map/map_main/cubit/map_state.dart';
// import 'package:sizer/sizer.dart';

// void showMapFilterBottomSheet(BuildContext context, MapCubit mapCubit) {
//   showModalBottomSheet<void>(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0))),
//       backgroundColor: Colors.white,
//       builder: (BuildContext context) {
//         return SizedBox(
//             height: 70.h,
//             child: ClipRRect(
//                 borderRadius: BorderRadius.circular(16),
//                 child: Provider.value(
//                     value: mapCubit, child: const MapFilterWidget())));
//       });
// }

// class MapFilterWidget extends StatefulWidget {
//   const MapFilterWidget({super.key});

//   @override
//   State<MapFilterWidget> createState() => _MapFilterWidgetState();
// }

// class _MapFilterWidgetState extends State<MapFilterWidget> {
//   late MapCubit mapCubit;
//   late TextEditingController _editingController;
//   @override
//   void initState() {
//     _editingController = TextEditingController();
//     mapCubit = context.read<MapCubit>();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _editingController = TextEditingController(text: mapCubit.filterIdTraker);
//     return AppHideKeyBoardWidget(
//       child: CoreUpgradeBlocBuilder<MapCubit, CoreState>(
//         buildWhen: (prevState, curState) => curState is MapState,
//         builder: (context, state) {
//           if (state is MapState) {
//             if (state.) {
//               return const AppLoaderWidget();
//             }

//             return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                           width: 100,
//                           height: 4,
//                           margin: const EdgeInsets.symmetric(vertical: 10),
//                           decoration: const BoxDecoration(
//                               color: AppColors.secondaryTextFieldBorderColor)),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text('Фильтры',
//                               style: TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold)),
//                           IconButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               padding: const EdgeInsets.all(0),
//                               iconSize: 35,
//                               icon: const Icon(Icons.cancel_rounded,
//                                   color: Colors.grey))
//                         ],
//                       ),
//                       const SizedBox(height: 15),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text('Тип скота',
//                               style: TextStyle(color: AppColors.textGreyColor)),
//                           const SizedBox(height: 8),
//                           SizedBox(
//                             height: 50,
//                             child: ListView.separated(
//                               itemCount: state.getMapAnimalCategories!.length,
//                               scrollDirection: Axis.horizontal,
//                               separatorBuilder:
//                                   (BuildContext context, int index) {
//                                 return const SizedBox(width: 10);
//                               },
//                               itemBuilder: (BuildContext context, int index) {
//                                 return InkWell(
//                                   borderRadius: BorderRadius.circular(8),
//                                   onTap: () {
//                                     HapticFeedback.mediumImpact();
//                                     mapCubit.selectAnimalType(index);
//                                   },
//                                   child: Ink(
//                                     height: 50,
//                                     width: 100,
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 15),
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(8),
//                                         border: Border.all(
//                                             width: 1,
//                                             color: AppColors
//                                                 .secondaryTextFieldBorderColor),
//                                         color: state
//                                                 .getMapAnimalCategories![index]
//                                                 .isSelected
//                                             ? AppColors.primaryBlueColor
//                                             : Colors.white),
//                                     child: Center(
//                                         child: Text(
//                                             state.getMapAnimalCategories![index]
//                                                     .title ??
//                                                 CoreConstant.empty,
//                                             style: TextStyle(
//                                                 color: state
//                                                         .getMapAnimalCategories![
//                                                             index]
//                                                         .isSelected
//                                                     ? Colors.white
//                                                     : Colors.black,
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.w500))),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'ID Трекера',
//                                 style: TextStyle(
//                                   color: AppColors.textGreyColor,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               AppTextFieldWidget(
//                                   // maxLines: 1,
//                                   textEditingController: _editingController,
//                                   keyboardType: TextInputType.text,
//                                   onChanged: (val) {
//                                     mapCubit.setMapFilterIdTracker(val);
//                                   }),
//                             ],
//                           ),
//                           const SizedBox(height: 20),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text('Количество трекеров',
//                                   style: TextStyle(
//                                       color: AppColors.textGreyColor)),
//                               const SizedBox(height: 8),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                       child: AppTextFieldWidget(
//                                           keyboardType: TextInputType.number,
//                                           textEditingController:
//                                               TextEditingController(
//                                                   text: state.trackersLimit!
//                                                       .round()
//                                                       .toString()),
//                                           // maxLines: 1,
//                                           onChanged: (val) {})),
//                                 ],
//                               )
//                             ],
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 20),
//                             child: Slider(
//                               min: 10,
//                               max: 20000,
//                               activeColor: AppColors.primaryDeepBlueColor,
//                               onChanged: (double values) {
//                                 mapCubit.setTrackersLimit(values);
//                               },
//                               value: state.trackersLimit!,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Row(
//                             children: [
//                               Expanded(
//                                   child: AppMainButtonWidget(
//                                       onPressed: () {
//                                         HapticFeedback.mediumImpact();
//                                         mapCubit.clearFilter();
//                                         Navigator.of(context,
//                                                 rootNavigator: true)
//                                             .pop();
//                                       },
//                                       text: 'Отменить',
//                                       textColor: Colors.black,
//                                       bgColor: AppColors.profileBgGreyColor,
//                                       borderColor:
//                                           AppColors.profileBgGreyColor)),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                   child: AppMainButtonWidget(
//                                       onPressed: () {
//                                         HapticFeedback.mediumImpact();

//                                         /// let's filter
//                                         mapCubit.doFilterMap();
//                                         Navigator.of(context,
//                                                 rootNavigator: true)
//                                             .pop();
//                                       },
//                                       text: 'Применить')),
//                             ],
//                           ),
//                           const SizedBox(height: 40),
//                         ],
//                       )
//                     ],
//                   ),
//                 ));
//           } else {
//             return const SizedBox();
//           }
//         },
//       ),
//     );
//   }

//   void showRegionsList() {
//     showModalBottomSheet<void>(
//         context: context,
//         isScrollControlled: true,
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(18.0),
//                 topRight: Radius.circular(18.0))),
//         backgroundColor: Colors.white,
//         builder: (BuildContext context) {
//           return SizedBox(
//               height: 90.h,
//               child: ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: Provider.value(
//                       value: mapCubit, child: const MapSelectRegionsWidget())));
//         });
//   }
// }

// class MapSelectRegionsWidget extends StatelessWidget {
//   const MapSelectRegionsWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final regionList = context.read<MapCubit>();
//     return Column(
//       children: [
//         Container(
//             width: 100,
//             height: 4,
//             margin: const EdgeInsets.symmetric(vertical: 10),
//             decoration: const BoxDecoration(
//                 color: AppColors.secondaryTextFieldBorderColor)),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('Область',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               IconButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   padding: const EdgeInsets.all(0),
//                   iconSize: 35,
//                   icon: const Icon(Icons.cancel_rounded, color: Colors.grey))
//             ],
//           ),
//         ),
//         CoreUpgradeBlocBuilder<MapCubit, CoreState>(
//             buildWhen: (prevState, curState) => curState is MapState,
//             builder: (context, state) {
//               if (state is MapState) {
//                 if (state.isLoading) {
//                   return const AppLoaderWidget();
//                 }
//                 return Expanded(
//                   child: Scrollbar(
//                     child: ListView.separated(
//                       shrinkWrap: true,
//                       padding: const EdgeInsets.all(16),
//                       itemCount: regionList.getRegionDataList?.total ?? 0,
//                       separatorBuilder: (BuildContext context, int index) {
//                         return const SizedBox(height: 8);
//                       },
//                       itemBuilder: (BuildContext context, int index) {
//                         return InkWell(
//                           onTap: () {
//                             context.read<MapCubit>().selectRegion(
//                                 regionList.getRegionDataList!.items[index].id);
//                           },
//                           borderRadius:
//                               const BorderRadius.all(Radius.circular(8)),
//                           child: Container(
//                             padding: const EdgeInsets.all(13),
//                             decoration: BoxDecoration(
//                                 border: Border.all(
//                                     color: state.regionsDataList!.items[index]
//                                             .isSelected
//                                         ? AppColors.primaryBlueColor
//                                         : AppColors
//                                             .secondaryTextFieldBorderColor),
//                                 borderRadius:
//                                     const BorderRadius.all(Radius.circular(8))),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                     regionList
//                                         .getRegionDataList!.items[index].name,
//                                     style: const TextStyle(fontSize: 16)),
//                                 if (state
//                                     .regionsDataList!.items[index].isSelected)
//                                   const Icon(Icons.check_circle_rounded,
//                                       size: 27,
//                                       color: AppColors.primaryBlueColor)
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 );
//               } else {
//                 return const SizedBox();
//               }
//             }),
//         SafeArea(
//             child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(children: [
//                   Expanded(
//                     child: AppMainButtonWidget(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         text: 'Применить'),
//                   )
//                 ])))
//       ],
//     );
//   }
// }
