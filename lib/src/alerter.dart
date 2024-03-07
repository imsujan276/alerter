import 'package:flutter/material.dart';

import 'enum.dart';

class Alerter {
  /// show the alert/snackbar with the given [message]
  ///
  /// [context] - the context of the widget
  ///
  /// [message] - the message to be shown in the alert/snackbar. It is required
  ///
  /// [title] - the title of the alert/snackbar
  ///
  /// [backgroundColor] - the background color of the alert/snackbar. default is black87
  ///
  /// [textColor] - the text color of the alert/snackbar. default is white
  ///
  /// [iconColor] - the icon color of the alert/snackbar. default is white
  ///
  /// [icon] - the icon of the alert/snackbar. default is null
  ///
  /// [iconSize] - the size of the icon of the alert/snackbar. default is 35
  ///
  /// [isIconAnimated] - indicates if the icon should be animated. default is true
  ///
  /// [duration] - the duration of the alert/snackbar. default is [OverlayDuration.normal]
  ///
  /// [position] - the position of the alert/snackbar. default is [OverlayPosition.bottom]
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    IconData? icon,
    double? iconSize,
    bool isIconAnimated = true,
    OverlayDuration duration = OverlayDuration.normal,
    OverlayPosition position = OverlayPosition.bottom,
  }) {
    OverlayView.createView(
      context,
      title: title,
      message: message,
      duration: duration,
      position: position,
      backgroundColor: backgroundColor,
      textColor: textColor,
      iconColor: iconColor,
      icon: icon,
      iconSize: iconSize,
      isIconAnimated: isIconAnimated,
    );
  }

  /// manually dismiss the alert/snackbar
  static void dismiss() => OverlayView.dismiss();
}

class OverlayView {
  static final OverlayView _singleton = OverlayView._internal();

  factory OverlayView() {
    return _singleton;
  }

  OverlayView._internal();

  /// instance to create overlay view
  static late OverlayState? _overlayState;

  /// instance that holds the overlay view
  static late OverlayEntry _overlayEntry;

  /// indicates if the overlay view is visible
  static bool _isVisible = false;

  /// create the overlay view with the given parameters
  static void createView(
    BuildContext context, {
    required String message,
    String? title,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    IconData? icon,
    double? iconSize,
    bool? isIconAnimated,
    required OverlayDuration duration,
    required OverlayPosition position,
  }) {
    _overlayState = Navigator.of(context).overlay;
    if (_isVisible) dismiss();

    if (!_isVisible) {
      _isVisible = true;

      _overlayEntry = OverlayEntry(builder: (context) {
        return EdgeOverlay(
          title: title,
          message: message,
          duration: duration,
          position: position,
          backgroundColor: backgroundColor,
          textColor: textColor,
          iconColor: iconColor,
          icon: icon,
          iconSize: iconSize,
          isIconAnimated: isIconAnimated,
        );
      });

      _overlayState?.insert(_overlayEntry);
    }
  }

  /// dismiss the overlay view if it is visible
  static dismiss() async {
    if (!_isVisible) return;
    _isVisible = false;
    _overlayEntry.remove();
  }
}

class EdgeOverlay extends StatefulWidget {
  /// title of the overlay
  final String? title;

  /// message of the overlay
  final String message;

  /// background color of the overlay. default is black87
  final Color? backgroundColor;

  /// text color of the overlay. default is white
  final Color? textColor;

  /// icon color of the overlay. default is white
  final Color? iconColor;

  /// icon of the overlay
  final IconData? icon;

  /// duration of the overlay for which the alerter will be visible
  ///
  /// [OverlayDuration.short] - 2 seconds
  /// [OverlayDuration.normal] - 3 seconds
  /// [OverlayDuration.long] - 4 seconds
  /// [OverlayDuration.veryLong] - 5 seconds
  ///
  /// default is [OverlayDuration.normal]
  final OverlayDuration duration;

  /// position of the overlay
  ///
  /// [OverlayPosition.top] - overlay will be shown at the top of the screen
  /// [OverlayPosition.bottom] - overlay will be shown at the bottom of the screen
  ///
  /// default is [OverlayPosition.bottom]
  final OverlayPosition position;

