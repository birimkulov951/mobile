import 'package:flutter/material.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

class StepContainerItem extends StatelessWidget {
  final String title;
  final Color? cicrleColor;

  const StepContainerItem({
    Key? key,
    required this.title,
    this.cicrleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        right: 28,
        left: 12,
        top: 18,
        bottom: 18,
      ),
      decoration: BoxDecoration(
        color: ColorNode.Background,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cicrleColor ?? ColorNode.Dark1,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
