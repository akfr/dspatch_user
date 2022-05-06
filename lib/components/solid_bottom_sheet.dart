import 'dart:async';

import 'package:flutter/material.dart';

class SwipeConfiguration {
  //Vertical swipe configuration options
  double verticalSwipeMaxWidthThreshold = 50.0;
  double verticalSwipeMinDisplacement = 100.0;
  double verticalSwipeMinVelocity = 300.0;

  //Horizontal swipe configuration options
  double horizontalSwipeMaxHeightThreshold = 50.0;
  double horizontalSwipeMinDisplacement = 100.0;
  double horizontalSwipeMinVelocity = 300.0;

  SwipeConfiguration({
    double verticalSwipeMaxWidthThreshold,
    double verticalSwipeMinDisplacement,
    double verticalSwipeMinVelocity,
    double horizontalSwipeMaxHeightThreshold,
    double horizontalSwipeMinDisplacement,
    double horizontalSwipeMinVelocity,
  }) {
    if (verticalSwipeMaxWidthThreshold != null) {
      this.verticalSwipeMaxWidthThreshold = verticalSwipeMaxWidthThreshold;
    }

    if (verticalSwipeMinDisplacement != null) {
      this.verticalSwipeMinDisplacement = verticalSwipeMinDisplacement;
    }

    if (verticalSwipeMinVelocity != null) {
      this.verticalSwipeMinVelocity = verticalSwipeMinVelocity;
    }

    if (horizontalSwipeMaxHeightThreshold != null) {
      this.horizontalSwipeMaxHeightThreshold =
          horizontalSwipeMaxHeightThreshold;
    }

    if (horizontalSwipeMinDisplacement != null) {
      this.horizontalSwipeMinDisplacement = horizontalSwipeMinDisplacement;
    }

    if (horizontalSwipeMinVelocity != null) {
      this.horizontalSwipeMinVelocity = horizontalSwipeMinVelocity;
    }
  }
}

class SwipeDetector extends StatelessWidget {
  final Widget child;
  final Function() onSwipeUp;
  final Function() onSwipeDown;
  final Function() onSwipeLeft;
  final Function() onSwipeRight;
  final Function() onTap;
  final SwipeConfiguration swipeConfiguration;

  SwipeDetector(
      {@required this.child,
      this.onSwipeUp,
      this.onSwipeDown,
      this.onSwipeLeft,
      this.onSwipeRight,
      this.onTap,
      SwipeConfiguration swipeConfiguration})
      : this.swipeConfiguration = swipeConfiguration == null
            ? SwipeConfiguration()
            : swipeConfiguration;

  @override
  Widget build(BuildContext context) {
    //Vertical drag details
    DragStartDetails startVerticalDragDetails;
    DragUpdateDetails updateVerticalDragDetails;

    //Horizontal drag details
    DragStartDetails startHorizontalDragDetails;
    DragUpdateDetails updateHorizontalDragDetails;

    return GestureDetector(
      child: child,
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      onVerticalDragStart: (dragDetails) {
        startVerticalDragDetails = dragDetails;
      },
      onVerticalDragUpdate: (dragDetails) {
        updateVerticalDragDetails = dragDetails;
      },
      onVerticalDragEnd: (endDetails) {
        double dx = updateVerticalDragDetails.globalPosition.dx -
            startVerticalDragDetails.globalPosition.dx;
        double dy = updateVerticalDragDetails.globalPosition.dy -
            startVerticalDragDetails.globalPosition.dy;
        double velocity = endDetails.primaryVelocity;

        //Convert values to be positive
        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        double positiveVelocity = velocity < 0 ? -velocity : velocity;

        if (dx > swipeConfiguration.verticalSwipeMaxWidthThreshold) return;
        if (dy < swipeConfiguration.verticalSwipeMinDisplacement) return;
        if (positiveVelocity < swipeConfiguration.verticalSwipeMinVelocity)
          return;

        if (velocity < 0) {
          //Swipe Up
          if (onSwipeUp != null) {
            onSwipeUp();
          }
        } else {
          //Swipe Down
          if (onSwipeDown != null) {
            onSwipeDown();
          }
        }
      },
      onHorizontalDragStart: (dragDetails) {
        startHorizontalDragDetails = dragDetails;
      },
      onHorizontalDragUpdate: (dragDetails) {
        updateHorizontalDragDetails = dragDetails;
      },
      onHorizontalDragEnd: (endDetails) {
        double dx = updateHorizontalDragDetails.globalPosition.dx -
            startHorizontalDragDetails.globalPosition.dx;
        double dy = updateHorizontalDragDetails.globalPosition.dy -
            startHorizontalDragDetails.globalPosition.dy;
        double velocity = endDetails.primaryVelocity;

        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        double positiveVelocity = velocity < 0 ? -velocity : velocity;

        if (dx < swipeConfiguration.horizontalSwipeMinDisplacement) return;
        if (dy > swipeConfiguration.horizontalSwipeMaxHeightThreshold) return;
        if (positiveVelocity < swipeConfiguration.horizontalSwipeMinVelocity)
          return;

        if (velocity < 0) {
          //Swipe Up
          if (onSwipeLeft != null) {
            onSwipeLeft();
          }
        } else {
          //Swipe Down
          if (onSwipeRight != null) {
            onSwipeRight();
          }
        }
      },
    );
  }
}

