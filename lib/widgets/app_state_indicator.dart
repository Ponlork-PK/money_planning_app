import 'package:flutter/material.dart';

/// Renders a loading spinner, an error message with a retry button, or nothing.
///
/// Useful as the first widget in a scrollable content column to indicate state.
class AppStateIndicator extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final VoidCallback? onRetry;

  const AppStateIndicator({
    super.key,
    required this.isLoading,
    this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: LinearProgressIndicator(minHeight: 2),
      );
    }

    final err = error;
    if (err != null && err.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(err, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
