import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SwitchButton extends StatefulWidget {
  double width = 120;
  double height = 40;
  List<String> tabs;
  PageController controller;
  Color unSelectColor;
  Color selectColor;
  int currentIndex;

  SwitchButton({
    Key key,
    this.width,
    this.height,
    this.controller,
    @required this.tabs,
    this.unSelectColor,
    this.selectColor,
    this.currentIndex,
  }) : super(key: key);

  @override
  _SwitchButtonState createState() {
    return _SwitchButtonState();
  }
}

class _SwitchButtonState extends State<SwitchButton> {
  double centerPoint;
  Duration _duration = Duration(milliseconds: 100);
  double _padding = 4;
  double _dragDistance = 0;

  @override
  void initState() {
    super.initState();
    this.centerPoint = widget.width / 2;
  }

  @override
  void dispose() {
    super.dispose();
  }

  changePage(int currentIndex) {
    widget.currentIndex = currentIndex;
    if (widget.controller != null) {
      widget.controller.animateToPage(
        currentIndex,
        duration: _duration,
        curve: Curves.ease,
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
            if (widget.currentIndex == 0) {
              currentIndex = 1;
            } else {
              currentIndex = 0;
            }
            changePage(currentIndex);
          },
        ),
        AnimatedPositioned(
          left: widget.currentIndex == 0 ? 0 : this.centerPoint - _padding,
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
                  widget.tabs[widget.currentIndex] ?? "",
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
  }
}
