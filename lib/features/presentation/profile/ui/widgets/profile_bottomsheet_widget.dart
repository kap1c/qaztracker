import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'package:qaz_tracker/features/domain/profile/entity/profile_info_entity.dart';

void showProfilePaymentBottomSheet(
    BuildContext context, AppCurrentUserEntity? appCurrentUserEntity) {
  showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        DateTime expDate = DateFormat("yyyy-MM-dd")
            .parse(appCurrentUserEntity!.subscription!.expiration.toString());

        final String expDateString =
            '${expDate.year}-${expDate.month}-${expDate.day}';
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  width: 100,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(
                      color: AppColors.secondaryTextFieldBorderColor)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Оплата',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: const EdgeInsets.all(0),
                      iconSize: 35,
                      icon:
                          const Icon(Icons.cancel_rounded, color: Colors.grey))
                ],
              ),
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey[200]!),
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Статус', style: TextStyle(fontSize: 15)),
                        Text(
                            appCurrentUserEntity.subscription!.status
                                ? 'Активен'
                                : 'Не активен',
                            style: TextStyle(
                                color: appCurrentUserEntity.subscription!.status
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Действует до',
                            style: TextStyle(fontSize: 15)),
                        Text(
                          expDateString,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 45),
            ],
          ),
        );
      });
}
