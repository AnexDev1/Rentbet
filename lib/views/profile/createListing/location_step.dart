import 'package:flutter/material.dart';

class LocationStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController locationController;
  final Color primaryColor;
  final Color secondaryColor;

  const LocationStep({
    Key? key,
    required this.formKey,
    required this.locationController,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Property Location',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: primaryColor),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: locationController,
            decoration: InputDecoration(
              labelText: 'Address',
              prefixIcon: Icon(Icons.location_on),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Please enter address' : null,
          ),
          SizedBox(height: 16),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: secondaryColor.withOpacity(0.3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 48, color: secondaryColor),
                SizedBox(height: 12),
                Text(
                  'Map preview would show here',
                  style: TextStyle(color: secondaryColor, fontSize: 16),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'Ready to publish',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Your listing will be reviewed and published within 24 hours.',
                  style: TextStyle(color: secondaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}