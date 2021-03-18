import 'package:flutter/material.dart';
import 'package:good_movie_fan/app.dart';
import 'package:good_movie_fan/dialog/search_dialog.dart';
import 'package:good_movie_fan/strings.dart';

const int _animationDuration = 500;

class Fab extends StatefulWidget {
  Function(bool) onToggle;

  Fab(this.onToggle);

  @override
  _FabState createState() => _FabState();
}

class _FabState extends State<Fab>
    with SingleTickerProviderStateMixin, RouteAware {
  AnimationController _animationController;
  Animation<Color> _animateColor;
  Animation<double> _animateIcon;
  Curve _curve = Curves.slowMiddle;
  bool _closed = true;
  OverlayEntry _overlayButtons;

  @override
  initState() {
    _initAnimation();
    _initOverlayButtons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    _animateColor = ColorTween(
      begin: theme.accentColor,
      end: theme.bottomNavigationBarTheme.backgroundColor,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        1.0,
        curve: _curve,
      ),
    ));
    return FloatingActionButton(
      backgroundColor: _animateColor.value,
      tooltip: Strings.searchMovies,
      onPressed: () => setState(() => _toggle()),
      child: AnimatedIcon(
        icon: AnimatedIcons.search_ellipsis,
        progress: _animateIcon,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  dispose() {
    _animationController.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPushNext() {
    if (!_closed) {
      _toggle(timeout: 0);
    }
  }

  void _initAnimation() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: _animationDuration))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  void _initOverlayButtons() {
    _overlayButtons = new OverlayEntry(builder: (context) {
      return new Positioned(
        bottom: 60.0,
        left: 15.0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.0),
            color: Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _menuButton(
                  title: Strings.filter,
                  icon: Icons.saved_search,
                  onPressed: () {
                    _toggle();
                    _showSearchDialog();
                  }),
              const SizedBox(height: 10.0),
              _menuButton(
                  title: Strings.discover,
                  icon: Icons.movie,
                  onPressed: () {
                    _toggle();
                    //TODO trending, top rated, latest, upcoming, popular, now playing
                  }),
              const SizedBox(height: 10.0),
              _menuButton(
                  title: Strings.feelingLucky,
                  icon: Icons.sentiment_satisfied_alt,
                  onPressed: () {
                    _toggle();
                    //TODO random
                  }),
            ],
          ),
        ),
      );
    });
  }

  Widget _menuButton(
      {@required String title, IconData icon, Function() onPressed}) {
    var theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        color: theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [BoxShadow(blurRadius: 5.0, color: theme.shadowColor)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              color: theme.textTheme.button.color,
            ),
            TextButton(
              onPressed: onPressed,
              child: Text(title),
            ),
          ],
        ),
      ),
    );
  }

  void _toggle({int timeout = _animationDuration}) {
    _closed = !_closed;
    widget.onToggle(_closed);

    if (_closed) {
      _animationController.reverse();
      Future.delayed(Duration(milliseconds: timeout), () {
        _overlayButtons.remove();
      });
    } else {
      _animationController.forward();
      Future.delayed(Duration(milliseconds: timeout), () {
        Overlay.of(context)?.insert(_overlayButtons);
      });
    }
  }

  void _showSearchDialog() {
    Future.delayed(const Duration(milliseconds: 400), () {
      showDialog(context: context, builder: (context) => SearchDialog());
    });
  }
}
