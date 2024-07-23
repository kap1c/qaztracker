import 'package:flutter/material.dart';
import 'package:qaz_tracker/common/widgets/table/ui/table.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  ValueNotifier<Map<String, dynamic>>? queryParams = ValueNotifier({});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      padding: const EdgeInsets.all(
        24,
      ),
      margin: const EdgeInsets.all(
        24,
      ),
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: Text(
              "События",
              style: TextStyle(
                color: AppColors.secondaryBlackColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          CustomTable(
            category: "log",
            queryParams: queryParams,
          ),
        ],
      ),
    );
  }
}
