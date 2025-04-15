import 'package:get/get.dart';

import '../styles/style.dart';

mixin LoadMoreMixin<T extends StatefulWidget> on State<T> {
  ScrollController scrollController = ScrollController();
  static const _lockTime = 1;
  bool _isLocking = false;

  @protected
  @mustCallSuper
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (!_isLocking) {
        if (scrollController.position.pixels /
                scrollController.position.maxScrollExtent >
            0.33) {
          _isLocking = true;
          onLoadMore();
          Future.delayed(const Duration(seconds: _lockTime)).then((_) {
            _isLocking = false;
          });
        }
      }
    });
  }

  @protected
  void onLoadMore();
}
mixin LoadMoreState on GetxController {
  ScrollController scrollController = ScrollController();
  static const _lockTime = 1;
  bool _isLocking = false;
  double get position => scrollController.position.pixels;
  double get maxScroll => scrollController.position.maxScrollExtent;
  bool get _loadmore => position / maxScroll > 0.33;
  @protected
  @mustCallSuper
  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if (!_isLocking && _loadmore) {
        _isLocking = true;
        onLoadMore();
        Future.delayed(const Duration(seconds: _lockTime)).then((_) {
          _isLocking = false;
        });
      }
    });
  }

  @protected
  void onLoadMore();
}
