import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transport_provider.dart';
import '../models/transporter.dart';

class FindTransportPage extends StatefulWidget {
  const FindTransportPage({super.key});

  @override
  State<FindTransportPage> createState() => _FindTransportPageState();
}

class _FindTransportPageState extends State<FindTransportPage> {
  int _currentIndex = 0;
  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController(
    text: "Aujourd'hui",
  );

  @override
  void initState() {
    super.initState();
    // Load transporters on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransportProvider>().loadTransporters();
    });
  }

  @override
  void dispose() {
    _departureController.dispose();
    _destinationController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              const SizedBox(height: 24),
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Trouver un transport',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '(البحث عن نقل)',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Search Form
              _buildSearchForm(),
              const SizedBox(height: 32),
              // Available Transporters
              _buildTransportersList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Logo
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Center(
              child: Text('🐑', style: TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 12),
          // Brand
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Raahi',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'LIVESTOCK TRANSPORT',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4ADE80),
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          // Language
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Icon(
              Icons.language,
              color: Color(0xFF4ADE80),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchForm() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Departure
          _buildFormField(
            labelFr: 'Lieu de départ',
            labelAr: 'مكان المغادرة',
            hint: 'Ex: Marché de bétail...',
            controller: _departureController,
            icon: Icons.my_location,
            iconColor: const Color(0xFF4ADE80),
          ),
          const Divider(height: 32),
          // Destination
          _buildFormField(
            labelFr: 'Destination',
            labelAr: 'الوجهة',
            hint: 'Ex: Ferme Oued...',
            controller: _destinationController,
            icon: Icons.location_on,
            iconColor: const Color(0xFF4ADE80),
          ),
          const Divider(height: 32),
          // Date
          _buildFormField(
            labelFr: 'Date',
            labelAr: 'التاريخ',
            hint: "Aujourd'hui",
            controller: _dateController,
            icon: Icons.calendar_today_outlined,
            iconColor: Colors.grey,
            isDate: true,
          ),
          const SizedBox(height: 24),
          // Search Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: Consumer<TransportProvider>(
              builder: (context, transportProvider, child) {
                return ElevatedButton(
                  onPressed: transportProvider.isLoadingTransporters
                      ? null
                      : _onSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4ADE80),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: transportProvider.isLoadingTransporters
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search, size: 22),
                            SizedBox(width: 8),
                            Text(
                              'Rechercher (بحث)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onSearch() {
    final dep = _departureController.text;
    final dest = _destinationController.text;

    context.read<TransportProvider>().searchVehicles(
      departure: dep.isNotEmpty ? dep : null,
      destination: dest.isNotEmpty ? dest : null,
    );

    // Switch over to transporters list page to show results
    Navigator.pushNamed(context, '/transporters');
  }

  Widget _buildFormField({
    required String labelFr,
    required String labelAr,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    required Color iconColor,
    bool isDate = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                labelFr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  suffixIcon: Icon(icon, color: iconColor, size: 22),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Text(labelAr, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
      ],
    );
  }

  Widget _buildTransportersList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Transporteurs disponibles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'الناقلون المتاحون',
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/transporters'),
                child: const Text(
                  'Voir tout',
                  style: TextStyle(
                    color: Color(0xFF4ADE80),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Transporters List
          Consumer<TransportProvider>(
            builder: (context, transportProvider, child) {
              if (transportProvider.isLoadingTransporters) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final transporters = transportProvider.transporters;
              if (transporters.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Aucun transporteur disponible'),
                );
              }

              return Column(
                children: transporters
                    .take(3) // Only show top 3 on this page
                    .map((t) => _buildTransporterCard(t))
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTransporterCard(Transporter transporter) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: transporter.iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.local_shipping,
              color: transporter.iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transporter.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Capacité: ${transporter.capacity}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    Text(
                      ' (رؤوس)',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: transporter.tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          // Rating
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, size: 16, color: Color(0xFF4ADE80)),
                const SizedBox(width: 4),
                Text(
                  transporter.rating.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4ADE80),
                  ),
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
              _buildNavItem(Icons.home, 'Accueil', 0),
              _buildNavItem(Icons.access_time, 'Trajets', 1),
              _buildNavItem(Icons.notifications, 'Alertes', 2),
              _buildNavItem(Icons.person_outline, 'Profil', 3),
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
