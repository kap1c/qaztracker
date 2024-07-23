// ignore_for_file: import_of_legacy_library_into_null_safe

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_core/core/presentation/abstract/bloc/core_bloc_builder.dart';
// import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import 'package:qaz_tracker/common/widgets/app_loading_widget.dart';
// import 'package:qaz_tracker/config/style/app_global_style.dart';
// import 'package:qaz_tracker/features/presentation/notifications/cubit/notification_cubit.dart';
// import 'package:qaz_tracker/features/presentation/notifications/cubit/notification_state.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:qaz_tracker/features/presentation/notifications/ui/widgets/notification_item_widget.dart';

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   final RefreshController _refreshController =
//       RefreshController(initialRefresh: false);

//   late NotificationCubit _notificationCubit;

//   @override
//   void initState() {
//     _notificationCubit = context.read<NotificationCubit>();

//     /// send request to get notifications list
//     _notificationCubit.getNotifications();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//             leading: IconButton(
//                 onPressed: () {
//                   HapticFeedback.mediumImpact();
//                   Navigator.pop(context);
//                 },
//                 icon: Container(
//                     padding: const EdgeInsets.all(7),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(50),
//                         border: Border.all(
//                             width: 1,
//                             color: AppColors.secondaryTextFieldBorderColor)),
//                     child: const Icon(Icons.arrow_back_ios_new_rounded,
//                         size: 20, color: Colors.black))),
//             title: const Text('Уведомления',
//                 style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold)),
//             elevation: 0,
//             backgroundColor: Colors.white),
//         body: CoreUpgradeBlocBuilder<NotificationCubit, CoreState>(
//             buildWhen: (prevState, curState) => curState is NotificationsState,
//             builder: (context, state) {
//               if (state is NotificationsState) {
//                 if (state.isLoading) {
//                   return const AppLoaderWidget();
//                 }
//                 return SmartRefresher(
//                   enablePullDown: true,
//                   enablePullUp: true,
//                   header: const WaterDropHeader(),
//                   footer: CustomFooter(
//                     builder: (BuildContext? context, LoadStatus? mode) {
//                       Widget body;
//                       if (mode == LoadStatus.idle) {
//                         body = const Text("Потяните вверх");
//                       } else if (mode == LoadStatus.loading) {
//                         body = const CupertinoActivityIndicator();
//                       } else if (mode == LoadStatus.failed) {
//                         body = const Text("Ошибка! Попробуйте еще раз =(");
//                       } else if (mode == LoadStatus.canLoading) {
//                         body = const Text("Потяните вверх");
//                       } else {
//                         body = const Text("Данных нету");
//                       }
//                       return SizedBox(height: 60, child: Center(child: body));
//                     },
//                   ),
//                   controller: _refreshController,
//                   // onLoading: _onLoading,
//                   child: ListView.builder(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 15, vertical: 10),
//                       itemBuilder: (c, i) => NotificationItemWidget(
//                           notificationItemData: state.notifications[i]),
//                       itemCount: state.notifications.length),
//                 );
//               } else {
//                 return Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Center(
//                           child: SvgPicture.asset(
//                               AppSvgImages.emptyNotificationIcon)),
//                       const Text('Нет уведомлений',
//                           style: TextStyle(fontSize: 15, color: Colors.black)),
//                     ]);
//               }
//             }));
//   }
// }
