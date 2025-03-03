// dart
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/listing_model.dart';
import '../../../services/listings_service.dart';
import 'image_step.dart';
import 'details_step.dart';
import 'location_step.dart';
import 'package:latlong2/latlong.dart';

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

  String _selectedCategory = 'apartment';
  String _selectedType = 'rent';
  int _currentStep = 0;
  bool _isLoading = false;
  List<File> _imageFiles = [];
  final ImagePicker _picker = ImagePicker();
  // Default coordinates to match LocationStep
  double _latitude = 37.42796133580664;
  double _longitude = -122.085749655962;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'apartment',
    'motel',
    'realstate',
    'house',
    'condominium'
  ];
  final List<String> _types = ['rent', 'sell'];

  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _imageFiles
            .addAll(pickedFiles.map((file) => File(file.path)).toList());
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

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final fileId = const Uuid().v4();
      final fileExt = imageFile.path.split('.').last;
      final filePath = 'property-images/$fileId.$fileExt';
      await Supabase.instance.client.storage
          .from('rentbetStorage')
          .upload(filePath, imageFile);
      final publicUrl =
      Supabase.instance.client.storage.from('rentbetStorage').getPublicUrl(filePath);
      return publicUrl;
    } catch (e) {
      debugPrint('Image upload error: $e');
      return null;
    }
  }

  Future<void> _submitListing() async {
    if (!_formKey1.currentState!.validate() || !_formKey2.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

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
      _isSubmitting = true;
    });

    try {
      final imageUrl = await _uploadImage(_imageFiles.first);
      if (imageUrl == null) {
        throw Exception('Failed to upload image');
      }

      // Get current user ID from Supabase
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final listing = Listing(
        userId: userId, // Add the user ID here
        title: _titleController.text,
        location: _locationController.text,
        price: _priceController.text,
        imageUrl: imageUrl,
        description: _descriptionController.text,
        category: _selectedCategory,
        type: _selectedType,
        latitude: _latitude,
        longitude: _longitude,
      );

      await ListingsService().createListing(listing);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Listing published successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _clearForm() {
    _titleController.clear();
    _locationController.clear();
    _priceController.clear();
    _descriptionController.clear();
    setState(() {
      _imageFiles = [];
      _selectedCategory = 'apartment';
      _selectedType = 'rent';
      _currentStep = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Create Listing',
            style: theme.appBarTheme.titleTextStyle ??
                theme.textTheme.titleLarge?.copyWith(color: Colors.white)),
        centerTitle: true,
        backgroundColor:
        theme.appBarTheme.backgroundColor ?? theme.primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(
          child: CircularProgressIndicator(
              color: theme.colorScheme.secondary),
        )
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
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('NEXT'),
                      ),
                    ),
                  if (_currentStep == 2)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submitListing,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('PUBLISH'),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: details.onStepCancel,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('BACK'),
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
              title: Text('Images', style: theme.textTheme.bodyLarge),
              isActive: _currentStep >= 0,
              state: _currentStep == 0
                  ? StepState.editing
                  : StepState.indexed,
              content: ImageStep(
                imageFiles: _imageFiles,
                pickImages: _pickImages,
                takePhoto: _takePhoto,
                removeImage: _removeImage,
                primaryColor: theme.primaryColor,
                secondaryColor: theme.hintColor,
                accentColor: theme.colorScheme.secondary,
              ),
            ),
            Step(
              title: Text('Details', style: theme.textTheme.bodyLarge),
              isActive: _currentStep >= 1,
              state: _currentStep == 1
                  ? StepState.editing
                  : StepState.indexed,
              content: DetailsStep(
                formKey: _formKey1,
                titleController: _titleController,
                priceController: _priceController,
                descriptionController: _descriptionController,
                selectedCategory: _selectedCategory,
                selectedType: _selectedType,
                categories: _categories,
                types: _types,
              ),
            ),
            Step(
              title: Text('Location', style: theme.textTheme.bodyLarge),
              isActive: _currentStep >= 2,
              state: _currentStep == 2
                  ? StepState.editing
                  : StepState.indexed,
              content: LocationStep(
                formKey: _formKey2,
                locationController: _locationController,
                primaryColor: theme.primaryColor,
                secondaryColor: theme.hintColor,
                onLocationSelected: (LatLng point) {
                  _latitude = point.latitude;
                  _longitude = point.longitude;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}