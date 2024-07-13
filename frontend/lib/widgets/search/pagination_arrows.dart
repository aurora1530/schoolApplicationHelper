import 'package:flutter/material.dart';

class PaginationArrows extends StatelessWidget {
  const PaginationArrows({
    super.key,
    required int currentPage,
    required int pageCount,
    required this.toPreviousPage,
    required this.toNextPage,
  })  : _currentPage = currentPage,
        _pageCount = pageCount;

  final int _currentPage;
  final int _pageCount;
  final VoidCallback toPreviousPage;
  final VoidCallback toNextPage;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 50,
          ),
          onPressed: _currentPage > 1 ? toPreviousPage : null,
        ),
        Text('$_currentPage / $_pageCount', style: theme.textTheme.titleLarge),
        IconButton(
          icon: const Icon(
            Icons.arrow_forward,
            size: 50,
          ),
          onPressed: _currentPage < _pageCount ? toNextPage : null,
        ),
      ],
    );
  }
}
