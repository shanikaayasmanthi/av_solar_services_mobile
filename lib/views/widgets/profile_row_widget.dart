import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class ProfileRowWidget extends StatefulWidget {
  const ProfileRowWidget({
    super.key,
    required this.topic,
    required this.data,
  });

  final String topic;
  final dynamic data;
  @override
  State<ProfileRowWidget> createState() => _ProfileRowWidgetState();
}

class _ProfileRowWidgetState extends State<ProfileRowWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: textGrey,
          ),
          borderRadius: BorderRadius.circular(10)// fixed this: should be Border.all(), not BoxBorder.all()
      ),
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.topic,
            style: const TextStyle(
              color: textGrey,
              fontSize: 15,
            ),
          ),
          Text(
            "${widget.data}",
            style: const TextStyle(
              color: textBlack,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
