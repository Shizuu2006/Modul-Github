import 'package:flutter/material.dart';

void main() {
  runApp(const KosFinderApp());
}

class Kos {
  const Kos({
    required this.id,
    required this.name,
    required this.location,
    required this.pricePerMonth,
  });

  final int id;
  final String name;
  final String location;
  final int pricePerMonth;
}

class KosFinderApp extends StatelessWidget {
  const KosFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KosFinder Mini',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const KosListPage(),
    );
  }
}

class KosListPage extends StatefulWidget {
  const KosListPage({super.key});

  static const List<Kos> kosList = [
    Kos(
      id: 1,
      name: 'Kos Melati',
      location: 'Jl. Melati No. 12, Denpasar',
      pricePerMonth: 850000,
    ),
    Kos(
      id: 2,
      name: 'Kos Mawar',
      location: 'Jl. Mawar No. 8, Denpasar',
      pricePerMonth: 950000,
    ),
    Kos(
      id: 3,
      name: 'Kos Dahlia',
      location: 'Jl. Dahlia No. 21, Jimbaran',
      pricePerMonth: 1200000,
    ),
    Kos(
      id: 4,
      name: 'Kos Anggrek',
      location: 'Jl. Anggrek No. 5, Renon',
      pricePerMonth: 1100000,
    ),
    Kos(
      id: 5,
      name: 'Kos Bougenville',
      location: 'Jl. Bougenville No. 14, Sanur',
      pricePerMonth: 1350000,
    ),
    Kos(
      id: 6,
      name: 'Kos Kenanga',
      location: 'Jl. Kenanga No. 3, Sesetan',
      pricePerMonth: 800000,
    ),
  ];

  @override
  State<KosListPage> createState() => _KosListPageState();
}

class _KosListPageState extends State<KosListPage> {
  String _searchQuery = '';
  final Set<int> _favoriteIds = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchQuery.trim().toLowerCase();
    final filteredKos = KosListPage.kosList
        .where((kos) => kos.name.toLowerCase().contains(query))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('KosFinder Mini'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Cari nama kos',
                hintText: 'Contoh: Melati',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Hapus pencarian',
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                        icon: const Icon(Icons.clear),
                      ),
              ),
            ),
          ),
          Expanded(
            child: filteredKos.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 48),
                        SizedBox(height: 8),
                        Text('Kos tidak ditemukan'),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: filteredKos.length,
                    itemBuilder: (context, index) {
                      final kos = filteredKos[index];
                      final isFavorite = _favoriteIds.contains(kos.id);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      kos.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            kos.location,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Rp ${_formatPrice(kos.pricePerMonth)} / bulan',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                tooltip: isFavorite
                                    ? 'Hapus dari favorit'
                                    : 'Tambah ke favorit',
                                onPressed: () {
                                  setState(() {
                                    if (isFavorite) {
                                      _favoriteIds.remove(kos.id);
                                    } else {
                                      _favoriteIds.add(kos.id);
                                    }
                                  });
                                },
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    final digits = price.toString();
    final groups = <String>[];
    for (var index = digits.length; index > 0; index -= 3) {
      final start = index - 3 < 0 ? 0 : index - 3;
      groups.insert(0, digits.substring(start, index));
    }
    return groups.join('.');
  }
}
