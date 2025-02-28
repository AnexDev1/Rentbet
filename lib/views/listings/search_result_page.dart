import 'package:flutter/material.dart';
import 'package:rentbet/views/home/home_page.dart';
import 'package:rentbet/views/listings/listings_page.dart';
import 'package:rentbet/views/listings/widgets/listing_card.dart';
import '../../models/listing_model.dart';
import '../../services/listings_service.dart';
import '../details/details_page.dart';

class SearchResultsPage extends StatefulWidget {
  final String searchQuery;
  const SearchResultsPage({super.key, required this.searchQuery});

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  List<Listing> _listings = [];
  bool _isLoading = true;
  late TextEditingController _controller;
  String _sortBy = 'Default';

  // App theme colors
  final Color primaryColor = const Color(0xFF1C4980);
  final Color accentColor = const Color(0xFFFF9500);
  final Color backgroundColor = const Color(0xFFF2F2F7);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchQuery);
    _fetchSearchResults();
  }

  Future<void> _fetchSearchResults() async {
    setState(() => _isLoading = true);
    final listings = await ListingsService().fetchListings();
    final filtered = listings.where((listing) {
      return listing.title
          .toLowerCase()
          .contains(widget.searchQuery.toLowerCase());
    }).toList();
    setState(() {
      _listings = filtered;
      _isLoading = false;
    });
  }

  void _sortListings(String criteria) {
    setState(() {
      _sortBy = criteria;
      switch (criteria) {
        case 'Price: Low to High':
          _listings.sort((a, b) =>
              int.parse(a.price.replaceAll(RegExp(r'[^0-9]'), ''))
                  .compareTo(int.parse(b.price.replaceAll(RegExp(r'[^0-9]'), ''))));
          break;
        case 'Price: High to Low':
          _listings.sort((a, b) =>
              int.parse(b.price.replaceAll(RegExp(r'[^0-9]'), ''))
                  .compareTo(int.parse(a.price.replaceAll(RegExp(r'[^0-9]'), ''))));
          break;
        default:
        // Default sorting - maintain original order
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _controller,
            style: TextStyle(color: primaryColor),
            decoration: InputDecoration(
              hintText: 'Search properties',
              hintStyle: TextStyle(color: Colors.grey[500]),
              prefixIcon: Icon(Icons.search, color: primaryColor),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, size: 20),
                color: Colors.grey[600],
                onPressed: () {
                  _controller.clear();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchResultsPage(searchQuery: value),
                  ),
                );
              }
            },
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.sort, color: primaryColor),
            onSelected: _sortListings,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Default',
                child: Text('Default'),
              ),
              const PopupMenuItem<String>(
                value: 'Price: Low to High',
                child: Text('Price: Low to High'),
              ),
              const PopupMenuItem<String>(
                value: 'Price: High to Low',
                child: Text('Price: High to Low'),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : _listings.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 70,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No results found for "${widget.searchQuery}"',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try different keywords or categories',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Back to Browse'),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_listings.length} ${_listings.length == 1 ? 'Result' : 'Results'} for "${widget.searchQuery}"',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  'Sort: $_sortBy',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 20.0,
                childAspectRatio: 0.65,
              ),
              itemCount: _listings.length,
              itemBuilder: (context, index) {
                final listing = _listings[index];
                return Hero(
                  tag: 'search_listing_${listing.id}',
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsPage(
                              property: {
                                'id': listing.id,
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
                      child: ListingCard(
                        listing: listing,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsPage(
                                property: {
                                  'id': listing.id,
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
                      ),
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
}