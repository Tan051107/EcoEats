// lib/pages/views/edit_profile.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  final String userName;
  final int age;
  final String gender;
  final double height;
  final double weight;
  final String dietGoal;
  final String dietType;
  final List<String> allergies;
  final String activityLevel;
  final List<String> healthGoals;

  const EditProfilePage({
    super.key,
    required this.userName,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.dietGoal,
    required this.dietType,
    required this.allergies,
    required this.activityLevel,
    required this.healthGoals,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _allergiesController;
  late TextEditingController _healthGoalsController;

  late String _selectedGender;
  late String _selectedDietGoal;
  late String _selectedDietType;
  late String _selectedActivityLevel;

  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _ageController = TextEditingController(text: widget.age.toString());
    _heightController = TextEditingController(text: widget.height.toString());
    _weightController = TextEditingController(text: widget.weight.toString());
    _allergiesController = TextEditingController(text: widget.allergies.join(', '));
    _healthGoalsController = TextEditingController(text: widget.healthGoals.join(', '));

    _selectedGender = widget.gender;
    _selectedDietGoal = widget.dietGoal;
    _selectedDietType = widget.dietType;
    _selectedActivityLevel = widget.activityLevel;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _allergiesController.dispose();
    _healthGoalsController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final user = _auth.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = 'User not logged in.';
          _isLoading = false;
        });
        return;
      }

      String name = _nameController.text.trim();
      int? age = int.tryParse(_ageController.text.trim());
      double? height = double.tryParse(_heightController.text.trim());
      double? weight = double.tryParse(_weightController.text.trim());

      if (name.isEmpty || age == null || height == null || weight == null) {
        setState(() {
          _errorMessage = 'Please fill all fields correctly.';
          _isLoading = false;
        });
        return;
      }

      List<String> allergies = _allergiesController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      List<String> healthGoals = _healthGoalsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'age': age,
        'gender': _selectedGender,
        'height': height,
        'weight': weight,
        'dietGoal': _selectedDietGoal,
        'dietType': _selectedDietType,
        'allergies': allergies,
        'activityLevel': _selectedActivityLevel,
        'healthGoals': healthGoals,
      }, SetOptions(merge: true));

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to save: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Name
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Age
                  TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Gender Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedGender.isEmpty ? null : _selectedGender,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                      DropdownMenuItem(value: 'Female', child: Text('Female')),
                      DropdownMenuItem(value: 'Other', child: Text('Other')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Height
                  TextField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Height (cm)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Weight
                  TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Weight (kg)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Diet Goal Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedDietGoal.isEmpty ? null : _selectedDietGoal,
                    decoration: const InputDecoration(
                      labelText: 'Diet Goal',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'weightLoss', child: Text('Weight Loss')),
                      DropdownMenuItem(value: 'weightGain', child: Text('Weight Gain')),
                      DropdownMenuItem(value: 'maintenance', child: Text('Weight Maintenance')),
                      DropdownMenuItem(value: 'healthy', child: Text('Healthy Diet')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedDietGoal = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Diet Type Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedDietType.isEmpty ? null : _selectedDietType,
                    decoration: const InputDecoration(
                      labelText: 'Diet Type',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'balanced', child: Text('Balanced')),
                      DropdownMenuItem(value: 'vegan', child: Text('Vegan')),
                      DropdownMenuItem(value: 'vegetarian', child: Text('Vegetarian')),
                      DropdownMenuItem(value: 'nonVegan', child: Text('Non-Vegan')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedDietType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Activity Level Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedActivityLevel.isEmpty ? null : _selectedActivityLevel,
                    decoration: const InputDecoration(
                      labelText: 'Activity Level',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'sedentary', child: Text('Sedentary')),
                      DropdownMenuItem(value: 'light', child: Text('Lightly active')),
                      DropdownMenuItem(value: 'moderate', child: Text('Moderately active')),
                      DropdownMenuItem(value: 'active', child: Text('Very active')),
                      DropdownMenuItem(value: 'veryActive', child: Text('Extremely active')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedActivityLevel = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Allergies
                  TextField(
                    controller: _allergiesController,
                    decoration: const InputDecoration(
                      labelText: 'Allergies (comma separated)',
                      border: OutlineInputBorder(),
                      hintText: 'e.g. Seafood, Peanuts',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Health Goals
                  TextField(
                    controller: _healthGoalsController,
                    decoration: const InputDecoration(
                      labelText: 'Health Goals (comma separated)',
                      border: OutlineInputBorder(),
                      hintText: 'e.g. healthyDiet, loseWeight',
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (_errorMessage.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.red.shade50,
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}