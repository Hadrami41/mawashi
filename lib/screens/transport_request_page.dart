import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/transport_provider.dart';

class TransportRequestPage extends StatefulWidget {
  const TransportRequestPage({super.key});

  @override
  State<TransportRequestPage> createState() => _TransportRequestPageState();
}

class _TransportRequestPageState extends State<TransportRequestPage> {
  int _selectedAnimal = 1; // Default to Mouton
  int _quantity = 12;
  String _selectedDate = "Aujourd'hui, 24 Mai";
  String _selectedTime = "14:30";
  bool _isSubmitting = false;

  final List<AnimalType> _animals = [
    AnimalType(name: 'Vache', icon: Icons.agriculture, emoji: '🐄'),
    AnimalType(name: 'Mouton', icon: Icons.pets, emoji: '🐑'),
    AnimalType(name: 'Chameau', icon: Icons.emoji_nature, emoji: '🐪'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Demande de Transport',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Indicator
            _buildProgressIndicator(),
            const SizedBox(height: 24),
            // Step 1: Animal Type
            _buildSection(
              number: '1',
              title: 'Quel animal ?',
              child: _buildAnimalSelector(),
            ),
            const SizedBox(height: 32),
            // Step 2: Quantity
            _buildSection(
              number: '2',
              title: 'Combien ?',
              child: _buildQuantitySelector(),
            ),
            const SizedBox(height: 32),
            // Step 3: When
            _buildSection(
              number: '3',
              title: 'Quand ?',
              child: _buildDateTimeSelector(),
            ),
            const SizedBox(height: 24),
            // Map Preview
            _buildMapPreview(),
            const SizedBox(height: 24),
            // Submit Button
            _buildSubmitButton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFF4ADE80),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 10,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 10,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String number,
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number. $title',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildAnimalSelector() {
    return Row(
      children: List.generate(
        _animals.length,
        (index) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index < _animals.length - 1 ? 12 : 0,
            ),
            child: _buildAnimalCard(_animals[index], index),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimalCard(AnimalType animal, int index) {
    final isSelected = _selectedAnimal == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedAnimal = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF4ADE80) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4ADE80).withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF4ADE80).withValues(alpha: 0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  animal.icon,
                  size: 28,
                  color: isSelected
                      ? const Color(0xFF4ADE80)
                      : Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              animal.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.black87 : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Minus Button
          GestureDetector(
            onTap: () {
              if (_quantity > 1) {
                setState(() => _quantity--);
              }
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(Icons.remove, color: Colors.grey[600], size: 24),
            ),
          ),
          // Quantity Display
          Column(
            children: [
              Text(
                '$_quantity',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4ADE80),
                ),
              ),
              Text(
                'TÊTES',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[500],
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          // Plus Button
          GestureDetector(
            onTap: () => setState(() => _quantity++),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF4ADE80),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeSelector() {
    return Column(
      children: [
        // Date
        _buildDateTimeField(
          icon: Icons.calendar_today_outlined,
          iconColor: const Color(0xFF4ADE80),
          label: 'Date de ramassage',
          value: _selectedDate,
          onTap: () {
            // Open date picker
          },
        ),
        const SizedBox(height: 12),
        // Time
        _buildDateTimeField(
          icon: Icons.access_time,
          iconColor: const Color(0xFF4ADE80),
          label: 'Heure souhaitée',
          value: _selectedTime,
          onTap: () {
            // Open time picker
          },
        ),
      ],
    );
  }

  Widget _buildDateTimeField({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildMapPreview() {
    return Container(
      height: 140,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFFEF3C7).withValues(alpha: 0.7),
            const Color(0xFFD4EAD7).withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Car illustration placeholder
          Positioned(
            right: 20,
            bottom: 20,
            child: Container(
              width: 160,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF0F766E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(
                  Icons.local_shipping,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),
          // Location badge
          Positioned(
            left: 20,
            top: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, color: Color(0xFF4ADE80), size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Lieu de ramassage par défaut',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4ADE80),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isSubmitting
              ? const CircularProgressIndicator(color: Colors.white)
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Valider ma demande',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text('تأكيد الطلب', style: TextStyle(fontSize: 12)),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    setState(() => _isSubmitting = true);

    final authProvider = context.read<AuthProvider>();
    final transportProvider = context.read<TransportProvider>();

    try {
      final success = await transportProvider.createRequest(
        departure: 'Ferme par défaut',
        destination: 'Marché Central',
        date: DateTime.now().add(const Duration(days: 1)),
        livestockCount: _quantity,
        livestockType: _animals[_selectedAnimal].name,
        userId: authProvider.currentUser?.id,
      );

      if (mounted && success != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Demande envoyée avec succès !')),
        );
        Navigator.pushReplacementNamed(context, '/home');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}

class AnimalType {
  final String name;
  final IconData icon;
  final String emoji;

  AnimalType({required this.name, required this.icon, required this.emoji});
}
