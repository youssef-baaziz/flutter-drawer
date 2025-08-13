import 'package:flutter/material.dart';
import '../widgets/drawer_menu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      drawer: const AppDrawer(currentRoute: '/'),
      appBar: AppBar(
        title: const Text('Accueil'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.8, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.elasticOut,
                    builder: (context, scale, child) => Transform.scale(
                      scale: scale,
                      child: child,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.home_rounded,
                          size: 90,
                          color: theme.colorScheme.primary.withOpacity(0.12),
                        ),
                        ShaderMask(
                          shaderCallback: (rect) => LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.secondary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(rect),
                          child: const Icon(
                            Icons.home_rounded,
                            size: 72,
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 18,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 1200),
                            curve: Curves.easeOutBack,
                            builder: (context, value, child) => Opacity(
                              opacity: value,
                              child: Transform.scale(
                                scale: value,
                                child: child,
                              ),
                            ),
                            child: const Text(
                              '🏡',
                              style: TextStyle(fontSize: 28),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Bienvenue !',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Cette application vous permet d'explorer :",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _CuteMenuList(),
                  const SizedBox(height: 24),
                  AnimatedOpacity(
                    opacity: 1,
                    duration: const Duration(milliseconds: 1200),
                    child: Text(
                      "✨ Amusez-vous bien ! ✨",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CuteMenuList extends StatelessWidget {
  final List<_MenuItem> items = const [
    _MenuItem(
      icon: Icons.exposure_plus_1_rounded,
      label: "Compteur",
      emoji: "🔢",
    ),
    _MenuItem(
      icon: Icons.contacts_rounded,
      label: "Contacts",
      emoji: "👥",
    ),
    _MenuItem(
      icon: Icons.wb_sunny_rounded,
      label: "Météo",
      emoji: "🌤️",
    ),
    _MenuItem(
      icon: Icons.photo_library_rounded,
      label: "Galerie",
      emoji: "🖼️",
    ),
  ];

  const _CuteMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.08),
                    child: Icon(item.icon, color: theme.colorScheme.primary),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    item.label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String emoji;
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.emoji,
  });
}
