import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../models/listing_model.dart';
import '../../services/listings_service.dart';

class CreateListingsPage extends StatefulWidget {
  const CreateListingsPage({super.key});

  @override
  _CreateListingsPageState createState() => _CreateListingsPageState();
}

class _CreateListingsPageState extends State<CreateListingsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  bool _isLoading = false;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // Color scheme
  final Color _primaryColor = const Color(0xFF000000).withValues(alpha: 0.87); // black87
  final Color _secondaryColor = const Color(0xFF000000).withValues(alpha: 0.54); // back54
  final Color _backgroundColor = Colors.white;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitListing() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload an image'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Here you would normally upload the image and get URL
      // For this example, we'll assume the service handles the image upload
      final imageUrl = "placeholder_for_actual_url";

      final listing = Listing(
        title: _titleController.text,
        location: _locationController.text,
        price: _priceController.text,
        imageUrl: imageUrl,
        description: _descriptionController.text,
        category: _categoryController.text,
        type: _typeController.text,
      );

      final newListingId = await ListingsService().createListing(listing);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Property listing created with id: $newListingId'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _formKey.currentState!.reset();
      _clearForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearForm() {
    _titleController.clear();
    _locationController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _categoryController.clear();
    _typeController.clear();
    setState(() {
      _imageFile = null;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
    IconData? prefixIcon,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(color: _primaryColor),
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          labelStyle: TextStyle(color: _secondaryColor),
          hintStyle: TextStyle(color: _secondaryColor.withValues(alpha: 0.7)),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: _secondaryColor) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: _secondaryColor.withValues(alpha: 0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: _secondaryColor.withValues(alpha: 0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: _primaryColor, width: 1.5),
          ),
          filled: true,
          fillColor: _backgroundColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: (value) =>
        value == null || value.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('Create Property Listing'),
        centerTitle: true,
        backgroundColor: _primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0, left: 8.0),
                  child: Text(
                    'Add Your Property Details',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    ),
                  ),
                ),

                // Main Card
                Card(
                  elevation: 4,
                  shadowColor: _secondaryColor.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image Upload Section
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              'Property Images',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: _primaryColor,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: _pickImage,
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: _secondaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _secondaryColor.withValues(alpha: 0.3),
                                ),
                              ),
                              child: _imageFile != null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _imageFile!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              )
                                  : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo,
                                    size: 48,
                                    color: _secondaryColor,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Tap to upload property image',
                                    style: TextStyle(
                                      color: _secondaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Basic Info Section
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              'Basic Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: _primaryColor,
                              ),
                            ),
                          ),
                          _buildTextField(
                            controller: _titleController,
                            label: 'Property Title',
                            hintText: 'e.g., Modern 3BHK Apartment',
                            prefixIcon: Icons.home,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: _priceController,
                                  label: 'Price',
                                  hintText: 'e.g., 2,500,000',
                                  keyboardType: TextInputType.number,
                                  prefixIcon: Icons.attach_money,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  controller: _typeController,
                                  label: 'Property Type',
                                  hintText: 'e.g., Apartment, Villa',
                                  prefixIcon: Icons.house,
                                ),
                              ),
                            ],
                          ),

                          // Location & Details Section
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
                            child: Text(
                              'Location & Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: _primaryColor,
                              ),
                            ),
                          ),
                          _buildTextField(
                            controller: _locationController,
                            label: 'Location',
                            hintText: 'e.g., Downtown, Riverside',
                            prefixIcon: Icons.location_on,
                          ),
                          _buildTextField(
                            controller: _categoryController,
                            label: 'Category',
                            hintText: 'e.g., Residential, Commercial',
                            prefixIcon: Icons.category,
                          ),
                          _buildTextField(
                            controller: _descriptionController,
                            label: 'Description',
                            hintText: 'Describe the property, features, amenities...',
                            maxLines: 5,
                            prefixIcon: Icons.description,
                          ),

                          const SizedBox(height: 32),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: _isLoading
                                ? Center(
                              child: CircularProgressIndicator(
                                color: _primaryColor,
                              ),
                            )
                                : ElevatedButton(
                              onPressed: _submitListing,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'PUBLISH LISTING',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}