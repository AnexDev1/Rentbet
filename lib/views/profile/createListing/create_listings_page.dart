// create_listings_page.dart
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../models/listing_model.dart';
import '../../../services/listings_service.dart';

import 'image_step.dart';
import 'details_step.dart';
import 'location_step.dart';

class CreateListingsPage extends StatefulWidget {
  const CreateListingsPage({super.key});

  @override
  _CreateListingsPageState createState() => _CreateListingsPageState();
}

class _CreateListingsPageState extends State<CreateListingsPage> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedCategory = 'Residential';
  String _selectedType = 'Apartment';
  int _currentStep = 0;
  bool _isLoading = false;
  List<File> _imageFiles = [];
  final ImagePicker _picker = ImagePicker();

  // Color scheme
  final Color _primaryColor = const Color(0xFF000000).withValues(alpha: 0.87);
  final Color _secondaryColor = const Color(0xFF000000).withValues(alpha: 0.54);
  final Color _accentColor = Colors.black87;
  final Color _backgroundColor = Colors.white;

  // Categories and types
  final List<String> _categories = ['Residential', 'Commercial', 'Industrial', 'Land'];
  final List<String> _types = ['Apartment', 'House', 'Villa', 'Office', 'Shop', 'Warehouse', 'Plot'];

  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _imageFiles.addAll(pickedFiles.map((file) => File(file.path)).toList());
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        _imageFiles.add(File(photo.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

  Future<void> _submitListing() async {
    if (!_formKey1.currentState!.validate() || !_formKey2.currentState!.validate() || !_formKey3.currentState!.validate()) return;
    if (_imageFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload at least one image'),
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
      // Here you would upload images and get URLs
      final imageUrl = "placeholder_for_actual_url"; // First image as primary

      final listing = Listing(
        title: _titleController.text,
        location: _locationController.text,
        price: _priceController.text,
        imageUrl: imageUrl,
        description: _descriptionController.text,
        category: _selectedCategory,
        type: _selectedType,
      );

      final newListingId = await ListingsService().createListing(listing);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Listing published successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
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
    setState(() {
      _imageFiles = [];
      _selectedCategory = 'Residential';
      _selectedType = 'Apartment';
      _currentStep = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text('Create Listing', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: _primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: _accentColor))
            : Stepper(
          type: StepperType.horizontal,
          currentStep: _currentStep,
          onStepTapped: (step) => setState(() => _currentStep = step),
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  if (_currentStep < 2)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: details.onStepContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accentColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text('NEXT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  if (_currentStep == 2)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submitListing,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accentColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text('PUBLISH', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  if (_currentStep > 0)
                    SizedBox(width: 12),
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: details.onStepCancel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _secondaryColor,
                          side: BorderSide(color: _secondaryColor),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text('BACK', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                ],
              ),
            );
          },
          onStepContinue: () {
            if (_currentStep < 2) {
              setState(() => _currentStep += 1);
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep -= 1);
            }
          },
          steps: [
            Step(
              stepStyle:_currentStep >= 0 ? StepStyle(color: Colors.black87) : null,

              title: Text('Images'),
              isActive: _currentStep >= 0,
              content: ImageStep(
                imageFiles: _imageFiles,
                pickImages: _pickImages,
                takePhoto: _takePhoto,
                removeImage: _removeImage,
                primaryColor: _primaryColor,
                secondaryColor: _secondaryColor,
                accentColor: _accentColor,
              ),
            ),
            Step(
              stepStyle:_currentStep >= 1 ? StepStyle(color: Colors.black87) : null,

              title: Text('Details'),
              isActive: _currentStep >= 1,
              content: DetailsStep(
                formKey: _formKey1,
                titleController: _titleController,
                priceController: _priceController,
                descriptionController: _descriptionController,
                selectedCategory: _selectedCategory,
                selectedType: _selectedType,
                categories: _categories,
                types: _types,
                primaryColor: _primaryColor,
              ),
            ),
            Step(
              stepStyle:_currentStep >= 2 ? StepStyle(color: Colors.black87) : null,

              title: Text('Location'),
              isActive: _currentStep >= 2,
              content: LocationStep(
                formKey: _formKey2,
                locationController: _locationController,
                primaryColor: _primaryColor,
                secondaryColor: _secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}