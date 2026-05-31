import 'package:flutter/widgets.dart';

/// Breakpoints for Altar's responsive shell.
class Breakpoints {
  Breakpoints._();
  static const double mobile = 640;
  static const double tablet = 1024;
  static const double desktop = 1440;
}

enum FormFactor { mobile, tablet, desktop }

extension ResponsiveX on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  FormFactor get formFactor {
    final w = screenWidth;
    if (w < Breakpoints.mobile) return FormFactor.mobile;
    if (w < Breakpoints.tablet) return FormFactor.tablet;
    return FormFactor.desktop;
  }

  /// True when the compact (phone) layout should be shown.
  bool get isMobile => screenWidth < Breakpoints.tablet;

  /// True when the expanded desktop layout (side rail, multi-column) is used.
  bool get isDesktop => screenWidth >= Breakpoints.tablet;
}

/// Builds different widgets per form factor. [desktop]/[tablet] fall back to
/// [mobile] when not provided.
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    switch (context.formFactor) {
      case FormFactor.desktop:
        return (desktop ?? tablet ?? mobile)(context);
      case FormFactor.tablet:
        return (tablet ?? mobile)(context);
      case FormFactor.mobile:
        return mobile(context);
    }
  }
}

/// Centers content and caps its width on large screens for comfortable reading.
class ContentBounds extends StatelessWidget {
  const ContentBounds({
    super.key,
    required this.child,
    this.maxWidth = 1180,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    // Use Align with heightFactor: 1.0 (not Center) so this sizes to the
    // child's height. A plain Center expands to fill bounded vertical
    // constraints, which would starve siblings when placed in a bounded slot
    // such as a Scaffold.bottomNavigationBar. Width still fills (widthFactor
    // null) so the constrained child stays horizontally centered.
    return Align(
      alignment: Alignment.topCenter,
      heightFactor: 1.0,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