  /// icon size of the overlay
  ///
  /// default is 35
  final double? iconSize;

  /// indicates if the icon should be animated
  ///
  /// default is true
  final bool? isIconAnimated;

  const EdgeOverlay({
    super.key,
    required this.message,
    this.title,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.icon,
    this.iconSize,
    this.isIconAnimated,
    required this.duration,
    required this.position,
  });

  @override
  State<EdgeOverlay> createState() => _EdgeOverlayState();
}

class _EdgeOverlayState extends State<EdgeOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Tween<Offset> _positionTween;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    if (widget.position == OverlayPosition.top) {
      _positionTween = Tween<Offset>(
        begin: const Offset(0.0, -1.0),
        end: Offset.zero,
      );
    } else {
      _positionTween = Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: const Offset(0, 0),
      );
    }

    _positionAnimation = _positionTween.animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();

    listenToAnimation();

    super.initState();
  }

  void listenToAnimation() async {
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(Duration(seconds: widget.duration.value));
        if (!mounted) return;
        _controller.reverse();
        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;
        OverlayView.dismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomHeight = MediaQuery.of(context).padding.bottom;
    return Positioned(
      top: widget.position == OverlayPosition.top ? 0 : null,
      bottom: widget.position == OverlayPosition.bottom ? 0 : null,
      child: SlideTransition(
        position: _positionAnimation,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(
            20,
            widget.position == OverlayPosition.top
                ? statusBarHeight + 20
                : bottomHeight + 20,
            20,
            widget.position == OverlayPosition.top ? 20 : 30,
          ),
          color: widget.backgroundColor ?? Colors.black87,
          child: OverlayWidget(
            title: widget.title,
            message: widget.message,
            icon: widget.icon,
            textColor: widget.textColor,
            iconColor: widget.iconColor,
            iconSize: widget.iconSize,
            isIconAnimated: widget.isIconAnimated,
          ),
        ),
      ),
    );
  }
}

class OverlayWidget extends StatelessWidget {
  /// title of the overlay
  final String? title;

  /// message of the overlay
  final String message;

  /// icon of the overlay
  final IconData? icon;

  /// text color of the overlay. default is white
  final Color? textColor, iconColor;

  /// icon size of the overlay
  final double? iconSize;

  /// indicates if the icon should be animated
  final bool? isIconAnimated;

  const OverlayWidget({
    super.key,
    required this.message,
    this.title,
    this.icon,
    this.textColor,
    this.iconColor,
    this.iconSize,
    this.isIconAnimated,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Row(
        children: [
          if (icon != null)
            AnimatedIcon(
              iconData: icon!,
              iconColor: iconColor,
              iconSize: iconSize,
              isIconAnimated: isIconAnimated ?? true,
            ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textColor ?? Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                Text(
                  message,
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedIcon extends StatefulWidget {
  /// icon of the overlay
  final IconData iconData;

  /// icon color of the overlay. default is white
  final Color? iconColor;

  /// indicates if the icon should be animated. default is true
  final bool isIconAnimated;

  /// icon size of the overlay. default is 35
  final double? iconSize;

  const AnimatedIcon({
    super.key,
    required this.iconData,
    this.iconColor,
    this.iconSize,
    required this.isIconAnimated,
  });

  @override
  AnimatedIconState createState() => AnimatedIconState();
}

class AnimatedIconState extends State<AnimatedIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.8,
      upperBound: 1.1,
      duration: const Duration(milliseconds: 600),
    );
    if (widget.isIconAnimated) {
      _controller.forward();
      listenToAnimation();
    }
  }

  listenToAnimation() async {
    _controller.addStatusListener((listener) async {
      if (listener == AnimationStatus.completed) {
        _controller.reverse();
      }
      if (listener == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: (widget.iconSize ?? 0) > 20 ? 15 : 10),
      child: AnimatedBuilder(
        animation: _controller,
        child: Icon(
          widget.iconData,
          size: widget.iconSize ?? 35,
          color: widget.iconColor ?? Colors.white,
        ),
        builder: (context, widget) => Transform.scale(
          scale: _controller.value,
          child: widget,
        ),
      ),
    );
  }
}
