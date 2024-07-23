import 'package:flutter/material.dart';
import 'package:qaz_tracker/common/widgets/app_loading_widget.dart';

class AppOverlayLoadingWidget extends StatelessWidget {
  final Widget? child;
  final bool? isLoading;
  const AppOverlayLoadingWidget({
    Key? key,
    this.child,
    @required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      isLoading!
          ? const Positioned.fill(child: AppLoaderWidget())
          : const SizedBox()
    ]);
  }
}
