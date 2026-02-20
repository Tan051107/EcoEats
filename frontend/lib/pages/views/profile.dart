// lib/pages/profile.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService authService = AuthService();
  
  // User data variables
  String _userName = "";
  String _email = "";
  int _age = 0;
  String _gender = "";
  double _height = 0.0;
  double _weight = 0.0;
  String _dietGoal = "";
  String _dietType = "";
  List<String> _allergies = [];
  String _activityLevel = "";
  List<String> _healthGoals = [];
  
  // UI state
  bool _isLoading = true; 
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data from Firebase Auth and Firestore
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      final user = _auth.currentUser;
      
      if (user == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Get email from Auth
      setState(() {
        _email = user.email ?? '';
      });

      // Get detail from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        
        setState(() {
          _userName = data['name'] ?? 'No Name';
          _age = data['age'] ?? 0;
          _gender = data['gender'] ?? 'Not specified';
          _height = (data['height'] ?? 0).toDouble();
          _weight = (data['weight'] ?? 0).toDouble();
          _dietGoal = data['dietGoal'] ?? '';
          _dietType = data['dietType'] ?? '';
          _allergies = List<String>.from(data['allergies'] ?? []);
          _activityLevel = data['activityLevel'] ?? '';
          _healthGoals = List<String>.from(data['healthGoals'] ?? []);
        });
      } else {
        setState(() {
          _userName = "Please complete your profile";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error loading data: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //Helper methods to convert data to display text
  String _getDietGoalText() {
    switch (_dietGoal) {
      case 'weightLoss':
        return 'Weight Loss';
      case 'weightGain':
        return 'Weight Gain';
      case 'maintenance':
        return 'Weight Maintenance';
      default:
        return 'Healthy Diet';
    }
  }

  String _getDietTypeText() {
    switch (_dietType) {
      case 'vegan':
        return 'Vegan';
      case 'vegetarian':
        return 'Vegetarian';
      case 'nonVegan':
        return 'Non-Vegan';
      default:
        return 'Balanced Diet';
    }
  }

  String _getActivityLevelText() {
    switch (_activityLevel) {
      case 'sedentary':
        return 'Sedentary (little or no exercise)';
      case 'light':
        return 'Lightly active (1-3 days/week)';
      case 'moderate':
        return 'Moderately active (3-5 days/week)';
      case 'active':
        return 'Very active (6-7 days/week)';
      case 'veryActive':
        return 'Extremely active (physical job)';
      default:
        return 'Not specified';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUserData, 
          ),
        ],
      ),
      body: _buildBody(user),
    );
  }

  //Build different UI based on state
  Widget _buildBody(User? user) {
    if (user == null) {
      return _buildNotLoggedInView();
    }

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.green),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 50),
            const SizedBox(height: 16),
            Text(_errorMessage, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadUserData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return _buildProfileContent();
  }

  // View for non-logged in users
  Widget _buildNotLoggedInView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.account_circle,
            size: 100,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          const Text(
            'Please sign in first',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to sign in screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }

  // Main profile content
  Widget _buildProfileContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildBodyMetricsCard(),
          const SizedBox(height: 16),
          _buildDietGoalsCard(),
          const SizedBox(height: 16),
          _buildActivityAndGoalsCard(),
          const SizedBox(height: 16),
          _buildAllergiesCard(),
          const SizedBox(height: 16),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  // Profile header with avatar and basic info
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.green.shade100,
            child: Text(
              _userName.isNotEmpty ? _userName[0].toUpperCase() : '?',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _email,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 5),
                Text(
                  'Age: $_age · $_gender',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Body Measurement card
  Widget _buildBodyMetricsCard() {
    double bmi = _height > 0 ? _weight / ((_height/100) * (_height/100)) : 0;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Body Measurements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricItem(Icons.height, 'Height', '$_height cm'),
                _buildMetricItem(Icons.monitor_weight, 'Weight', '$_weight kg'),
                _buildMetricItem(
                  Icons.calculate,
                  'BMI',
                  bmi > 0 ? bmi.toStringAsFixed(1) : 'N/A',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper for metric items
  Widget _buildMetricItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.green),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Diet goals card
  Widget _buildDietGoalsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Diet Goals',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 15),
            _buildInfoRow(Icons.flag, 'Goal', _getDietGoalText()),
            const Divider(),
            _buildInfoRow(Icons.restaurant, 'Diet Type', _getDietTypeText()),
          ],
        ),
      ),
    );
  }

  // Activity and goals card
  Widget _buildActivityAndGoalsCard() {
    String healthGoalsText = _healthGoals.isEmpty 
        ? 'Not specified' 
        : _healthGoals.map((goal) {
            switch(goal) {
              case 'healthyDiet': return 'Healthy Diet';
              case 'loseWeight': return 'Weight Loss';
              default: return goal;
            }
          }).join(', ');
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Activity & Goals',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 15),
            _buildInfoRow(Icons.directions_run, 'Activity Level', _getActivityLevelText()),
            const Divider(),
            _buildInfoRow(Icons.emoji_events, 'Health Goals', healthGoalsText),
          ],
        ),
      ),
    );
  }

  //Allergies card
  Widget _buildAllergiesCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Allergies',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 15),
            _allergies.isEmpty
              ? const Text('No allergies')
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _allergies.map((allergy) {
                    return Chip(
                      label: Text(allergy),
                      backgroundColor: Colors.orange.shade100,
                    );
                  }).toList(),
                ),
          ],
        ),
      ),
    );
  }

  // Helper for info rows
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.green),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 16),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  // Logout button
  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton.icon(
        onPressed: () async {
          await authService.signOut();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logged out successfully')),
            );
            setState(() {});
          }
        },
        icon: const Icon(Icons.logout),
        label: const Text('Logout'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade50,
          foregroundColor: Colors.red,
          minimumSize: const Size(double.infinity, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}