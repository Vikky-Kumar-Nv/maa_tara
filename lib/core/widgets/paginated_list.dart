import 'package:flutter/material.dart';
import 'package:maa_tara/core/constants/colors.dart';

typedef _C = AppColors;

// ─────────────────────────────────────────────────────────────────────────────
//  MAA TARA AUTOMOBILES — Reusable Infinite Scroll Paginated List View
//  Uses CustomScrollView + SliverList for TRUE lazy rendering (no shrinkWrap)
// ─────────────────────────────────────────────────────────────────────────────
class PaginatedListView<T> extends StatefulWidget {
  /// The list of items currently loaded
  final List<T> items;

  /// Builder for individual list items
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Optional separator builder (defaults to SizedBox(height: 12))
  final IndexedWidgetBuilder? separatorBuilder;

  /// Callback when user pulls down to refresh (reloads Page 1)
  final Future<void> Function() onRefresh;

  /// Callback when user scrolls near the bottom to fetch next page
  final Future<void> Function() onLoadMore;

  /// Whether there are more pages/items available in backend
  final bool hasMore;

  /// Whether a page load is currently in progress
  final bool isLoadingMore;

  /// Whether initial data is being fetched (shows skeleton/shimmer)
  final bool isInitialLoading;

  /// Custom initial loading / shimmer widget
  final Widget? initialLoadingWidget;

  /// Custom empty state widget when items is empty
  final Widget? emptyWidget;

  /// Optional header widget placed above the list (e.g. search/filter bars, KPIs)
  final Widget? header;

  /// Optional footer widget
  final Widget? footer;

  /// How close to the bottom (in pixels) the user must scroll before triggering [onLoadMore]
  final double scrollThreshold;

  /// List padding
  final EdgeInsetsGeometry padding;

  /// Scroll physics (defaults to BouncingScrollPhysics)
  final ScrollPhysics physics;

  /// Text to show when all items are loaded
  final String allLoadedMessage;

  const PaginatedListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.separatorBuilder,
    required this.onRefresh,
    required this.onLoadMore,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.isInitialLoading = false,
    this.initialLoadingWidget,
    this.emptyWidget,
    this.header,
    this.footer,
    this.scrollThreshold = 200.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    this.physics = const AlwaysScrollableScrollPhysics(
      parent: BouncingScrollPhysics(),
    ),
    this.allLoadedMessage = 'All records loaded',
  });

  @override
  State<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // Trigger load more when user is near bottom and not already loading
    if (maxScroll - currentScroll <= widget.scrollThreshold) {
      if (widget.hasMore && !widget.isLoadingMore && !widget.isInitialLoading) {
        widget.onLoadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      color: _C.accent,
      backgroundColor: _C.card,
      child: CustomScrollView(
        controller: _scrollController,
        physics: widget.physics,
        slivers: [
          // ── Padding Top ────────────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.only(
              left: widget.padding.horizontal / 2,
              right: widget.padding.horizontal / 2,
              top: (widget.padding as EdgeInsets).top,
            ),
            sliver: SliverToBoxAdapter(child: const SizedBox.shrink()),
          ),

          // ── Optional Header (Filter bars, search, stats) ──────────────────
          if (widget.header != null)
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.padding.horizontal / 2,
              ),
              sliver: SliverToBoxAdapter(child: widget.header!),
            ),

          // ── Main Content Area ─────────────────────────────────────────────
          if (widget.isInitialLoading)
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.padding.horizontal / 2,
              ),
              sliver: SliverToBoxAdapter(
                child:
                    widget.initialLoadingWidget ??
                    _buildDefaultInitialLoader(),
              ),
            )
          else if (widget.items.isEmpty)
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.padding.horizontal / 2,
              ),
              sliver: SliverToBoxAdapter(
                child: widget.emptyWidget ?? _buildDefaultEmptyState(),
              ),
            )
          else
            // ── TRUE LAZY RENDERED SLIVER LIST (no shrinkWrap!) ──────────
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.padding.horizontal / 2,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // Interleave items with separators: 0=item, 1=sep, 2=item, 3=sep...
                    final itemIndex = index ~/ 2;
                    if (index.isEven) {
                      // Item
                      return widget.itemBuilder(
                        context,
                        widget.items[itemIndex],
                        itemIndex,
                      );
                    } else {
                      // Separator
                      if (widget.separatorBuilder != null) {
                        return widget.separatorBuilder!(context, itemIndex);
                      }
                      return const SizedBox(height: 12);
                    }
                  },
                  childCount: widget.items.length * 2 - 1,
                ),
              ),
            ),

          // ── Bottom Pagination Loading / End of List Indicator ───────────
          if (widget.items.isNotEmpty)
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.padding.horizontal / 2,
              ),
              sliver: SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: widget.isLoadingMore
                      ? _buildBottomLoadingIndicator()
                      : (!widget.hasMore
                            ? _buildAllLoadedIndicator()
                            : const SizedBox.shrink()),
                ),
              ),
            ),

          // ── Optional Footer ────────────────────────────────────────────────
          if (widget.footer != null)
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.padding.horizontal / 2,
              ),
              sliver: SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: widget.footer!,
                ),
              ),
            ),

          // ── Bottom spacing ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: SizedBox(
              height: (widget.padding as EdgeInsets).bottom + 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.center,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(_C.accent),
            ),
          ),
          SizedBox(width: 10),
          Text(
            'Loading more records...',
            style: TextStyle(
              color: _C.muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllLoadedIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 24, height: 1, color: _C.divider),
          const SizedBox(width: 8),
          const Icon(Icons.check_circle_outline, size: 14, color: _C.muted),
          const SizedBox(width: 6),
          Text(
            '${widget.allLoadedMessage} (${widget.items.length})',
            style: const TextStyle(
              color: _C.muted,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Container(width: 24, height: 1, color: _C.divider),
        ],
      ),
    );
  }

  Widget _buildDefaultInitialLoader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(_C.accent),
      ),
    );
  }

  Widget _buildDefaultEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      alignment: Alignment.center,
      child: const Column(
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: _C.muted),
          SizedBox(height: 12),
          Text(
            'No records found',
            style: TextStyle(
              color: _C.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
