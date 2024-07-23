// ignore_for_file: import_of_legacy_library_into_null_safe, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_core/core/abstarct/constant/core_common_contant.dart';
import 'package:qaz_tracker/common/widgets/app_main_button_widget.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'package:qaz_tracker/features/data/map/model/map_item_model.dart';
import 'package:qaz_tracker/features/presentation/map/map_main/cubit/map_cubit.dart';
import 'package:qaz_tracker/features/presentation/map/map_history/ui/map_animal_history_screen.dart';
import 'package:qaz_tracker/features/presentation/map/widgets/map_item_info_widget.dart';
import 'package:qaz_tracker/features/presentation/profile/cubit/profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//// show specific animal item info from map
void showMapItemDetailInfoBottomSheet(
    BuildContext context, MapElement itemMap) {
  final profileCubit = context.read<ProfileCubit>();
  final mapCubit = context.read<MapCubit>();

  showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BlocProvider.value(
                value: mapCubit,
                child: BlocProvider.value(
                    value: profileCubit,
                    child: MapAnimalItemDetailWidget(itemMap: itemMap))));
      });
}

class MapAnimalItemDetailWidget extends StatelessWidget {
  const MapAnimalItemDetailWidget({super.key, this.itemMap});
  final MapElement? itemMap;

  @override
  Widget build(BuildContext context) {
    /// call profile cubit with local data from cubit to use it
    final profileCubit = context.read<ProfileCubit>();
    return Column(
      children: [
        Container(
          width: 100,
          height: 4,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(
            color: AppColors.secondaryTextFieldBorderColor,
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      profileCubit.appCurrentUserData?.name ??
                          CoreConstant.empty,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: const EdgeInsets.all(0),
                      iconSize: 35,
                      icon:
                          const Icon(Icons.cancel_rounded, color: Colors.grey))
                ])),
        SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: MapItemInfoWidget(
                          title: 'ID коровы',
                          subTitle: itemMap?.id.toString(),
                        )),
                        const SizedBox(width: 10),
                        Expanded(
                            child: MapItemInfoWidget(
                          title: 'Порода',
                          subTitle: itemMap?.breed != null
                              ? itemMap?.breed!.name.toString()
                              : "",
                        ))
                      ]),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: MapItemInfoWidget(
                            title: 'Вес',
                            subTitle: itemMap?.weight.toString(),
                          )),
                          const SizedBox(width: 10),
                          Expanded(
                              child: MapItemInfoWidget(
                            title: 'Возраст',
                            subTitle: itemMap?.age.toString(),
                          ))
                        ]),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: MapItemInfoWidget(
                          title: 'Батарея',
                          subTitle: '${itemMap?.battery} %',
                          colorTxt: Colors.green,
                        )),
                        const SizedBox(width: 10),
                        Expanded(
                            child: MapItemInfoWidget(
                          title: 'Сеть',
                          subTitle: itemMap?.network.toString(),
                        ))
                      ]),
                  const SizedBox(height: 25),
                  Row(children: [
                    Expanded(
                      child: AppMainButtonWidget(
                        onPressed: () {
                          final mapCubit = context.read<MapCubit>();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                      value: mapCubit,
                                      child: MapAnimalHistoryScreen(
                                          animalId: itemMap!.id))));
                        },
                        text: 'История перемещений',
                      ),
                    )
                  ]),
                ])))
      ],
    );
  }
}
