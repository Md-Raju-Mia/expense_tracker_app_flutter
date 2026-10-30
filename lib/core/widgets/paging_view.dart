import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../theme/app_dimensions.dart';

/// Scroll owns only detection/lifecycle; the view model owns paging and data.
/// Mirrors the reference's 75% trigger and refresh, with a lazy list.
class PagingView extends StatefulWidget {
  const PagingView({
    required this.itemCount,
    required this.itemBuilder,
    required this.header,
    required this.footer,
    required this.canLoadNextPage,
    required this.onLoadNextPage,
    required this.onRefresh,
    this.resetKey,
    super.key,
  });
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Widget header, footer;
  final bool canLoadNextPage;
  final Future<void> Function() onLoadNextPage, onRefresh;
  final Object? resetKey;
  @override
  State<PagingView> createState() => _PagingViewState();
}

class _PagingViewState extends State<PagingView> {
  final _scroll = ScrollController();
  Timer? _debounce;
  bool _checkScheduled = false;
  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(PagingView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.resetKey != widget.resetKey && _scroll.hasClients) {
      _debounce?.cancel();
      _scroll.jumpTo(0);
    }
    _checkUnderfill();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final position = _scroll.position;
    if (position.userScrollDirection == ScrollDirection.reverse &&
        position.pixels >= position.maxScrollExtent * 0.75) {
      _queueNext();
    }
  }

  void _queueNext() {
    if (!widget.canLoadNextPage || (_debounce?.isActive ?? false)) return;
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted && widget.canLoadNextPage) widget.onLoadNextPage();
    });
  }

  void _checkUnderfill() {
    if (_checkScheduled) return;
    _checkScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScheduled = false;
      if (mounted &&
          _scroll.hasClients &&
          _scroll.position.maxScrollExtent <= 0) {
        _queueNext();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: widget.onRefresh,
    child: NotificationListener<ScrollMetricsNotification>(
      onNotification: (_) {
        _checkUnderfill();
        return false;
      },
      child: ListView.builder(
        key: const PageStorageKey('posts-feed-scroll'),
        controller: _scroll,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.xl),
        itemCount: widget.itemCount + 2,
        itemBuilder: (context, index) {
          if (index == 0) return widget.header;
          if (index == widget.itemCount + 1) return widget.footer;
          return widget.itemBuilder(context, index - 1);
        },
      ),
    ),
  );
}
