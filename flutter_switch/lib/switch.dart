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
  double value;
  Duration _duration = Duration(milliseconds: 100);
  double padding = 4;

  @override
  void initState() {
    super.initState();
    this.centerPoint = widget.width / 2;
    this.value = 0;
  }

  @override
  void dispose() {
    super.dispose();
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
                if (this.value == 0.0) {
                  this.value = widget.width / 2;
                  currentIndex = 1;
                } else {
                  currentIndex = 0;
                  this.value = 0.0;
                }
                provider.changePage(currentIndex);
                if (widget.controller != null) {
                  widget.controller.animateToPage(
                    currentIndex,
                    duration: _duration,
                    curve: Curves.ease,
                  );
                }
                setState(() {});
              },
            ),
            AnimatedPositioned(
              left: provider.page == 0 ? 0 : this.centerPoint - padding,
              duration: _duration,
              child: Container(
                width: centerPoint - padding,
                height: widget.height - padding * 2,
                decoration: BoxDecoration(
                  color: widget.selectColor ?? Colors.white,
                  borderRadius: BorderRadius.circular(
                    (widget.height - padding * 2) / 2,
                  ),
                ),
                margin: EdgeInsets.all(padding),
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
          ],
        );
      },
    );
  }
}
