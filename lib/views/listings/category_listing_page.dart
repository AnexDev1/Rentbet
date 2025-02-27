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
  List<Listing> _listings = [];
  bool _isLoading = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _listings.isEmpty
          ? const Center(child: Text('No listings found.'))
          : Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 18.0,
                childAspectRatio: 0.63,
              ),
              itemCount: _listings.length,
              itemBuilder: (context, index) {
                final listing = _listings[index];
                return GestureDetector(
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
                  child: ListingCard(
                    listing: listing,
                    onTap: () {
                      //navigate to details page with all the details needed
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