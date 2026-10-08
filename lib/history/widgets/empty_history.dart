import 'package:flutter/material.dart';

class EmptyHistory extends StatefulWidget {
  const EmptyHistory({super.key});

  @override
  State<EmptyHistory> createState() => _EmptyHistoryState();
}

class _EmptyHistoryState extends State<EmptyHistory>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  late final Animation<double> _naikTurun = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _naikTurun,
            builder: (context, child) => Transform.translate(
              offset: Offset(0, -10 * _naikTurun.value),
              child: child,
            ),
            child: const Icon(Icons.receipt_long, size: 64, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          const Text(
            'Tidak ada transaksi.',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}