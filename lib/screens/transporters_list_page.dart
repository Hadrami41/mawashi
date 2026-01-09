import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transport_provider.dart';
import '../models/transport_vehicle.dart';

class TransportersListPage extends StatefulWidget {
  const TransportersListPage({super.key});

  @override
  State<TransportersListPage> createState() => _TransportersListPageState();
}

class _TransportersListPageState extends State<TransportersListPage> {
  int _selectedFilter = 0;
  final List<String> _filters = ['Moutons (غنم)', 'Bœufs (بقر)', 'Urgent'];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Search vehicles if none are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<TransportProvider>();
      if (provider.vehicles.isEmpty) {
        provider.searchVehicles();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Consumer<TransportProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                const Text(
                  'Transporteurs',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${provider.vehicles.length} disponibles à proximité',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  _filters.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFilterChip(_filters[index], index),
                  ),
                ),
              ),
            ),
          ),
          // Results Title
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Résultats de recherche',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          // Vehicles List
          Expanded(
            child: Consumer<TransportProvider>(
              builder: (context, transportProvider, child) {
                if (transportProvider.isLoadingVehicles) {
                  return const Center(child: CircularProgressIndicator());
                }

                final vehicles = transportProvider.vehicles;
                if (vehicles.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text('Aucun transporteur trouvé'),
                        TextButton(
                          onPressed: () => transportProvider.searchVehicles(),
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    return _buildVehicleCard(vehicles[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilter == index;
    final isUrgentFilter = index == 2;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedFilter = index);
        // Apply filter logic if needed
        if (isUrgentFilter) {
          // Just as an example, we could filter here or in provider
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isUrgentFilter
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF4ADE80))
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (isUrgentFilter
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF4ADE80))
                : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard(TransportVehicle vehicle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: vehicle.isUrgent
            ? Border.all(color: const Color(0xFFEF4444), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Urgent Banner
          if (vehicle.isUrgent)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFFFEE2E2),
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning, color: Color(0xFFEF4444), size: 18),
                  SizedBox(width: 8),
                  Text(
                    'PARTICULIÈREMENT RAPIDE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
            ),
          // Image
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.vertical(
                top: vehicle.isUrgent ? Radius.zero : const Radius.circular(16),
              ),
              // Use a pattern or local image if network fails
              image: DecorationImage(
                image: NetworkImage(
                  'https://jslyifjhihoksfolzijr.supabase.co/storage/v1/object/public/assets/truck_placeholder.jpg',
                  headers: {'Accept': 'image/*'},
                ),
                fit: BoxFit.cover,
                onError: (e, s) => {},
              ),
            ),
            child: Stack(
              children: [
                if (!vehicle.isUrgent)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: vehicle.statusColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        vehicle.statusText,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Distance
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicle.title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            vehicle.subtitle,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'DISTANCE',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          vehicle.formattedDistance,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Price
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Prix estimé (السعر التقديري)',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        vehicle.formattedPrice,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: vehicle.isUrgent
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF4ADE80),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Réserver (حجز)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: vehicle.isUrgent
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF4ADE80),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(
                            color: vehicle.isUrgent
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF4ADE80),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Appeler (اتصال)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
              _buildNavItem(Icons.local_shipping, 'Transport', 0),
              _buildNavItem(Icons.history, 'Mes courses', 1),
              _buildNavItem(Icons.person_outline, 'Profil', 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _currentIndex = index);
        if (index == 0) Navigator.pushNamed(context, '/home');
      },
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
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0xFF4ADE80) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
