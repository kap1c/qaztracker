// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_bloc_builder.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qaz_tracker/common/widgets/app_loading_widget.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'package:qaz_tracker/features/presentation/home/mixin/home_data_mixin.dart';
import 'package:qaz_tracker/features/presentation/map/map_history/cubit/map_history_cubit.dart';
import 'package:qaz_tracker/features/presentation/map/map_history/cubit/map_history_state.dart';
import 'package:qaz_tracker/features/presentation/map/map_main/ui/map_screen.dart';
import 'package:qaz_tracker/features/presentation/map/widgets/map_item_info_widget.dart';
import 'package:sizer/sizer.dart';

class MapAnimalHistoryScreen extends StatefulWidget {
  const MapAnimalHistoryScreen({super.key, this.animalId});
  final int? animalId;

  @override
  State<MapAnimalHistoryScreen> createState() => _MapAnimalHistoryState();
}

class _MapAnimalHistoryState extends State<MapAnimalHistoryScreen>
    with HomeDataMixin {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late MapHistoryCubit _mapHistoryCubit;

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  late Set<Marker> markers = <Marker>{};

  late bool _mapLoading = true;
  late final LatLng _initialPosition = const LatLng(43.455943, 76.846495);
  String? sortFilter = 'За неделю';
  ClusterManager? clusterManager;

  @override
  void initState() {
    _mapHistoryCubit = MapHistoryCubit();
    _mapHistoryCubit.getHistoryMovementOfMapAnimal(widget.animalId!);
    clusterManager = _initClusterManager();
    super.initState();
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<MarkerItem>([], _updateMarkers,
        markerBuilder: (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            cluster.items.forEach((p) => print(p));
            // if (!cluster.isMultiple) {
            //   selectedMarkerPosition = LatLng(
            //       cluster.items.first.latLng.latitude,
            //       cluster.items.first.latLng.longitude);
            //   _customInfoWindowController.addInfoWindow!(
            //       CustomWindowWidget(
            //         mapElement: cluster.items.first.mapElement,
            //       ),
            //       LatLng(cluster.items.first.latLng.latitude,
            //           cluster.items.first.latLng.longitude));
            // }
          },
          icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
              text: cluster.isMultiple ? cluster.count.toString() : null),
        );
      });
  }

  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      this.markers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (context) => _mapHistoryCubit,
        child: CoreUpgradeBlocBuilder<MapHistoryCubit, CoreState>(
            buildWhen: (prevState, curState) =>
                curState is MapAnimalHistoryState,
            builder: (context, state) {
              if (state is MapAnimalHistoryState) {
                if (state.isLoading) {
                  return const Material(child: AppLoaderWidget());
                }

                return Scaffold(
                  appBar: AppBar(
                      leading: IconButton(
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            Navigator.pop(context);
                          },
                          icon: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      width: 1,
                                      color: AppColors
                                          .secondaryTextFieldBorderColor)),
                              child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 20,
                                  color: Colors.black))),
                      title: const Text('История перемещений',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      elevation: 0,
                      backgroundColor: Colors.white),
                  body: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: GoogleMap(
                            mapToolbarEnabled: true,
                            compassEnabled: true,
                            myLocationButtonEnabled: true,
                            myLocationEnabled: true,
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                                target: _initialPosition, zoom: 2),
                            markers: markers,
                            onCameraMove: (position) {
                              clusterManager!.onCameraMove(position);
                            },
                            onCameraIdle: () {
                              clusterManager!.updateMap();
                            },
                            onMapCreated: (GoogleMapController controller) {
                              if (mounted) {
                                setState(() => _mapLoading = false);

                                markers = <Marker>{};

                                /// check new map items, if exists we should assign markers
                                if (state.mapAnimalHistoryLocationsModel !=
                                        null &&
                                    state.mapAnimalHistoryLocationsModel!.data
                                        .isNotEmpty) {
                                  markers.addAll(state
                                      .mapAnimalHistoryLocationsModel!.data
                                      .map((e) => Marker(
                                          onTap: () {},
                                          markerId: MarkerId('${e.id}'),
                                          position: LatLng(e.lat, e.long))));
                                  clusterManager!.setItems(
                                      state.mapAnimalHistoryLocationsModel!.data
                                          .map((e) => MarkerItem(
                                                latLng: LatLng(e.lat, e.long),
                                                marker: Marker(
                                                  markerId: MarkerId('${e.id}'),
                                                  position:
                                                      LatLng(e.lat, e.long),
                                                ),
                                                // mapElement: e,
                                              ))
                                          .toList());
                                } else {
                                  /// otherwise update markers limit
                                  markers.clear();
                                }
                              }
                              if (!_controller.isCompleted) {
                                _controller.complete(controller);
                              }
                              clusterManager!.setMapId(controller.mapId);
                            }),
                      ),
                      _mapLoading
                          ? Center(
                              child: Container(
                                  color: Colors.white,
                                  child: const AppLoaderWidget()))
                          : const SizedBox(),
                      // Container(
                      //     height: 30.h,
                      //     padding: const EdgeInsets.all(16),
                      //     width: double.infinity,
                      //     decoration: const BoxDecoration(color: Colors.white),
                      //     child: Column(
                      //       children: [
                      //         Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             const Text('Статистика',
                      //                 style: TextStyle(
                      //                     fontWeight: FontWeight.bold,
                      //                     fontSize: 17)),
                      //             DropdownButton<String>(
                      //               iconDisabledColor:
                      //                   AppColors.primaryBlueColor,
                      //               iconEnabledColor:
                      //                   AppColors.primaryBlueColor,
                      //               underline: const SizedBox(),
                      //               // value: sortFilter,
                      //               hint: Text(sortFilter!,
                      //                   style: const TextStyle(
                      //                       color: AppColors.primaryBlueColor,
                      //                       fontWeight: FontWeight.w500)),
                      //               items: getHomeFilterRange.entries
                      //                   .map((MapEntry<String, String> e) {
                      //                 return DropdownMenuItem<String>(
                      //                   value: e.key,
                      //                   child: SizedBox(
                      //                       width: 100, child: Text(e.value)),
                      //                 );
                      //               }).toList(),
                      //               onChanged: (String? val) {
                      //                 HapticFeedback.mediumImpact();
                      //                 if (val == 'week') {
                      //                   sortFilter = 'За неделю';
                      //                 } else if (val == 'month') {
                      //                   sortFilter = 'За месяц';
                      //                 } else if (val == 'all') {
                      //                   sortFilter = 'За все время';
                      //                 }
                      //                 setState(() {});
                      //                 _mapHistoryCubit
                      //                     .selectMapStatisticFilterRange(
                      //                         val!, widget.animalId!);
                      //               },
                      //             )
                      //           ],
                      //         ),
                      //         Padding(
                      //           padding:
                      //               const EdgeInsets.symmetric(vertical: 10),
                      //           child: Row(
                      //               mainAxisAlignment:
                      //                   MainAxisAlignment.spaceBetween,
                      //               children: [
                      //                 Expanded(
                      //                     child: MapItemInfoWidget(
                      //                   title: 'Пройденное раст-е',
                      //                   subTitle:
                      //                       ('${state.mapAnimalStatisticInfoModel?.gpsRange.toString() ?? '0'} км'),
                      //                 )),
                      //                 const SizedBox(width: 10),
                      //                 Expanded(
                      //                     child: MapItemInfoWidget(
                      //                   title: 'Пройденные шаги',
                      //                   subTitle:
                      //                       ('${state.mapAnimalStatisticInfoModel?.steps.toString() ?? '0'} шагов'),
                      //                 ))
                      //               ]),
                      //         ),
                      //         Padding(
                      //           padding:
                      //               const EdgeInsets.symmetric(vertical: 5),
                      //           child: Row(
                      //               mainAxisAlignment:
                      //                   MainAxisAlignment.spaceBetween,
                      //               children: [
                      //                 Expanded(
                      //                     flex: 1,
                      //                     child: MapItemInfoWidget(
                      //                       title: 'Средняя скорость',
                      //                       subTitle:
                      //                           ('${state.mapAnimalStatisticInfoModel?.gpsSpeed.toString() ?? '0'} км/ч'),
                      //                     )),
                      //                 const Expanded(
                      //                     child: SizedBox(width: 10)),
                      //               ]),
                      //         ),
                      //       ],
                      //     ))
                    ],
                  ),
                );
              } else {
                return const SizedBox();
              }
            }));
  }

  Future<Marker> Function(Cluster<MarkerItem>) get _markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            cluster.items.forEach((p) => print(p));
          },
          icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
              text: cluster.isMultiple ? cluster.count.toString() : null),
        );
      };

  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
    final bool isDefaultMarker = text == null;

    if (kIsWeb) size = (size / 2).floor();

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    if (isDefaultMarker) {
      // Use default marker image
      return BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(devicePixelRatio: 2.5),
          'assets/images/single_marker.png');
    } else {
      final Paint paint1 = Paint()..color = Colors.white;
      final Paint paint2 = Paint()..color = AppColors.primaryBlueColor;

      canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
      canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
      canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
          fontSize: size / 3,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );

      final img = await pictureRecorder.endRecording().toImage(size, size);
      final data =
          await img.toByteData(format: ImageByteFormat.png) as ByteData;

      return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
    }
  }
}
