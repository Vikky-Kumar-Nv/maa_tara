import 'package:flutter/material.dart';
import 'package:maa_tara/core/constants/colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  MAA TARA AUTOMOBILES — Reusable Shimmer & Skeleton Loader System
// ─────────────────────────────────────────────────────────────────────────────

/// Core Shimmer Container providing smooth sweeping gradient animation.
class AppShimmer extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  const AppShimmer({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFF142236),
    this.highlightColor = const Color(0xFF223754),
    this.duration = const Duration(milliseconds: 1400),
  });

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.1, 0.5, 0.9],
              transform: _SlidingGradientTransform(
                slidePercent: _animation.value,
              ),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;
  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Primitive Skeleton Blocks
// ─────────────────────────────────────────────────────────────────────────────

/// Standard rectangular skeleton block
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxShape shape;
  final Color? color;
  final EdgeInsetsGeometry? margin;

  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.shape = BoxShape.rectangle,
    this.color,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? AppColors.inputFill,
        shape: shape,
        borderRadius: shape == BoxShape.circle
            ? null
            : BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Circular avatar skeleton
class SkeletonCircle extends StatelessWidget {
  final double size;
  final Color? color;

  const SkeletonCircle({super.key, required this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: size,
      height: size,
      shape: BoxShape.circle,
      color: color,
    );
  }
}

/// Rounded text line skeleton
class SkeletonLine extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const SkeletonLine({
    super.key,
    this.width,
    this.height = 12,
    this.borderRadius = 6,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: width,
      height: height,
      borderRadius: borderRadius,
      margin: margin,
    );
  }
}

/// Skeleton Card Container
class SkeletonCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;

  const SkeletonCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Specialized Page & Card Skeletons
// ─────────────────────────────────────────────────────────────────────────────

/// Skeleton Work / Job Card
class SkeletonWorkCard extends StatelessWidget {
  const SkeletonWorkCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SkeletonCard(
        margin: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row (Job ID & Status Pill)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SkeletonLine(width: 85, height: 14),
                SkeletonBox(width: 75, height: 22, borderRadius: 12),
              ],
            ),
            const SizedBox(height: 12),

            // Car Icon + Customer Info
            Row(
              children: [
                const SkeletonBox(width: 46, height: 46, borderRadius: 10),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SkeletonLine(width: 140, height: 14),
                      SizedBox(height: 6),
                      SkeletonLine(width: 100, height: 11),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Divider
            const SkeletonBox(height: 1, borderRadius: 1),
            const SizedBox(height: 12),

            // Bottom Info (Mechanic & Time)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SkeletonLine(width: 110, height: 11),
                SkeletonLine(width: 70, height: 11),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton Staff Member Card
class SkeletonStaffCard extends StatelessWidget {
  const SkeletonStaffCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SkeletonCard(
        margin: const EdgeInsets.only(bottom: 12),
        child: Column(
          children: [
            // Header Row: Avatar + Name + Role + Status Pill
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SkeletonCircle(size: 52),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SkeletonLine(width: 130, height: 15),
                      SizedBox(height: 6),
                      SkeletonLine(width: 85, height: 11),
                      SizedBox(height: 6),
                      SkeletonLine(width: 100, height: 10),
                    ],
                  ),
                ),
                const SkeletonBox(width: 65, height: 22, borderRadius: 10),
              ],
            ),
            const SizedBox(height: 14),

            // Divider
            const SkeletonBox(height: 1, borderRadius: 1),
            const SizedBox(height: 12),

            // Stats row (Works, Completed, Attendance)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SkeletonLine(width: 60, height: 12),
                SkeletonLine(width: 60, height: 12),
                SkeletonLine(width: 60, height: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton Customer Card
class SkeletonCustomerCard extends StatelessWidget {
  const SkeletonCustomerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SkeletonCard(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SkeletonCircle(size: 48),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SkeletonLine(width: 135, height: 14),
                  SizedBox(height: 6),
                  SkeletonLine(width: 95, height: 11),
                  SizedBox(height: 6),
                  SkeletonLine(width: 160, height: 11),
                ],
              ),
            ),
            const SkeletonBox(width: 32, height: 32, borderRadius: 8),
          ],
        ),
      ),
    );
  }
}

