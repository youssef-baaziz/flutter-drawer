import 'package:flutter/material.dart';
import '../widgets/drawer_menu.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ids = List<int>.generate(18, (i) => 10 + i); // 10..27

    return Scaffold(
      drawer: const AppDrawer(currentRoute: '/gallery'),
      appBar: AppBar(
        title: const Text('Galerie'),
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Rafraîchir',
            onPressed: () {
              // Optionally implement refresh logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Rafraîchir bientôt!')),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2 / 3,
        ),
        itemCount: ids.length,
        itemBuilder: (context, i) {
          final url = 'https://picsum.photos/id/${ids[i]}/400/600';
          return Hero(
            tag: url,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      backgroundColor: Colors.transparent,
                      insetPadding: const EdgeInsets.all(16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            InteractiveViewer(
                              minScale: 0.8,
                              maxScale: 4,
                              child: Hero(
                                tag: url,
                                child: Image.network(
                                  url,
                                  fit: BoxFit.contain,
                                  loadingBuilder: (c, w, progress) {
                                    if (progress == null) return w;
                                    return const SizedBox(
                                      height: 400,
                                      child: Center(child: CircularProgressIndicator()),
                                    );
                                  },
                                  errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image, size: 64)),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white, size: 28),
                              onPressed: () => Navigator.of(context).pop(),
                              tooltip: 'Fermer',
                              splashRadius: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded || frame != null) {
                          return AnimatedOpacity(
                            opacity: 1,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeIn,
                            child: child,
                          );
                        }
                        return const ColoredBox(
                          color: Color(0x11000000),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                      loadingBuilder: (c, w, progress) {
                        if (progress == null) return w;
                        return const ColoredBox(
                          color: Color(0x11000000),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image, size: 40)),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
