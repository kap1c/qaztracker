import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class InformationCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final int amount;
  double changeValue;
  Color bgColor;
  InformationCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.amount,
    required this.bgColor,
    this.changeValue = 1.2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.18,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(
            0XFFE8E9EE,
          ),
        ),
      ),
      padding:
          const EdgeInsets.only(left: 24, right: 24, top: 42.17, bottom: 44),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0XFF667085),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  amount.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 32,
                    color: Colors.black,
                  ),
                ),
              ),
              Row(
                children: [
                  changeValue > 0
                      ? const Icon(
                          Icons.trending_up,
                          color: Color(0XFF55C153),
                        )
                      : const Icon(
                          Icons.trending_down,
                          color: Color(0XFFFF5656),
                        ),
                  Text(
                    " $changeValue% ",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: changeValue > 0
                          ? const Color(0XFF55C153)
                          : const Color(0XFFFF5656),
                    ),
                  ),
                  const Text(
                    "За месяц",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0XFF667085),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Center(
              child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              iconPath,
              width: 32,
              height: 32,
            ),
          ))
        ],
      ),
    );
  }
}
