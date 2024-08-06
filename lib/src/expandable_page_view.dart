import 'package:flutter/material.dart';

class ExpandablePageView extends StatefulWidget {
  const ExpandablePageView({
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.onPageChanged,
    this.reverse = false,
    this.currentIndex = 0,
    super.key,
  });
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final PageController? controller;
  final ValueChanged<int>? onPageChanged;
  final int currentIndex;
  final bool reverse;

  @override
  _ExpandablePageViewState createState() => _ExpandablePageViewState();
}

class _ExpandablePageViewState extends State<ExpandablePageView> {
  PageController? _pageController;

  // ignore: unused_field
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = widget.controller ?? PageController(viewportFraction: 1);
    _currentIndex = widget.currentIndex;
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  double _selectedPageHeight = 0;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      curve: Curves.easeInOut,
      tween:
          Tween<double>(begin: _selectedPageHeight, end: _selectedPageHeight),
      duration: const Duration(milliseconds: 100),
      builder: (context, value, child) => SizedBox(height: value, child: child),
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.itemCount,
        itemBuilder: _itemBuilder,
        onPageChanged: widget.onPageChanged,
        reverse: widget.reverse,
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final item = widget.itemBuilder(context, index);
    _currentIndex = index;
    return OverflowBox(
      minHeight: 0,
      maxHeight: double.infinity,
      alignment: Alignment.topCenter,
      child: SizeReportingWidget(
        onSizeChange: (size) {
          setState(() {
            _selectedPageHeight = size.height;
          });
        },
        child: item,
      ),
    );
  }
}

class SizeReportingWidget extends StatefulWidget {
  const SizeReportingWidget({
    required this.child,
    required this.onSizeChange,
    super.key,
  });
  final Widget child;
  final ValueChanged<Size> onSizeChange;

  @override
  _SizeReportingWidgetState createState() => _SizeReportingWidgetState();
}

class _SizeReportingWidgetState extends State<SizeReportingWidget> {
  Size? _oldSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _notifySize() {
    final size = context.size;
    if (_oldSize != size) {
      _oldSize = size;
      if (size != null) {
        widget.onSizeChange(size);
      }
    }
  }
}
