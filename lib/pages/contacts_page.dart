import 'package:flutter/material.dart';
import '../widgets/drawer_menu.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = [
      {'name': 'Youssef', 'phone': '+212 661 234 567'},
      {'name': 'Fatima',  'phone': '+212 662 345 678'},
      {'name': 'Lwalid',    'phone': '+212 663 456 789'},
      {'name': 'Mama', 'phone': '+212 664 567 890'},
      {'name': 'My bro',  'phone': '+212 665 678 901'},
    ];

    return Scaffold(
      drawer: const AppDrawer(currentRoute: '/contacts'),
      appBar: AppBar(
        title: const Text('Contacts'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Future: implement search
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search coming soon!')),
              );
            },
          ),
        ],
        elevation: 2,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Future: implement add contact
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ajouter un contact bientôt!')),
          );
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Ajouter'),
      ),
      body: contacts.isEmpty
          ? const Center(
              child: Text(
                'Aucun contact trouvé.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              itemCount: contacts.length,
              separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
              itemBuilder: (context, i) {
                final c = contacts[i];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        c['name']![0],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    title: Text(
                      c['name']!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      c['phone']!,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.call, color: Colors.green),
                      tooltip: 'Appeler',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Appeler ${c['name']} (${c['phone']})'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (context) => Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundColor: Colors.blue.shade100,
                                child: Text(
                                  c['name']![0],
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                c['name']!,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                c['phone']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.call),
                                label: const Text('Appeler'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size.fromHeight(40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Appeler ${c['name']} (${c['phone']})'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
