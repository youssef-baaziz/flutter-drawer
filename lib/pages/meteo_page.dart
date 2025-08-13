import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/drawer_menu.dart';

class MeteoPage extends StatefulWidget {
  const MeteoPage({super.key});

  @override
  State<MeteoPage> createState() => _MeteoPageState();
}

class _MeteoPageState extends State<MeteoPage> {
  final Map<String, Map<String, double>> _cities = const {
    'Casablanca': {'lat': 33.5731, 'lon': -7.5898},
    'Rabat': {'lat': 34.0209, 'lon': -6.8416},
    'Marrakech': {'lat': 31.6295, 'lon': -7.9811},
    'Paris': {'lat': 48.8566, 'lon': 2.3522},
  };

  String _selected = 'Casablanca';
  bool _loading = false;
  String? _error;
  Map<String, dynamic>? _current;

  Future<void> _fetch() async {
    final lat = _cities[_selected]!['lat']!;
    final lon = _cities[_selected]!['lon']!;
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '$lat',
      'longitude': '$lon',
      'current_weather': 'true',
      'timezone': 'auto',
    });

    setState(() {
      _loading = true;
      _error = null;
      _current = null;
    });

    try {
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        setState(() => _current = json['current_weather'] as Map<String, dynamic>?);
      } else {
        setState(() => _error = 'Erreur ${res.statusCode}');
      }
    } catch (e) {
      setState(() => _error = 'Erreur réseau: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  String _codeToText(int code) {
    if ([0].contains(code)) return 'Ciel clair';
    if ([1, 2, 3].contains(code)) return 'Partiellement nuageux';
    if ([45, 48].contains(code)) return 'Brouillard';
    if ([51, 53, 55].contains(code)) return 'Bruine';
    if ([61, 63, 65].contains(code)) return 'Pluie';
    if ([71, 73, 75].contains(code)) return 'Neige';
    if ([80, 81, 82].contains(code)) return 'Averses';
    if ([95, 96, 99].contains(code)) return 'Orage';
    return 'Inconnu';
  }

  IconData _codeToIcon(int code) {
    if ([0].contains(code)) return Icons.wb_sunny_rounded;
    if ([1, 2, 3].contains(code)) return Icons.cloud_queue_rounded;
    if ([45, 48].contains(code)) return Icons.blur_on_rounded;
    if ([51, 53, 55].contains(code)) return Icons.grain_rounded;
    if ([61, 63, 65].contains(code)) return Icons.umbrella_rounded;
    if ([71, 73, 75].contains(code)) return Icons.ac_unit_rounded;
    if ([80, 81, 82].contains(code)) return Icons.grain_rounded;
    if ([95, 96, 99].contains(code)) return Icons.flash_on_rounded;
    return Icons.help_outline_rounded;
  }

  Color _codeToColor(int code, ThemeData theme) {
    if ([0].contains(code)) return Colors.amber.shade400;
    if ([1, 2, 3].contains(code)) return Colors.blueGrey.shade300;
    if ([45, 48].contains(code)) return Colors.grey.shade400;
    if ([51, 53, 55].contains(code)) return Colors.blue.shade200;
    if ([61, 63, 65].contains(code)) return Colors.blue.shade400;
    if ([71, 73, 75].contains(code)) return Colors.lightBlue.shade100;
    if ([80, 81, 82].contains(code)) return Colors.blue.shade700;
    if ([95, 96, 99].contains(code)) return Colors.deepPurple.shade400;
    return theme.colorScheme.primary;
  }

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      drawer: const AppDrawer(currentRoute: '/meteo'),
      appBar: AppBar(
        title: const Text('Météo'),
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualiser',
            onPressed: _loading ? null : _fetch,
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            elevation: 6,
            margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selected,
                          items: _cities.keys
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: _loading
                              ? null
                              : (v) {
                                  setState(() {
                                    _selected = v!;
                                  });
                                  _fetch();
                                },
                          decoration: const InputDecoration(
                            labelText: 'Ville',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Tooltip(
                        message: 'Actualiser',
                        child: IconButton.filled(
                          icon: const Icon(Icons.refresh_rounded),
                          onPressed: _loading ? null : _fetch,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _loading
                        ? const LinearProgressIndicator(
                            minHeight: 4,
                            key: ValueKey('loading'),
                          )
                        : const SizedBox(height: 4, key: ValueKey('notloading')),
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _error!,
                              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_current != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: _WeatherCard(
                        city: _selected,
                        current: _current!,
                        codeToText: _codeToText,
                        codeToIcon: _codeToIcon,
                        codeToColor: (code) => _codeToColor(code, theme),
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

class _WeatherCard extends StatelessWidget {
  final String city;
  final Map<String, dynamic> current;
  final String Function(int) codeToText;
  final IconData Function(int) codeToIcon;
  final Color Function(int) codeToColor;

  const _WeatherCard({
    required this.city,
    required this.current,
    required this.codeToText,
    required this.codeToIcon,
    required this.codeToColor,
  });

  @override
  Widget build(BuildContext context) {
    final code = (current['weathercode'] as num).toInt();
    final temp = (current['temperature'] as num).toStringAsFixed(1);
    final wind = (current['windspeed'] as num).toStringAsFixed(1);
    final time = current['time']?.toString();
    final color = codeToColor(code);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color.withOpacity(0.10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(16),
            child: Icon(
              codeToIcon(code),
              color: color,
              size: 48,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  city,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  codeToText(code),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: color.withOpacity(0.85),
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.thermostat, color: color, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '$temp°C',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.air, color: color, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '$wind km/h',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: color,
                          ),
                    ),
                  ],
                ),
                if (time != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Dernière mise à jour: ${_formatTime(time)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatTime(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }
}
