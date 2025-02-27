import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rentbet/views/listings/widgets/search_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/listing_model.dart';
import '../../services/listings_service.dart';
import '../details/details_page.dart';
import '../listings/widgets/best_foryou.dart';
import '../listings/widgets/best_foryou_skeleton.dart';
import '../listings/widgets/category_tabs.dart';
import '../listings/widgets/list_card_skeleton.dart';
import '../listings/widgets/listing_card.dart';
import 'category_listing_page.dart';

class ListingsPage extends StatefulWidget {
  const ListingsPage({Key? key}) : super(key: key);

  @override
  _ListingsPageState createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage>
    with AutomaticKeepAliveClientMixin {
  final List<String> _categories = [
    'All',
    'Realstate',
    'Apartment',
    'House',
    'Motel',
    'Condominium',
  ];
  int _selectedCategoryIndex = 0;
  List<Listing> _listings = [];
  bool _isLoading = true;
  late RealtimeChannel _subscription; // Updated to RealtimeChannel

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _subscribeToListings();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    final listings = await ListingsService().fetchListings();
    setState(() {
      _listings = listings;
      _isLoading = false;
    });
  }

  void _subscribeToListings() {
    // Subscribe to all changes on the "listings" table
    _subscription = Supabase.instance.client
        .channel('public:listings') // Unique channel name
        .onPostgresChanges(
      event: PostgresChangeEvent.insert, // INSERT events
      schema: 'public',
      table: 'listings',
      callback: (payload) {
        final newListing = Listing.fromJson(payload.newRecord);
        setState(() {
          _listings.add(newListing);
        });
      },
    )
        .onPostgresChanges(
      event: PostgresChangeEvent.update, // UPDATE events
      schema: 'public',
      table: 'listings',
      callback: (payload) {
        final updatedListing = Listing.fromJson(payload.newRecord);
        setState(() {
          final index = _listings.indexWhere((l) => l.id == updatedListing.id);
          if (index != -1) {
            _listings[index] = updatedListing;
          }
        });
      },
    )
        .onPostgresChanges(
      event: PostgresChangeEvent.delete, // DELETE events
      schema: 'public',
      table: 'listings',
      callback: (payload) {
        final deletedId = payload.oldRecord['id'];
        setState(() {
          _listings.removeWhere((l) => l.id == deletedId);
        });
      },
    )
        .subscribe((status, [error]) {
      if (status == RealtimeSubscribeStatus.subscribed) {
        print('Subscribed to listings table');
      } else if (status == RealtimeSubscribeStatus.closed) {
        print('Subscription closed');
      } else if (error != null) {
        print('Subscription error: $error');
      }
    });
  }

  @override
  void dispose() {
    Supabase.instance.client.removeChannel(_subscription); // Updated method
    super.dispose();
  }

  List<Listing> _filterListings(List<Listing> listings) {
    if (_categories[_selectedCategoryIndex] == 'All') {
      return listings;
    }
    return listings.where((listing) {
      return listing.category.toLowerCase() ==
          _categories[_selectedCategoryIndex].toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final filteredListings = _filterListings(_listings);
    final bestForYouList = filteredListings.take(3).toList();

    Widget listingCardsSection;
    Widget bestForYouContent;

    if (_isLoading) {
      listingCardsSection = Container(
        margin: const EdgeInsets.only(top: 16),
        height: 250,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          separatorBuilder: (context, index) => const SizedBox(width: 16),
          itemBuilder: (context, index) => const ListingCardSkeleton(),
        ),
      );
      bestForYouContent = const BestForYouSkeleton();
    } else {
      listingCardsSection = AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(3, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
        child: Container(
          key: ValueKey<int>(_selectedCategoryIndex),
          margin: const EdgeInsets.only(top: 16),
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: filteredListings.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final listing = filteredListings[index];
              return ListingCard(
                listing: listing,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(
                        property: {
                          'imageUrl': listing.imageUrl,
                          'price': '\$${listing.price}',
                          'location': listing.location,
                          'title': listing.title,
                          'desc': listing.description,
                          'category': listing.category,
                          'type': listing.type,
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      );
      bestForYouContent = BestForYou(listings: bestForYouList);
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SearchBarWidget(
                onFilter: () {
                  // Add filter action here.
                },
              ),
              CategoryTabs(
                categories: _categories,
                selectedIndex: _selectedCategoryIndex,
                onTabSelected: (index) {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      listingCardsSection,
                      const SizedBox(height: 16),
                      // dart
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Best for you',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoryListingsPage(
                                    category: _categories[_selectedCategoryIndex],
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'See more',
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                      bestForYouContent,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}