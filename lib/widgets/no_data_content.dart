import 'package:flutter/material.dart';

class NoDataContent extends StatelessWidget {
  const NoDataContent({
    super.key,
    required this.image,
    required this.firstText,
    required this.secondText,
  });

  final Image image;
  final String firstText;
  final String secondText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image,
          Text(
            firstText,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            secondText,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                ),
          ),
        ],
      ),
    );
  }
}
