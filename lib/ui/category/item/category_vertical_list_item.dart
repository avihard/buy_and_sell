import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/viewobject/category.dart';

class CategoryVerticalListItem extends StatelessWidget {
  const CategoryVerticalListItem(
      {Key key,
      @required this.category,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final Category category;

  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        child: GestureDetector(
            onTap: onTap,
            child: Card(
                elevation: 0.3,
                //borderOnForeground: false,
                shape:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                child: Container(
                    child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: <Widget>[
                            PsNetworkImage(
                              photoKey: '',
                              defaultPhoto: category.defaultPhoto,
                              width: PsDimens.space200,
                              height: double.infinity,
                              boxfit: BoxFit.cover,
                            ),
                            Container(
                              width: 200,
                              height: double.infinity,
                              color: PsColors.black.withAlpha(110),
                            )
                          ],
                        )),
                    Text(
                      category.catName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                          color: PsColors.white, fontWeight: FontWeight.bold),
                    ),
                    /*Container(
                        child: Positioned(
                      bottom: 10,
                      left: 10,
                      child: PsNetworkCircleIconImage(
                        photoKey: '',
                        defaultIcon: category.defaultIcon,
                        width: PsDimens.space40,
                        height: PsDimens.space40,
                        boxfit: BoxFit.cover,
                        onTap: onTap,
                      ),
                    )),*/
                  ],
                )))),
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 100 * (1.0 - animation.value), 0.0),
                child: child),
          );
        });
  }
}
