import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/viewobject/category.dart';

class CategoryHorizontalListItem extends StatelessWidget {
  const CategoryHorizontalListItem({
    Key key,
    @required this.category,
    this.onTap,
  }) : super(key: key);

  final Category category;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Card(
            elevation: 0.0,
            color: PsColors.categoryBackgroundColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            margin: const EdgeInsets.symmetric(
                horizontal: PsDimens.space8, vertical: PsDimens.space12),
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              width: PsDimens.space100,
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: PsColors.backgroundColor,
                ),
                child: Center(
                  child: Stack(
                    children: [
                      Stack(
                        children: [
                          Center(
                            child: PsNetworkImage(
                              photoKey: '',
                              defaultPhoto: category.defaultPhoto,
                              width: PsDimens.space160,
                              height: PsDimens.space160,
                              boxfit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            // width: 200,
                            // height: double.infinity,
                            decoration: BoxDecoration(
                                color: PsColors.black.withAlpha(110),
                                borderRadius: BorderRadius.circular(16)),
                          )
                        ],
                      ),
                      Center(
                        child: Text(
                          category.catName,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
