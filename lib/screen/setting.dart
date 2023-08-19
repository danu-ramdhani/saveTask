import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:save_task/main.dart';

import '../provider/dark_mode.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final darkModeProvider = Provider.of<DarkModeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        forceMaterialTransparency: true,
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Dark mode'),
            trailing: Switch(
              activeColor: Theme.of(context).colorScheme.onBackground,
              value: darkModeProvider.isDarkMode,
              onChanged: (value) {
                darkModeProvider.toggleDarkMode();
              },
            ),
          ),
          const Divider(height: 0),
        ],
      ),
      bottomNavigationBar: isAdLoaded
          ? SizedBox(
              height: bannerAd.size.height.toDouble(),
              width: bannerAd.size.width.toDouble(),
              child: AdWidget(ad: bannerAd),
            )
          : const SizedBox(),
    );
  }
}
