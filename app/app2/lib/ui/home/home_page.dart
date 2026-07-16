import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('App2')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.apps,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(s.appName, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('${s.environment}: ${EnvConstants.flavor.label}'),
          ],
        ),
      ),
    );
  }
}
