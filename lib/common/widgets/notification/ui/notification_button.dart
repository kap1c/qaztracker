import 'package:flutter/material.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_bloc_builder.dart';
import 'package:provider/provider.dart';
import 'package:qaz_tracker/common/widgets/filter/ui/filter_widget.dart';
import 'package:qaz_tracker/common/widgets/notification/cubit/notification_cubit.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget();

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  bool _isExpanded = false;
  late NotificationCubit _notificationCubit;

  @override
  void initState() {
    _notificationCubit = NotificationCubit();
    _notificationCubit.fetchNotifications();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (_) => _notificationCubit,
        child: CoreUpgradeBlocBuilder<NotificationCubit, NotificationState>(
            buildWhen: (prevState, curState) => curState is NotificationState,
            builder: ((context, state) {
              if (state is NotificationState) {
                if (state is NotificationState) {
                  return PopupMenuButton<String>(
                      onCanceled: _notificationCubit.seeNotifications,
                      offset: const Offset(0, 50),
                      surfaceTintColor: null,
                      padding: EdgeInsets.zero,
                      onOpened: () {},
                      // padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      onSelected: (value) {},
                      itemBuilder: (context) {
                        return <PopupMenuEntry<String>>[
                          CustomPopupMenuItem(
                            value: 'option1',
                            context: context,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Уведомления",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0XFF1C202C),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: AppColors
                                                .secondaryTextFieldBorderColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.close,
                                              size: 16,
                                              color: AppColors
                                                  .secondaryBlackColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color:
                                      AppColors.secondaryTextFieldBorderColor,
                                ),
                                Column(
                                  children: state.notificationsList!.map((e) {
                                    return ListTile(
                                      title: Text(
                                        e.message!,
                                        style: TextStyle(
                                          color: _getNotificationColor(
                                              e.notificationStatus!),
                                        ),
                                      ),
                                      subtitle:
                                          Text(e.notificationDate.toString()),
                                      trailing: e.isSeen == false
                                          ? Container(
                                              width: 5,
                                              height: 5,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    AppColors.primaryBlueColor,
                                              ),
                                            )
                                          : const SizedBox(),
                                    );
                                  }).toList(),
                                )
                              ],
                            ),
                          ),
                        ];
                      },
                      child: Stack(children: [
                        const Center(
                          child: Icon(
                            Icons.notifications_none,
                            color: Color(0xFF32384A),
                          ),
                        ),
                        if (state.numberOfUnseenNotifications != null &&
                            state.numberOfUnseenNotifications! > 0)
                          Positioned(
                            top: 0,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                state.notificationsList!.length.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ]));
                  ;
                } else {
                  return Container();
                }
              } else {
                return Container();
              }
              ;
            })));
  }

  IconData _getPriorityIcon(NotificationStatus? status) {
    switch (status) {
      case NotificationStatus.lowPriority:
        return Icons.arrow_downward;
      case NotificationStatus.mediumPriority:
        return Icons.arrow_forward;
      case NotificationStatus.highPriority:
        return Icons.arrow_upward;
      default:
        return Icons.arrow_downward;
    }
  }

  Color _getNotificationColor(NotificationStatus status) {
    switch (status) {
      case NotificationStatus.lowPriority:
        return const Color(0XFF55C153);
      case NotificationStatus.mediumPriority:
        return Colors.orange.shade100;
      case NotificationStatus.highPriority:
        return const Color(0XFFFF5656);
      default:
        return const Color(0XFF55C153);
    }
  }
}
