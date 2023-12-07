import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Illustration extends StatelessWidget {
  const Illustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/svg/empty.svg",
              width: MediaQuery.of(context).size.width * 0.4),
          Text(
            "No bookmarks yet",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
