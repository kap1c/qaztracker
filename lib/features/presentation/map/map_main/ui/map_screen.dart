// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_bloc_builder.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:qaz_tracker/common/widgets/app_loading_widget.dart';

import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'package:qaz_tracker/features/data/map/model/map_item_model.dart';
import 'package:qaz_tracker/features/presentation/map/map_main/cubit/map_cubit.dart';
import 'package:qaz_tracker/features/presentation/map/map_main/cubit/map_state.dart';
import 'package:qaz_tracker/features/presentation/map/map_main/ui/components/cutom_info_widget.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapScreen extends StatefulWidget {
  MapCubit? mapCubit;
  bool isFullScreen;
  ValueListenable<bool>? filterIsOpened;
  ValueNotifier<Map<String, dynamic>>? queryParams;
  MapScreen(
      {super.key,
      this.mapCubit,
      this.queryParams,
      this.filterIsOpened,
      required this.isFullScreen});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _gMapController = Completer();

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  late MapCubit mapCubit;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  late Set<Marker> markers = <Marker>{};
  late bool _mapLoading = true;
  late LatLng _initialPosition = const LatLng(43.455943, 76.846495);
  LatLng? selectedMarkerPosition;
  ClusterManager? clusterManager;

  @override
  void initState() {
    if (widget.mapCubit != null) {
      mapCubit = widget.mapCubit!;
    } else {
      mapCubit = MapCubit();
    }
    clusterManager = _initClusterManager();

    // mapCubit.getAllRegions();
    mapCubit.getAllMapInfo();

    if (widget.queryParams != null && widget.queryParams!.value.isEmpty) {
      widget.queryParams!.addListener(() {
        mapCubit.getAllMapInfo(queryParams: widget.queryParams!.value);
      });
    } else {}

    getGeoLocationPermission();

    super.initState();
  }

  Future<void> getGeoLocationPermission() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    } else if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      _getUserLocation();
    } else if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (mounted) {
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
      });
    }
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<MarkerItem>([], _updateMarkers,
        markerBuilder: (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            cluster.items.forEach((p) => print(p));
            if (!cluster.isMultiple) {
              selectedMarkerPosition = LatLng(
                  cluster.items.first.latLng.latitude,
                  cluster.items.first.latLng.longitude);
              _customInfoWindowController.addInfoWindow!(
                  CustomWindowWidget(
                    mapElement: cluster.items.first.mapElement!,
                  ),
                  LatLng(cluster.items.first.latLng.latitude,
                      cluster.items.first.latLng.longitude));
            }
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
        create: (context) => mapCubit,
        child: CoreUpgradeBlocBuilder<MapCubit, CoreState>(
            buildWhen: (prevState, curState) => curState is MapState,
            builder: (context, state) {
              if (state is MapState) {
                if (state.isLoading ) {
                  return const AppLoaderWidget();
                } else {
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
                    child: Stack(
                      children: [
                        SafeArea(
                          child: GoogleMap(
                            tiltGesturesEnabled: false,
                            mapToolbarEnabled: true,
                            compassEnabled: true,
                            myLocationButtonEnabled: true,
                            myLocationEnabled: true,
                            mapType: MapType.normal,
                            onTap: (position) {
                              _customInfoWindowController.hideInfoWindow!();
                            },
                            onCameraMove: (position) {
                              _customInfoWindowController.onCameraMove!();
                              clusterManager!.onCameraMove(position);
                            },
                            onCameraIdle: () {
                              clusterManager!.updateMap();
                            },
                            initialCameraPosition: CameraPosition(
                                target: _initialPosition, zoom: 10),
                            markers: markers,
                            onMapCreated: (GoogleMapController controller) {
                              if (mounted) {
                                markers = <Marker>{};

                                /// check new map items, if exists we should assign markers
                                if (state.mapInfoData != null &&
                                    state.mapInfoData!.map.isNotEmpty) {
                                  markers.addAll(
                                    state.mapInfoData!.map.map(
                                      (e) => Marker(
                                        markerId: MarkerId('${e.id}'),
                                        position: LatLng(e.lat, e.long),
                                      ),
                                    ),
                                  );
                                  clusterManager!.setItems(
                                    state.mapInfoData!.map
                                        .map((e) => MarkerItem(
                                              latLng: LatLng(e.lat, e.long),
                                              marker: Marker(
                                                markerId: MarkerId('${e.id}'),
                                                position: LatLng(e.lat, e.long),
                                              ),
                                              mapElement: e,
                                            ))
                                        .toList(),
                                  );
                                } else {
                                  /// otherwise update markers limit
                                  markers.clear();
                                }

                                _customInfoWindowController
                                    .googleMapController = controller;

                                clusterManager!.setMapId(controller.mapId);

                                setState(() {
                                  _mapLoading = false;
                                });
                              }
                            },
                          ),
                        ),
                        _mapLoading
                            ? Center(
                                child: Container(
                                  color: Colors.white,
                                  child: const AppLoaderWidget(),
                                ),
                              )
                            : const SizedBox(),
                        Positioned(
                          right: 10,
                          top: 10,
                          child: GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(
                                    0XFFE8E9EE,
                                  ),
                                ),
                              ),
                              height: 32,
                              width: 32,
                              child: const Icon(
                                Icons.fullscreen,
                              ),
                            ),
                            onTap: () {
                              if (widget.isFullScreen) {
                                Navigator.of(context).pop();
                              } else {
                                final mapCubit = context.read<MapCubit>();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapScreen(
                                      mapCubit: mapCubit,
                                      isFullScreen: true,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        CustomInfoWindow(
                          controller: _customInfoWindowController,
                          height: 280,
                          width: 300,
                          offset: 50,
                        ),
                      ],
                    ),
                  );
                }
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
            if (!cluster.isMultiple) {
              selectedMarkerPosition = LatLng(
                  cluster.items.first.latLng.latitude,
                  cluster.items.first.latLng.longitude);
              _customInfoWindowController.addInfoWindow!(
                  CustomWindowWidget(
                    mapElement: cluster.items.first.mapElement!,
                  ),
                  LatLng(cluster.items.first.latLng.latitude,
                      cluster.items.first.latLng.longitude));
            }
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

class MarkerItem implements ClusterItem {
  final LatLng latLng;
  final Marker marker;
  MapElement? mapElement;
  MarkerItem({required this.latLng, required this.marker, this.mapElement});

  @override
  LatLng get location => latLng;

  @override
  String get geohash =>
      Geohash.encode(location, codeLength: ClusterManager.precision);
}