/// Skeleton Dashboard KPI Card
class SkeletonKpiCard extends StatelessWidget {
  const SkeletonKpiCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              SkeletonCircle(size: 32),
              SkeletonBox(width: 40, height: 14, borderRadius: 8),
            ],
          ),
          const SizedBox(height: 14),
          const SkeletonLine(width: 70, height: 18),
          const SizedBox(height: 6),
          const SkeletonLine(width: 90, height: 11),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Full-Page Skeleton Screen Templates
// ─────────────────────────────────────────────────────────────────────────────

/// Full Page Skeleton for Admin Dashboard
class SkeletonDashboardView extends StatelessWidget {
  const SkeletonDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLine(width: 140, height: 18),
                    SizedBox(height: 6),
                    SkeletonLine(width: 200, height: 12),
                  ],
                ),
                SkeletonBox(width: 95, height: 32, borderRadius: 18),
              ],
            ),
            const SizedBox(height: 18),

            // 4 KPI Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.35,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                SkeletonKpiCard(),
                SkeletonKpiCard(),
                SkeletonKpiCard(),
                SkeletonKpiCard(),
              ],
            ),
            const SizedBox(height: 20),

            // Quick Actions Bar
            const SkeletonBox(height: 48, borderRadius: 12),
            const SizedBox(height: 20),

            // Recent Jobs Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SkeletonLine(width: 120, height: 16),
                SkeletonLine(width: 60, height: 12),
              ],
            ),
            const SizedBox(height: 12),

            // 3 Recent Work Cards
            const SkeletonWorkCard(),
            const SkeletonWorkCard(),
            const SkeletonWorkCard(),
          ],
        ),
      ),
    );
  }
}

/// Full Page Skeleton for Staff Dashboard
class SkeletonStaffDashboardView extends StatelessWidget {
  const SkeletonStaffDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Attendance Check-In Card Skeleton
            const SkeletonCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SkeletonLine(width: 130, height: 16),
                      SkeletonBox(width: 80, height: 24, borderRadius: 12),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SkeletonLine(width: 80, height: 14),
                      SkeletonLine(width: 80, height: 14),
                      SkeletonLine(width: 80, height: 14),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Metrics Summary Row
            Row(
              children: const [
                Expanded(child: SkeletonKpiCard()),
                SizedBox(width: 12),
                Expanded(child: SkeletonKpiCard()),
              ],
            ),
            const SizedBox(height: 20),

            // Assigned Jobs Section
            const SkeletonLine(width: 140, height: 16),
            const SizedBox(height: 12),

            const SkeletonWorkCard(),
            const SkeletonWorkCard(),
            const SkeletonWorkCard(),
          ],
        ),
      ),
    );
  }
}

/// Generic Skeleton List for Works, Staff, or Customers
class SkeletonListView extends StatelessWidget {
  final int itemCount;
  final Widget itemSkeleton;

  const SkeletonListView({
    super.key,
    this.itemCount = 6,
    this.itemSkeleton = const SkeletonWorkCard(),
  });

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        itemCount: itemCount,
        itemBuilder: (context, index) => itemSkeleton,
      ),
    );
  }
}

/// Skeleton Detail Page
class SkeletonDetailsView extends StatelessWidget {
  const SkeletonDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Profile/Hero Card
            SkeletonCard(
              child: Row(
                children: const [
                  SkeletonCircle(size: 64),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLine(width: 160, height: 18),
                        SizedBox(height: 8),
                        SkeletonLine(width: 100, height: 12),
                        SizedBox(height: 8),
                        SkeletonLine(width: 120, height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Quick Actions
            Row(
              children: const [
                Expanded(child: SkeletonBox(height: 42, borderRadius: 10)),
                SizedBox(width: 10),
                Expanded(child: SkeletonBox(height: 42, borderRadius: 10)),
                SizedBox(width: 10),
                Expanded(child: SkeletonBox(height: 42, borderRadius: 10)),
              ],
            ),
            const SizedBox(height: 20),

            // Section 1
            const SkeletonLine(width: 140, height: 16),
            const SizedBox(height: 10),
            const SkeletonCard(
              child: Column(
                children: [
                  SkeletonLine(height: 14),
                  SizedBox(height: 12),
                  SkeletonLine(height: 14),
                  SizedBox(height: 12),
                  SkeletonLine(height: 14),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Section 2
            const SkeletonLine(width: 150, height: 16),
            const SizedBox(height: 10),
            const SkeletonWorkCard(),
            const SkeletonWorkCard(),
          ],
        ),
      ),
    );
  }
}
