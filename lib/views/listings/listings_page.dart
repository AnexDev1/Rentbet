// dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/listing_model.dart';
import '../../services/listings_service.dart';
import 'details_page.dart';

class ListingsPage extends StatefulWidget {
  const ListingsPage({Key? key}) : super(key: key);

  @override
  _ListingsPageState createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  final List<String> _categories = [
    'All',
    'Realstate',
    'Apartment',
    'House',
    'Motel',
    'Condominium',
  ];
  int _selectedCategoryIndex = 0;

  Future<List<Listing>>? _listingsFuture;

  @override
  void initState() {
    super.initState();
    _listingsFuture = ListingsService().fetchListings();
  }

  List<Listing> _filterListings(List<Listing> listings) {
    if (_categories[_selectedCategoryIndex] == 'All') {
      return listings;
    }
    return listings.where((listing) {
      // Case insensitive comparison.
      return listing.category.toLowerCase() ==
          _categories[_selectedCategoryIndex].toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Listing>>(
          future: _listingsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No listings found.'));
            }
            final listings = snapshot.data!;
            final filteredListings = _filterListings(listings);
            final bestForYou = filteredListings.take(3).toList();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search bar with filter button.
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                            hintText: 'Search',
                            hintStyle: const TextStyle(color: Colors.black54),
                            prefixIcon:
                            const Icon(Icons.search_outlined, size: 30),
                            filled: true,
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Colors.black54),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Colors.black54),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Colors.black54),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: IconButton(
                          icon:
                          const Icon(Icons.filter_list_rounded, size: 30),
                          onPressed: () {
                            // Add filter action here.
                          },
                        ),
                      ),
                    ],
                  ),
                  // Horizontal scrollable category tabs.
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    height: 42,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        bool isSelected = _selectedCategoryIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategoryIndex = index;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.black87 : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black54),
                            ),
                            child: Center(
                              child: Text(
                                _categories[index],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // AnimatedSwitcher for filtered real estate items.
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) => SlideTransition(
                      position: Tween<Offset>(
                          begin: const Offset(3, 0), end: Offset.zero)
                          .animate(animation),
                      child: child,
                    ),
                    child: Container(
                      key: ValueKey<int>(_selectedCategoryIndex),
                      margin: const EdgeInsets.only(top: 16),
                      height: 250,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredListings.length,
                        separatorBuilder: (context, index) =>
                        const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final listing = filteredListings[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailsPage(property: {
                                        'imageUrl': listing.imageUrl,
                                        'price': '\$${listing.price.toString()}',
                                        'location': listing.location,
                                        'title': listing.title,
                                        'desc': listing.description,
                                        'category': listing.category,
                                        'type': listing.type,
                                      }),
                                ),
                              );
                            },
                            child: SizedBox(
                              width: 260,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    listing.imageUrl,
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '\$${listing.price.toString()}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      listing.location,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black54),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Best for you section.
                  if (filteredListings.isNotEmpty)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Best for you',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'see more',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // dart
// Inside the Best for you section in lib/views/listings/listings_page.dart, update the child Row as shown:
                            Column(
                              children: bestForYou.map((listing) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailsPage(property: {
                                          'imageUrl': listing.imageUrl,
                                          'price': '\$${listing.price.toString()}',
                                          'location': listing.location,
                                          'title': listing.title,
                                          'desc': listing.description,
                                          'category': listing.category,
                                          'type': listing.type,
                                        }),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Image.network(
                                          listing.imageUrl,
                                          height: 80,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Truncate long location names using ellipsis.
                                              Text(
                                                'Property at ${listing.location}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 16, fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Price: \$${listing.price.toString()}',
                                                style: const TextStyle(
                                                    fontSize: 14, color: Colors.black54),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}