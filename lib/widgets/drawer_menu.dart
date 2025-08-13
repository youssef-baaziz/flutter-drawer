import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;
  const AppDrawer({super.key, required this.currentRoute});

  Widget _item(
    BuildContext ctx, {
    required String label,
    required IconData icon,
    required String route,
    Color? color,
  }) {
    final selected = currentRoute == route;
    final theme = Theme.of(ctx);
    return Material(
      color: selected
          ? theme.colorScheme.primary.withOpacity(0.08)
          : Colors.transparent,
      child: ListTile(
        leading: Icon(
          icon,
          color: selected
              ? theme.colorScheme.primary
              : theme.iconTheme.color,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected
                ? theme.colorScheme.primary
                : theme.textTheme.bodyLarge?.color,
          ),
        ),
        selected: selected,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () {
          if (selected) {
            Navigator.pop(ctx);
          } else {
            Navigator.pushReplacementNamed(ctx, route);
          }
        },
        trailing: selected
            ? Icon(Icons.arrow_right_rounded,
                color: theme.colorScheme.primary)
            : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        minLeadingWidth: 32,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      elevation: 12,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.95),
                    theme.colorScheme.secondary.withOpacity(0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(32),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white.withOpacity(0.12),
                    child: Icon(
                      Icons.menu_rounded,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Menu',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Naviguez entre les pages',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  /* _item(context,
                      label: 'Accueil',
                      icon: Icons.home_rounded,
                      route: '/'), */
                  _item(context,
                      label: 'Compteur',
                      icon: Icons.exposure_rounded,
                      route: '/counter'),
                  _item(context,
                      label: 'Contacts',
                      icon: Icons.contacts_rounded,
                      route: '/contacts'),
                  _item(context,
                      label: 'Météo',
                      icon: Icons.cloud_rounded,
                      route: '/meteo'),
                  _item(context,
                      label: 'Galerie',
                      icon: Icons.photo_library_rounded,
                      route: '/gallery'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16, top: 8),
              child: Text(
                '© ${DateTime.now().year} MonApp',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
