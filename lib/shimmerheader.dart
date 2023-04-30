import 'package:animation_2/visible.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';

class ShimmerHeader extends RefreshIndicator {
  final Color baseColor, highlightColor;
  final Widget text;
  final Duration period;
  final ShimmerDirection direction;
  final Function? outerBuilder;

  ShimmerHeader(
      {required this.text,
      this.baseColor = Colors.grey,
      this.highlightColor = Colors.white,
      this.outerBuilder,
      double height: 80.0,
      this.period = const Duration(milliseconds: 1000),
      this.direction = ShimmerDirection.ltr})
      : super(height: height, refreshStyle: RefreshStyle.Behind);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ShimmerHeaderState();
  }
}

class _ShimmerHeaderState extends RefreshIndicatorState<ShimmerHeader>
    with TickerProviderStateMixin {
  AnimationController? _scaleController;
  AnimationController? _fadeController;

  @override
  void initState() {
    // TODO: implement initState
    _scaleController = AnimationController(vsync: this);
    _fadeController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void onOffsetChange(double offset) {
    // TODO: implement onOffsetChange
    if (!floating) {
      _scaleController!.value = offset / configuration!.headerTriggerDistance;
      _fadeController!.value = offset / configuration!.footerTriggerDistance;
    }
  }

  double heightContainer = 0;
  double widthContainer = 0;
  final GlobalKey _widgetKey = GlobalKey();
  Future _getWidgetInfo() async {
    print('qqqqq');
    final RenderBox renderBox =
        _widgetKey.currentContext?.findRenderObject() as RenderBox;
    print(renderBox.toString());
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    heightContainer = offset.dy;
    widthContainer = offset.dx;
  }

  showOverlay(
    BuildContext context,
    double height,
    double width,
  ) async {
    OverlayState overlayState = Overlay.of(context)!;
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          top: height - 50,
          left: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                opacity:
                    //visibleIchi ? 1 : 0,
                    context.watch<Visible>().visible ? 1 : 0,
                child: Center(
                  child: FittedBox(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_upward),
                        ),
                        widget.text
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ));
    });
    overlayState.insert(overlayEntry);
    await Future.delayed(Duration(milliseconds: 300));
    await Future.delayed(Duration(milliseconds: 300));
    overlayEntry.remove();
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus mode) {
    // TODO: implement buildContent
    mode == RefreshStatus.refreshing
        ? _getWidgetInfo().then(
            (value) {
              showOverlay(context, heightContainer, widthContainer);
            },
          )
        : null;
    final Widget body = ScaleTransition(
      scale: _scaleController!,
      child: FadeTransition(
        opacity: _fadeController!,
        child: mode == RefreshStatus.refreshing
            ? Shimmer.fromColors(
                period: widget.period,
                direction: widget.direction,
                baseColor: widget.baseColor,
                highlightColor: widget.highlightColor,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 100),
                  opacity: 1,
                  child: Center(
                    child: FittedBox(
                      child: Column(
                        key: _widgetKey,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.arrow_upward),
                          ),
                          widget.text
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Center(
                child: FittedBox(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.arrow_upward),
                      ),
                      widget.text
                    ],
                  ),
                ),
              ),
      ),
    );
    return widget.outerBuilder != null
        ? widget.outerBuilder!(body)
        : Container(
            alignment: prefix0.Alignment.center,
            child: body,
            decoration: prefix0.BoxDecoration(color: Colors.white),
          );
  }
}

class ShimmerFooter extends LoadIndicator {
  final Color baseColor, highlightColor;
  final Widget? text, failed, noMore;
  final Duration period;
  final ShimmerDirection direction;
  final Function? outerBuilder;

  ShimmerFooter(
      {required this.text,
      this.baseColor = Colors.grey,
      this.highlightColor = Colors.white,
      this.outerBuilder,
      double height: 80.0,
      this.failed,
      this.noMore,
      this.period = const Duration(milliseconds: 1000),
      this.direction = ShimmerDirection.ltr,
      LoadStyle loadStyle: LoadStyle.ShowAlways})
      : super(height: height, loadStyle: loadStyle);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ShimmerFooterState();
  }
}

class _ShimmerFooterState extends LoadIndicatorState<ShimmerFooter> {
  @override
  Widget buildContent(BuildContext context, LoadStatus mode) {
    // TODO: implement buildContent

    final Widget? body = mode == LoadStatus.failed
        ? widget.failed
        : mode == LoadStatus.noMore
            ? widget.noMore
            : mode == LoadStatus.idle
                ? Center(child: widget.text)
                : Shimmer.fromColors(
                    period: widget.period,
                    direction: widget.direction,
                    baseColor: widget.baseColor,
                    highlightColor: widget.highlightColor,
                    child: Center(
                      child: widget.text,
                    ),
                  );
    return widget.outerBuilder != null
        ? widget.outerBuilder!(body)
        : Container(
            height: widget.height,
            child: body,
            decoration: prefix0.BoxDecoration(color: Colors.black12),
          );
  }
}
