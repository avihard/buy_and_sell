import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/utils/utils.dart';

class PsDropdownBaseWithControllerWidget extends StatelessWidget {
  const PsDropdownBaseWithControllerWidget(
      {Key key,
      @required this.title,
      @required this.onTap,
      this.textEditingController,
      this.isStar = false})
      : super(key: key);

  final String title;
  final TextEditingController textEditingController;
  final Function onTap;
  final bool isStar;

  @override
  Widget build(BuildContext context) {
    final Widget _productTextWidget =
        Text(title, style: Theme.of(context).textTheme.bodyText2);
    final Widget _productTextWithStarWidget = Row(
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.bodyText2),
        Text(' *',
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: PsColors.mainColor))
      ],
    );

    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space12,
              top: PsDimens.space4,
              right: PsDimens.space12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: <Widget>[
              if (isStar) _productTextWithStarWidget,
              if (!isStar) _productTextWidget,
            ],
          ),
        ),
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: PsDimens.space44,
            margin: const EdgeInsets.all(PsDimens.space12),
            decoration: BoxDecoration(
              color: PsColors.backgroundColor,
              borderRadius: BorderRadius.circular(PsDimens.space16),
              border: Border.all(color: PsColors.mainDividerColor),
            ),
            child: Ink(
              child: Container(
                color: Colors.white,
                margin: const EdgeInsets.all(PsDimens.space12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      child: Ink(
                        child: Text(
                          textEditingController.text == ''
                              ? Utils.getString(context, 'home_search__not_set')
                              : textEditingController.text,
                          style: textEditingController.text == ''
                              ? Theme.of(context).textTheme.bodyText1.copyWith(
                                  color: PsColors.textPrimaryLightColor)
                              : Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
