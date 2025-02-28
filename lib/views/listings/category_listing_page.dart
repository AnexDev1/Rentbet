import 'package:flutter/material.dart';
import '../../models/listing_model.dart';
import '../../services/listings_service.dart';
import '../details/details_page.dart';
import 'widgets/listing_card.dart';

class CategoryListingsPage extends StatefulWidget {
  final String category;
  const CategoryListingsPage({Key? key, required this.category})
      : super(key: key);

  @override
  _CategoryListingsPageState createState() => _CategoryListingsPageState();
}

class _CategoryListingsPageState extends State<CategoryListingsPage> {
  List<Listing> _listings = [];
  bool _isLoading = true;
  String _sortBy = 'Default';

  // App theme colors
  final Color primaryColor = const Color(0xFF1C4980);
  final Color accentColor = const Color(0xFFFF9500);
  final Color backgroundColor = const Color(0xFFF2F2F7);

  @override
  void initState() {
    super.initState();
    _fetchCategoryListings();
  }

  Future<void> _fetchCategoryListings() async {
    setState(() => _isLoading = true);
    final listings = await ListingsService().fetchListings();
    final filtered = widget.category.toLowerCase() == 'all'
        ? listings
        : listings.where((listing) =>
    listing.category.toLowerCase() == widget.category.toLowerCase())
        .toList();

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
        // Default sorting
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
        title: Text(
          widget.category,
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: primaryColor),
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
            Icon(Icons.home_work_outlined, size: 70, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No properties found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
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
                  '${_listings.length} ${_listings.length == 1 ? 'Property' : 'Properties'}',
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  tag: 'listing_${listing.id}',
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