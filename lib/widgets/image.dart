import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobhunt_mobile/utility/color_util.dart';

class CachedImageWidget extends StatelessWidget {
  const CachedImageWidget({
    super.key,
    required this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    
    return Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
        color: ColorUtil.isDarkMode(context) ? 
          Colors.blue.shade100.withOpacity(0.2)
          : Colors.blue.shade100,
          borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight:  Radius.circular(6)
        ),
        ),
        child: CachedNetworkImage(
        imageUrl : url,
        errorWidget: (context, url, error) {
           return Center(
            child :Image.asset('assets/png/appicon.png',
            ));
          },
          progressIndicatorBuilder: (context, url, progress) {
            return Center(
            child :Image.asset('assets/png/appicon.png',
            ));
          },
         fadeOutDuration: Duration(milliseconds: 600),
        ),
      );
  }
}


class SvgIcon extends StatelessWidget {
  const SvgIcon({super.key,required this.icon,this.color,this.width,this.height});
  final String icon;
  final double? width,height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      width: width,
      height: height,
      colorFilter: ColorFilter.mode(
       color ?? (ColorUtil.isDarkMode(context) ?
         Colors.white: Colors.black)
      , BlendMode.srcIn),
    );
  }
}