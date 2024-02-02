import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/routing/app_router.dart';

class BookingScreen extends ConsumerWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to booking',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              TextButton(
                  onPressed: () {
                    ref.read(goRouterProvider).goNamed(AppRoute.sauna.name);
                  },
                  child: const Text(
                    'Saunas',
                  )),
              TextButton(
                  onPressed: () {
                    ref.read(goRouterProvider).goNamed(AppRoute.laundry.name);
                  },
                  child: const Text('Laundry')),
            ],
          ),
        ),
      ),
    );
  }
}
