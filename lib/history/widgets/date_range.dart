import 'package:flutter/material.dart';

class DateRangeChip extends StatelessWidget {
  final DateTimeRange range;
  final VoidCallback onClear;

  const DateRangeChip({super.key, required this.range, required this.onClear});

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InputChip(
          avatar: const Icon(Icons.date_range, size: 18),
          label: Text('${_fmt(range.start)} - ${_fmt(range.end)}'),
          onDeleted: onClear,
        ),
      ),
    );
  }
}