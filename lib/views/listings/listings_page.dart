// dart
import 'package:flutter/material.dart';
import 'package:rentbet/views/listings/widgets/best_foryou_skeleton.dart';
import 'package:rentbet/views/listings/widgets/list_card_skeleton.dart';
import '../../models/listing_model.dart';
import '../../services/listings_service.dart';
import 'widgets/search_bar.dart';
import 'widgets/category_tabs.dart';
import 'widgets/listing_card.dart';
import 'widgets/best_foryou.dart';
import '../details/details_page.dart';

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
      return listing.category.toLowerCase() ==
          _categories[_selectedCategoryIndex].toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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
              // Data-dependent section: listing cards and Best For You.
              Expanded(
                child: FutureBuilder<List<Listing>>(
                  future: _listingsFuture,
                  builder: (context, snapshot) {
                    // Prepare the listing cards section and Best For You content based on snapshot state.
                    Widget listingCardsSection;
                    Widget bestForYouContent;

                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      listingCardsSection = Container(
                        margin: const EdgeInsets.only(top: 16),
                        height: 250,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          separatorBuilder: (context, index) =>
                          const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            return const ListingCardSkeleton();
                          },
                        ),
                      );
                      bestForYouContent =
                      const BestForYouSkeleton();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No listings found.'),
                      );
                    } else {
                      final listings = snapshot.data!;
                      final filteredListings =
                      _filterListings(listings);
                      final bestForYouList =
                      filteredListings.take(3).toList();
                      listingCardsSection = AnimatedSwitcher(
                        duration:
                        const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) =>
                            SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(3, 0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                        child: Container(
                          key: ValueKey<int>(
                              _selectedCategoryIndex),
                          margin:
                          const EdgeInsets.only(top: 16),
                          height: 250,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: filteredListings.length,
                            separatorBuilder: (context, index) =>
                            const SizedBox(width: 16),
                            itemBuilder: (context, index) {
                              final listing =
                              filteredListings[index];
                              return ListingCard(
                                listing: listing,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailsPage(
                                            property: {
                                              'imageUrl':
                                              listing.imageUrl,
                                              'price':
                                              '\$${listing.price}',
                                              'location':
                                              listing.location,
                                              'title': listing.title,
                                              'desc': listing
                                                  .description,
                                              'category':
                                              listing.category,
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
                      bestForYouContent =
                          BestForYou(listings: bestForYouList);
                    }

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          listingCardsSection,
                          const SizedBox(height: 16),
                          // Persist the header texts for Best For You
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
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
                                    color:
                                    Colors.grey[600]),
                              ),
                            ],
                          ),
                          bestForYouContent,
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}