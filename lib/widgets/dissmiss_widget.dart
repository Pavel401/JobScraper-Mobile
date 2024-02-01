import 'package:flutter/material.dart';
import 'package:jobhunt_mobile/utility/color_util.dart';
import 'package:jobhunt_mobile/widgets/anim_widget.dart';

class JobSlideWidget extends StatelessWidget {
  const JobSlideWidget({
  super.key,
  required this.jobKey,
  this.index,
  required this.child,
  required this.icon,
  this.primaryColor,
  this.onDismissed
 });

  final Key jobKey;
  final IconData icon;
  final int? index;
  final Color? primaryColor;
  final Widget child;
  final Function(DismissDirection)? onDismissed;

  @override
  Widget build(BuildContext context) {
    return AnimationFadeSlide(
      dx: index != null ? 0.05*index! : 0.3,
      duration: index != null ? 150*index! : 300,
      child: Dismissible( 
          key: jobKey,
          background: Container(
            color : primaryColor != null ? primaryColor!.withOpacity(0.25) : Theme.of(context).primaryColor.withOpacity(0.25),
            child: Icon(icon , color: Theme.of(context).primaryColor),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 20.0),
          ),
          secondaryBackground: Container(
            color: primaryColor ?? Theme.of(context).primaryColor.withOpacity(0.25),
            child: Icon(icon, color: Theme.of(context).primaryColor),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20.0),
          ),
          dismissThresholds: {
            DismissDirection.endToStart : 0.25,
            DismissDirection.startToEnd : 0.25,
          },
          onDismissed: onDismissed,
          child:Card(
          elevation: 5,
          shadowColor: ColorUtil.isDarkMode(context) ?
           Colors.black54: Colors.grey.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight:  Radius.circular(6)
            )
          ),
          child: child,
          )
      ),
    );
  }
}