class SolidBloc {
  StreamController<double> _heightController =
      StreamController<double>.broadcast();

  Stream<double> get height => _heightController.stream;

  Sink<double> get _heightSink => _heightController.sink;

  StreamController<bool> _visibilityController =
      StreamController<bool>.broadcast();

  Stream<bool> get isOpen => _visibilityController.stream;

  Sink<bool> get _visibilitySink => _visibilityController.sink;

  // Adds new values to streams
  void dispatch(double value) {
    _heightSink.add(value);
    _visibilitySink.add(value > 0);
  }

  // Closes streams
  void dispose() {
    _heightController.close();
    _visibilityController.close();
  }
}

class SolidController extends ValueNotifier<bool> {
  SolidBloc _bloc = SolidBloc();

  // This is the current height of the bottomSheet's body
  double _height;

  // This is the current smoothness of the bottomSheet
  Smoothness smoothness;

  SolidController() : super(false);

  // Returns the value of the height as stream
  Stream<double> get heightStream => _bloc.height;

  // Returns the value of the visibility as stream
  Stream<bool> get isOpenStream => _bloc.isOpen;

  // This method sets the value of the height using streams
  set height(double value) {
    _height = value;
    _bloc.dispatch(value);
  }

  // Returns the value of the height
  double get height => _height;

  //  Returns if the solid bottom sheet is opened or not
  bool get isOpened => value;

  // Updates the visibility value to false
  void hide() => value = false;

  // Updates the visibility value to true
  void show() => value = true;

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

class Smoothness {
  final int _value;

  Smoothness._() : _value = 0;

  const Smoothness._low() : _value = 100;

  const Smoothness._medium() : _value = 250;

  const Smoothness._high() : _value = 500;

  const Smoothness._withValue(int value) : _value = value;

  static const Smoothness low = Smoothness._low();
  static const Smoothness medium = Smoothness._medium();
  static const Smoothness high = Smoothness._high();

  static Smoothness withValue(int value) => Smoothness._withValue(value);

  int get value => _value;
}

class SolidBottomSheet extends StatefulWidget {
  // This controls the minimum height of the body. Must be greater or equal of
  // 0. By default is 0
  final double minHeight;

  // This controls the minimum height of the body. By default is 500
  final double maxHeight;

  // This is the content that will be hided of your bottomSheet. You can fit any
  // widget. This parameter is required
  final Widget body;

  // This is the header of your bottomSheet. This widget is the swipeable area
  // where user will interact. This parameter is required
  final Widget headerBar;

  // This flag is used to enable the automatic swipe of the bar. If it's true
  // the bottomSheet will automatically appear or disappear when user stops
  // swiping, but if it's false, it will stay at the last user finger position.
  // By default is true
  final bool autoSwiped;

