import 'package:flutter/material.dart';


class StaggeredItem extends StatelessWidget {
  final int index;
  final Widget child;

  const StaggeredItem({super.key, required this.index, required this.child});

  static const _durasiItem = 300;
  static const _jedaPerItem = 60; 

  @override
  Widget build(BuildContext context) {
    final urutan = index > 8 ? 8 : index; 
    final delay = urutan * _jedaPerItem;
    final total = _durasiItem + delay;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: total),
      curve: Curves.linear,
      child: child,
      builder: (context, t, child) {
        final p = Curves.easeOut
            .transform(((t * total - delay) / _durasiItem).clamp(0.0, 1.0));
        return Opacity(
          opacity: p,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - p)),
            child: child,
          ),
        );
      },
    );
  }
}