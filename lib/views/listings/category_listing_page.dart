// dart
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
    _paginatedListings = startIndex >= _allListings.length
        ? []
        : _allListings.sublist(startIndex, endIndex);
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
          break;
      }
      _updatePaginatedListings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: theme.scaffoldBackgroundColor,
          title: Text(
            widget.category,
            style:
                theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : theme.primaryColor,
                ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color:  isDark ? Colors.white : theme.primaryColor),
          actions: [
            PopupMenuButton<String>(
              icon: Icon(Icons.sort, color:  isDark ? Colors.white : theme.primaryColor),
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
          ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
          : _allListings.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_work_outlined, size: 70, color: theme.disabledColor),
            const SizedBox(height: 16),
            Text(
              'No properties found',
              style: theme.textTheme.titleMedium?.copyWith(color: theme.disabledColor),
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
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500, color: theme.hintColor),
                ),
                Text(
                  'Sort: $_sortBy',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500, color: theme.colorScheme.secondary),
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
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: theme.dividerColor.withOpacity(0.1),
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
                        backgroundColor: _currentPage > 1 ? theme.primaryColor : theme.disabledColor,
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
                        color: theme.cardColor,
                        border: Border.symmetric(
                          vertical: BorderSide(color: theme.dividerColor, width: 1),
                        ),
                      ),
                      child: Text(
                        '$_currentPage of $_totalPages',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.primaryColor),
                      ),
                    ),
                    // Next page button
                    ElevatedButton(
                      onPressed: _currentPage < _totalPages ? () => _changePage(_currentPage + 1) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentPage < _totalPages ? theme.primaryColor : theme.disabledColor,
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
                                  color: _currentPage == i ? theme.primaryColor : theme.disabledColor.withOpacity(0.2),
                                ),
                                child: Center(
                                  child: Text(
                                    i.toString(),
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: _currentPage == i ? Colors.white : theme.textTheme.bodyLarge?.color,
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