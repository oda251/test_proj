import 'package:flutter/material.dart';

class FlexPopupMenuButton extends StatefulWidget {
  final BuildContext context;
  final Widget child;
  final List<FlexPopupMenuItem> items;
  final Offset offset;
  final double popupWidth;
  final Alignment alignment;
  final bool dismissOnTapInside;
  final bool dismissOnTapOutside;
  final OverlayPortalController controller;

  // プライベートコンストラクタ（直接呼び出し不可）
  const FlexPopupMenuButton._({
    required this.context,
    required this.child,
    required this.items,
    required this.controller,
    this.popupWidth = 200,
    this.alignment = Alignment.topLeft,
    this.offset = const Offset(0, 0),
    this.dismissOnTapInside = true,
    this.dismissOnTapOutside = true,
  });

  factory FlexPopupMenuButton.icon({
    required BuildContext context,
    required Widget icon,
    required List<FlexPopupMenuItem> items,
    double popupWidth = 200,
    Alignment alignment = Alignment.topLeft,
    Offset offset = const Offset(0, 0),
    bool dismissOnTapInside = true,
    bool dismissOnTapOutside = true,
  }) {
    OverlayPortalController controller = OverlayPortalController();
    return FlexPopupMenuButton._(
      context: context,
      items: items,
      alignment: alignment,
      controller: controller,
      popupWidth: popupWidth,
      offset: offset,
      dismissOnTapInside: dismissOnTapInside,
      dismissOnTapOutside: dismissOnTapOutside,
      child: IconButton(icon: icon, onPressed: controller.toggle),
    );
  }

  @override
  State<FlexPopupMenuButton> createState() => _FlexPopupMenuButtonState();
}

class _FlexPopupMenuButtonState extends State<FlexPopupMenuButton> {
  final LayerLink _link = LayerLink();

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: widget.controller,
        overlayChildBuilder: (BuildContext context) {
          return Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTapUp: widget.dismissOnTapOutside
                      ? (e) => widget.controller.hide()
                      : (e) {},
                  child: Container(color: Colors.transparent),
                ),
              ),
              CompositedTransformFollower(
                link: _link,
                targetAnchor: Alignment.topLeft,
                offset: widget.offset,
                child: Align(
                  alignment: widget.alignment,
                  child: _FlexPopupMenu(
                    items: widget.items,
                    controller: widget.controller,
                    width: widget.popupWidth,
                  ),
                ),
              ),
            ],
          );
        },
        child: widget.child,
      ),
    );
  }
}

class _FlexPopupMenu extends StatelessWidget {
  final List<FlexPopupMenuItem> items;
  final OverlayPortalController controller;
  final double width;

  const _FlexPopupMenu({
    required this.items,
    required this.controller,
    this.width = 200,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
        child: SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: items.asMap().entries.map(
            (entry) {
              int index = entry.key;
              FlexPopupMenuItem item = entry.value;
              return Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        controller.hide();
                        item.onTap();
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(item.label),
                      ),
                    ),
                  ),
                  if (index < items.length - 1)
                    Container(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                ],
              );
            },
          ).toList(),
        ),
      ),
    ));
  }
}

class FlexPopupMenuItem {
  final String label;
  final VoidCallback onTap;

  FlexPopupMenuItem({required this.label, required this.onTap});
}
