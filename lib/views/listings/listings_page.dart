// dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/listing_model.dart';
import '../../services/listings_service.dart';
import '../../providers/listings_provider.dart';
import '../details/details_page.dart';
import '../listings/widgets/best_foryou.dart';
import '../listings/widgets/best_foryou_skeleton.dart';
import '../listings/widgets/category_tabs.dart';
import '../listings/widgets/list_card_skeleton.dart';
import '../listings/widgets/listing_card.dart';
import '../listings/widgets/search_bar.dart';

class ListingsPage extends StatefulWidget {
  const ListingsPage({Key? key}) : super(key: key);

  @override
  _ListingsPageState createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage>
    with AutomaticKeepAliveClientMixin {
  final List<String> _categories = [
    r'All',
    r'Realstate',
    r'Apartment',
    r'House',
    r'Motel',
    r'Condominium',
  ];
  int _selectedCategoryIndex = 0;
  late RealtimeChannel _subscription;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Load initial listings with default filter.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ListingsProvider>(context, listen: false)
          .fetchListingsByType('default');
    });
    _subscribeToListings();
  }

  void _subscribeToListings() {
    _subscription = Supabase.instance.client
        .channel('public:listings')
        .onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'listings',
      callback: (payload) {
        final newListing = Listing.fromJson(payload.newRecord);
        // Refetch listings when new record comes in.
        Provider.of<ListingsProvider>(context, listen: false)
            .fetchListingsByType(
            Provider.of<ListingsProvider>(context, listen: false)
                .currentFilter);
      },
    )
        .onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'listings',
      callback: (payload) {
        // Update listings when record is updated.
        Provider.of<ListingsProvider>(context, listen: false)
            .fetchListingsByType(
            Provider.of<ListingsProvider>(context, listen: false)
                .currentFilter);
      },
    )
        .onPostgresChanges(
      event: PostgresChangeEvent.delete,
      schema: 'public',
      table: 'listings',
      callback: (payload) {
        // Update listings when record is deleted.
        Provider.of<ListingsProvider>(context, listen: false)
            .fetchListingsByType(
            Provider.of<ListingsProvider>(context, listen: false)
                .currentFilter);
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

  List<Listing> _filterListings(List<Listing> listings) {
    if (_categories[_selectedCategoryIndex].toLowerCase() == r'all') {
      return listings;
    }
    return listings.where((listing) {
      return listing.category.toLowerCase() ==
          _categories[_selectedCategoryIndex].toLowerCase();
    }).toList();
  }

  @override
  void dispose() {
    Supabase.instance.client.removeChannel(_subscription);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = Provider.of<ListingsProvider>(context);
    final filteredListings = _filterListings(provider.listings);
    final bestForYouList = filteredListings.take(3).toList();

    Widget listingCardsSection;
    Widget bestForYouContent;

    if (provider.isLoading) {
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
                          r'imageUrl': listing.imageUrl,
                          r'price': '\$${listing.price}',
                          r'location': listing.location,
                          r'title': listing.title,
                          r'desc': listing.description,
                          r'category': listing.category,
                          r'type': listing.type,
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
                onFilter: (filter) {
                  Provider.of<ListingsProvider>(context, listen: false)
                      .fetchListingsByType(filter);
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