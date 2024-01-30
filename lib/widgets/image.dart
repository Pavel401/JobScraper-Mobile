import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
           return Icon(Icons.error); 
          },
          progressIndicatorBuilder: (context, url, progress) {
             return ColorFiltered(
            colorFilter: ColorFilter.mode(
            Theme.of(context).brightness == Brightness.dark  ?
             Colors.grey.shade700 :Colors.grey, // Grayscale color
              BlendMode.saturation,
            ),
            child : Image.asset('assets/png/icon.png'));
          },
         fadeOutDuration: Duration(milliseconds: 600),
        ),
      );
  }
}