  // This flag enable that users can swipe the body and hide or show the
  // solid bottom sheet. Turn on false if you don't want to let the user
  // interact with the solid bottom sheet. By default is false.
  final bool draggableBody;

  // This flag enable that users can swipe the header and hide or show the
  // solid bottom sheet. Turn on false if you don't want to let the user
  // interact with the solid bottom sheet. By default is true.
  final bool canUserSwipe; // TODO: Change to draggableHeader

  // This property defines how 'smooth' or fast will be the animation. Low is
  // the slowest velocity and high is the fastest. By default is medium.
  final Smoothness smoothness;

  // This property is the elevation of the bottomSheet. Must be greater or equal
  // to 0. By default is 0.
  final double elevation;

  // This flag controls if the body is shown to the user by default. If it's
  // true, the body will be shown. If it's false the body will be hided. By
  // default it's false.
  final bool showOnAppear; // TODO: change to openedByDefault

  // This object used to control behavior internally
  // from the app and don't depend of user's interaction.
  // can hide and show  methods plus have isOpened variable
  // to check widget visibility on a screen
  SolidController controller;

  // This method will be executed when the solid bottom sheet is completely
  // opened.
  final void Function() onShow;

  // This method will be executed when the solid bottom sheet is completely
  // closed.
  final void Function() onHide;

  SolidBottomSheet({
    Key key,
    @required this.headerBar,
    @required this.body,
    this.controller,
    this.minHeight = 0,
    this.maxHeight = 500,
    this.autoSwiped = true,
    this.canUserSwipe = true,
    this.draggableBody = false,
    this.smoothness = Smoothness.medium,
    this.elevation = 0.0,
    this.showOnAppear = false,
    this.onShow,
    this.onHide,
  })  : assert(elevation >= 0.0),
        assert(minHeight >= 0.0),
        super(key: key) {
    if (controller == null) {
      this.controller = SolidController();
    }
    this.controller.height =
        this.showOnAppear ? this.maxHeight : this.minHeight;
    this.controller.smoothness = smoothness;
  }

  @override
  SolidBottomSheetState createState() => SolidBottomSheetState();
}

class SolidBottomSheetState extends State<SolidBottomSheet> {
  bool _opened = false;

  bool get isOpened => _opened;

  void _onTap() {
    final bool isOpened = widget.controller.height == widget.maxHeight;
    widget.controller.value = !isOpened;

    if (_opened)
      hide();
    else
      show();
  }

  void Function() _controllerListener;

  @override
  void initState() {
    super.initState();
    widget.controller.value = widget.showOnAppear;
    _controllerListener = () {
      widget.controller.value ? show() : hide();
    };
    widget.controller.addListener(_controllerListener);
  }

  @override
  Widget build(BuildContext context) {
    return SwipeDetector(
        onSwipeUp: () => show(),
        onSwipeDown: () => hide(),
        onTap: () => _onTap(),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: widget.elevation > 0
                    ? BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: widget.elevation,
                        ),
                      ])
                    : null,
                width: MediaQuery.of(context).size.width,
                child: widget.headerBar,
              ),
              StreamBuilder<double>(
                stream: widget.controller.heightStream,
                initialData: widget.controller.height,
                builder: (_, snapshot) {
                  return AnimatedContainer(
                    curve: Curves.easeOut,
                    duration: Duration(
                        milliseconds: widget.controller.smoothness.value),
                    height: snapshot.data,
                    child: widget.body,
                  );
                },
              ),
            ],
          ),
        ));
  }

  void hide() {
    if (widget.onHide != null) widget.onHide();
    widget.controller.height = widget.minHeight;
    _opened = false;
  }

  void show() {
    if (widget.onShow != null) widget.onShow();
    widget.controller.height = widget.maxHeight;
    _opened = true;
  }

  @override
  void dispose() {
    widget.controller.removeListener(_controllerListener);
    super.dispose();
  }

  void _setUsersSmoothness() {
    widget.controller.smoothness = widget.smoothness;
  }

  void _setNativeSmoothness() {
    widget.controller.smoothness = Smoothness.withValue(5);
  }
}
