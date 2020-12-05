# flutter_Switch
一个滑动开关UI
效果预览
 ![image-w100](https://github.com/Luy7788/flutter_switch/blob/main/preview/icon1.png)

点击右滑动动画，同时下面的PageView页面也跟着画的
 ![image](https://github.com/Luy7788/flutter_switch/blob/main/preview/2020-11-1612.15.53.gif)
 
使用方式
```
SwitchButton(
    width: 120, //宽度
    height: 44, //高度
    controller: mPageController, //下面的PageView的controller
    tabs: ['推荐', '热门'], 
    selectColor: Colors.white,
    unSelectColor: Colors.grey[300],
    currentIndex: 0,//选中
  ),
```

分析下结构，首先最底下有个灰色的背景，上面有个白色的选中框，最上面是两个Text，然后当点击到空白灰色时，控制白色的选中框移动，而且需要添加一个动画过渡效果。

首先创建一个SwitchButton widget,继承StatefulWidget，方便更新自身状态
```
class SwitchButton extends StatefulWidget {
  double width = 120;
  double height = 40;
  List<String> tabs;//两个选项
  PageController controller;
  Color unSelectColor; //未选中底色
  Color selectColor; //白色选中框
  int currentIndex; //当前在哪个选项

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

```

SwitchButtonState中的主要几个点：
```
  double centerPoint; //中心点
  Duration _duration = Duration(milliseconds: 100); //动画时长

  @override
  void initState() {
    super.initState();
    this.centerPoint = widget.width / 2;//计算中心点
  }

  //切换选项的方法
  changePage(int currentIndex) {
    widget.currentIndex = currentIndex;
    if (widget.controller != null) {
      //控制外层pageview跟着滑动
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
        backgroundWidget(),
        switchWidget(),
      ],
    );
  }

  backgroundWidget() {
    //添加点击，用来点击滑动对应位置
    return GestureDetector(
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          //设置底色和圆角
          color: widget.unSelectColor ?? Colors.grey[200],
          borderRadius: BorderRadius.circular(widget.height / 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              widget.tabs[0] ?? "",
            ),
            Text(
              widget.tabs[1] ?? "",
            ),
          ],
        ),
      ),
      onTap: () {
        //点击事件
        int currentIndex;
        if (widget.currentIndex == 0) {
          currentIndex = 1;
        } else {
          currentIndex = 0;
        }
        //切换选项
        changePage(currentIndex);
      },
    );
  }

```
```
 //白色开关控件
  switchWidget() {
    //添加位置的动画
    return AnimatedPositioned(
      //这里根据选中选项，判断左侧的边距
      left: widget.currentIndex == 0 ? 0 : this.centerPoint - _padding,
      duration: _duration,
      child: GestureDetector(
        //添加滑动手势
        onHorizontalDragUpdate: (DragUpdateDetails value) {
          _dragDistance = value.localPosition.dx;
        },
        onHorizontalDragEnd: (DragEndDetails value) {
          //判断滑动手势结束时应该让白色按键往哪滑动
          if (_dragDistance < -10) {
            changePage(0);
          } else if (_dragDistance > 10) {
            changePage(1);
          }
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
            ),
          ),
        ),
      ),
    );
  }
```

具体实现可看demo
