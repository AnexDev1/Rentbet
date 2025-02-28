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
  List<Listing> _allListings = [];
  List<Listing> _paginatedListings = [];
  bool _isLoading = true;
  String _sortBy = 'Default';

  // Pagination variables
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  int _totalPages = 1;

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
      _allListings = filtered;
      _totalPages = (_allListings.length / _itemsPerPage).ceil();
      _updatePaginatedListings();
      _isLoading = false;
    });
  }

  void _updatePaginatedListings() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage > _allListings.length
        ? _allListings.length
        : startIndex + _itemsPerPage;

    if (startIndex >= _allListings.length) {
      _paginatedListings = [];
    } else {
      _paginatedListings = _allListings.sublist(startIndex, endIndex);
    }
  }

  void _changePage(int page) {
    setState(() {
      _currentPage = page;
      _updatePaginatedListings();
    });
  }

  void _sortListings(String criteria) {
    setState(() {
      _sortBy = criteria;
      switch (criteria) {
        case 'Price: Low to High':
          _allListings.sort((a, b) =>
              int.parse(a.price.replaceAll(RegExp(r'[^0-9]'), ''))
                  .compareTo(int.parse(b.price.replaceAll(RegExp(r'[^0-9]'), ''))));
          break;
        case 'Price: High to Low':
          _allListings.sort((a, b) =>
              int.parse(b.price.replaceAll(RegExp(r'[^0-9]'), ''))
                  .compareTo(int.parse(a.price.replaceAll(RegExp(r'[^0-9]'), ''))));
          break;
        default:
        // Default sorting
          break;
      }
      _updatePaginatedListings();
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
          : _allListings.isEmpty
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
                  '${_allListings.length} ${_allListings.length == 1 ? 'Property' : 'Properties'}',
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
              itemCount: _paginatedListings.length,
              itemBuilder: (context, index) {
                final listing = _paginatedListings[index];
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
                                'userId': listing.userId,
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
                                  'userId': listing.userId,
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
          // Pagination Controls
          // Pagination Controls
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Previous page button
                    ElevatedButton(
                      onPressed: _currentPage > 1 ? () => _changePage(_currentPage - 1) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentPage > 1 ? primaryColor : Colors.grey[300],
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back_ios, size: 14),
                          SizedBox(width: 4),
                          Text('Previous'),
                        ],
                      ),
                    ),

                    // Page indicator
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.symmetric(
                          vertical: BorderSide(color: Colors.grey[300]!, width: 1),
                        ),
                      ),
                      child: Text(
                        '$_currentPage of $_totalPages',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),

                    // Next page button
                    ElevatedButton(
                      onPressed: _currentPage < _totalPages ? () => _changePage(_currentPage + 1) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentPage < _totalPages ? primaryColor : Colors.grey[300],
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Next'),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios, size: 14),
                        ],
                      ),
                    ),
                  ],
                ),

                // Show quick page jumps if there are many pages
                if (_totalPages > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 1; i <= _totalPages; i++)
                            GestureDetector(
                              onTap: () => _changePage(i),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentPage == i ? primaryColor : Colors.grey[200],
                                ),
                                child: Center(
                                  child: Text(
                                    i.toString(),
                                    style: TextStyle(
                                      color: _currentPage == i ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
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
}