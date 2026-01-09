import 'package:flutter/material.dart';

class MyTruckPage extends StatefulWidget {
  const MyTruckPage({super.key});

  @override
  State<MyTruckPage> createState() => _MyTruckPageState();
}

class _MyTruckPageState extends State<MyTruckPage> {
  int _currentIndex = 2;

  final List<Equipment> _equipments = [
    Equipment(name: 'Ventilation forcée', isActive: true),
    Equipment(name: 'Abreuvoir intégré', isActive: true),
    Equipment(name: 'Suivi GPS Temps Réel', isActive: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Truck Image
            _buildHeader(),
            // Content
            _buildContent(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF4ADE80).withValues(alpha: 0.3),
            const Color(0xFF4ADE80).withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background trees/forest
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1448375240586-882707db888b?w=400',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient overlay
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Mon Camion  شاحنتي',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.settings,
                      color: Color(0xFF4ADE80),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Truck info overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Camion 10 Tonnes',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'VOLVO FH16 - Plateforme XL',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4ADE80),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'ACTIF',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Truck illustration
          Positioned(
            bottom: 60,
            right: 20,
            child: Container(
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF0EA5E9),
                borderRadius: BorderRadius.circular(12),
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
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vehicle Details
          _buildSectionHeader('Détails du véhicule', 'تفاصيل المركبة'),
          const SizedBox(height: 16),
          _buildDetailRow(Icons.local_shipping_outlined, 'Type', 'Poids Lourd (C)'),
          const Divider(height: 24),
          _buildDetailRow(Icons.credit_card, 'Immatriculation', '12345 | A | 12'),
          const SizedBox(height: 32),
          // Capacity
          _buildSectionHeader('Capacité Totale', 'السعة الإجمالية'),
          const SizedBox(height: 16),
          _buildCapacityRow(),
          const SizedBox(height: 32),
          // Equipment
          _buildSectionHeader('Équipements', 'المعدات'),
          const SizedBox(height: 16),
          ...List.generate(
            _equipments.length,
            (index) => _buildEquipmentRow(_equipments[index]),
          ),
          const SizedBox(height: 32),
          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String titleFr, String titleAr) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFF4ADE80).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.info_outline,
                color: Color(0xFF4ADE80),
                size: 14,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              titleFr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        Text(
          titleAr,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.grey[600], size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildCapacityRow() {
    return Row(
      children: [
        _buildCapacityCard('🐄', 'BOVINS', '12'),
        const SizedBox(width: 12),
        _buildCapacityCard('🐑', 'OVINS', '45'),
        const SizedBox(width: 12),
        _buildCapacityCard('🐐', 'CAPRINS', '50'),
      ],
    );
  }

  Widget _buildCapacityCard(String emoji, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentRow(Equipment equipment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF4ADE80).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.check,
              color: Color(0xFF4ADE80),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              equipment.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Icon(
            Icons.check_circle,
            color: equipment.isActive ? const Color(0xFF4ADE80) : Colors.grey,
            size: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Edit Vehicle Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4ADE80),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit, size: 18),
                SizedBox(width: 8),
                Text(
                  'Modifier le véhicule',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'تعديل المركبة',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Add Another Truck Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF4ADE80),
              side: const BorderSide(color: Color(0xFF4ADE80)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline, size: 18),
                SizedBox(width: 8),
                Text(
                  'Ajouter un autre camion',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'إضافة شاحنة أخرى',
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'ACCUEIL', 0),
              _buildNavItem(Icons.calendar_today, 'PLANNING', 1),
              _buildNavItem(Icons.local_shipping, 'MON CAMION', 2),
              _buildNavItem(Icons.person_outline, 'PROFIL', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 26,
            color: isSelected ? const Color(0xFF4ADE80) : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0xFF4ADE80) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class Equipment {
  final String name;
  final bool isActive;

  Equipment({required this.name, required this.isActive});
}
