import 'package:flutter/material.dart';
import 'package:busco/utils/colors.dart';

class LoadinBar extends StatelessWidget {
  const LoadinBar({
    Key? key,
    required this.show,
  }) : super(key: key);

  final bool show;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: show
          ? const LinearProgressIndicator(
              color: Color(LOADING_BAR_COLOR),
            )
          : null,
    );
  }
}
