import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SwitchButtonProvider extends ChangeNotifier {
  int _currentPage = 0;

  int get page => _currentPage;

  SwitchButtonProvider(int initIndex) {
    this._currentPage = initIndex;
  }

  void changePage(int page) {
    _currentPage = page;
    notifyListeners();
  }
}

// ignore: must_be_immutable
class SwitchButton extends StatefulWidget {
  double width = 120;
  double height = 40;
  List<String> tabs;
  PageController controller;
  Color unSelectColor;
  Color selectColor;

  SwitchButton({
    Key key,
    this.width,
    this.height,
    this.controller,
    @required this.tabs,
    this.unSelectColor,
    this.selectColor,
  }) : super(key: key);

  @override
  _SwitchButtonState createState() {
    return _SwitchButtonState();
  }
}

class _SwitchButtonState extends State<SwitchButton> {
  double centerPoint;
  int _currentPage;
  Duration _duration = Duration(milliseconds: 100);
  double _padding = 4;
  double _dragDistance = 0;

  @override
  void initState() {
    super.initState();
    this.centerPoint = widget.width / 2;
    this._currentPage = 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  changePage(int currentIndex) {
    final SwitchButtonProvider provider =
        Provider.of<SwitchButtonProvider>(context, listen: false);
    provider.changePage(currentIndex);
    if (widget.controller != null) {
      widget.controller.animateToPage(
        currentIndex,
        duration: _duration,
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SwitchButtonProvider>(
      builder: (context, SwitchButtonProvider provider, child) {
        return Stack(
          children: <Widget>[
            GestureDetector(
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  color: widget.unSelectColor ?? Colors.grey[200],
                  borderRadius: BorderRadius.circular(widget.height / 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      widget.tabs[0] ?? "",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.tabs[1] ?? "",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                int currentIndex;
                if (this._currentPage == 0) {
                  this._currentPage = 1;
                  currentIndex = 1;
                } else {
                  currentIndex = 0;
                  this._currentPage = 0;
                }
                changePage(currentIndex);
              },
            ),
            AnimatedPositioned(
              left: provider.page == 0 ? 0 : this.centerPoint - _padding,
              duration: _duration,
              child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails value) {
                  _dragDistance = value.localPosition.dx;
                },
                onHorizontalDragEnd: (DragEndDetails value) {
                  if (_dragDistance < -10) {
                    changePage(0);
                  } else if (_dragDistance > 10) {
                    changePage(1);
                  }
                },
                onHorizontalDragStart: (value) {
                  _dragDistance = 0;
                },
                child: Container(
                  width: centerPoint - _padding,
                  height: widget.height - _padding * 2,
                  decoration: BoxDecoration(
                    color: widget.selectColor ?? Colors.white,
                    borderRadius: BorderRadius.circular(
                      (widget.height - _padding * 2) / 2,
                    ),
                  ),
                  margin: EdgeInsets.all(_padding),
                  child: Center(
                    child: Text(
                      widget.tabs[provider.page] ?? "",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
