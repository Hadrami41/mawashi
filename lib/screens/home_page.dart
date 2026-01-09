import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/transport_provider.dart';
import '../models/trip.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load data after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransportProvider>().loadActiveTrips();
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
        child: RefreshIndicator(
          onRefresh: () => context.read<TransportProvider>().refreshAll(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Header
                  _buildHeader(),
                  const SizedBox(height: 24),
                  // Search Form Card
                  _buildSearchForm(),
                  const SizedBox(height: 20),
                  // Action Cards
                  _buildActionCards(),
                  const SizedBox(height: 24),
                  // Current Transport
                  _buildCurrentTransport(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;
        final name = user?.fullName ?? 'Jean-Pierre';

        return Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  user?.avatarUrl != null ? '' : '🐄',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Welcome Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back,',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            // Notification Bell
            _buildNotificationBell(),
          ],
        );
      },
    );
  }

  Widget _buildNotificationBell() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(
              Icons.notifications_outlined,
              color: Colors.black87,
              size: 24,
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchForm() {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Departure
          _buildSearchField(
            icon: Icons.circle_outlined,
            iconColor: const Color(0xFF4ADE80),
            label: 'DEPARTURE',
            hint: 'Search farm or city',
            controller: _departureController,
          ),
          const SizedBox(height: 16),
          // Destination
          _buildSearchField(
            icon: Icons.location_on,
            iconColor: const Color(0xFF4ADE80),
            label: 'DESTINATION',
            hint: 'Where to?',
            controller: _destinationController,
          ),
          const SizedBox(height: 16),
          // Date Row
          Row(
            children: [
              Expanded(
                child: _buildSearchField(
                  icon: Icons.calendar_today_outlined,
                  iconColor: Colors.grey,
                  label: 'DATE',
                  hint: 'mm/dd/yyyy',
                  controller: _dateController,
                  showCalendarIcon: true,
                ),
              ),
              const SizedBox(width: 12),
              // Search Button
              GestureDetector(
                onTap: _onSearch,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ADE80),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ],
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

    // Navigate to transporters list page
    Navigator.pushNamed(context, '/transporters');
  }

  Widget _buildSearchField({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String hint,
    required TextEditingController controller,
    bool showCalendarIcon = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: iconColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
                letterSpacing: 0.5,
              ),
            ),
          ],
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
            suffixIcon: showCalendarIcon
                ? const Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: Colors.grey,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCards() {
    return Row(
      children: [
        // Create a Request
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/transport-request'),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF4ADE80),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 24),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Create a\nRequest',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Find a Carpool
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/groupage'),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
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
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.local_shipping_outlined,
                      color: Colors.black54,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Find a\nCarpool',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentTransport() {
    return Consumer<TransportProvider>(
      builder: (context, transportProvider, child) {
        if (transportProvider.isLoadingTrips) {
          return const Center(child: CircularProgressIndicator());
        }

        final trip = transportProvider.currentTrip;
        if (trip == null) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Current Transport',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ADE80).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4ADE80),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Trip Card
            _buildTripCard(trip),
          ],
        );
      },
    );
  }

  Widget _buildTripCard(Trip trip) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/tracking'),
      child: Container(
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
            // Map Placeholder
            Container(
              height: 160,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Stack(
                children: [
                  // Map background pattern
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFFD4EAD7).withValues(alpha: 0.9),
                          const Color(0xFFE8F5E9).withValues(alpha: 0.9),
                        ],
                      ),
                    ),
                  ),
                  // Transport Icon
                  Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4ADE80),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF4ADE80,
                            ).withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.local_shipping,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Transport Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transport #${trip.id.substring(0, 4)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        trip.estimatedTimeRemaining,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4ADE80),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'To: ${trip.destination}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 12),
                  // Progress Bar
                  LinearProgressIndicator(
                    value: trip.progress,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF4ADE80),
                    ),
                    borderRadius: BorderRadius.circular(4),
                    minHeight: 6,
                  ),
                ],
              ),
            ),
          ],
        ),
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
              _buildNavItem(Icons.home, 'HOME', 0),
              _buildNavItem(Icons.local_shipping_outlined, 'MY TRIPS', 1),
              _buildNavItem(Icons.inbox_outlined, 'INBOX', 2),
              _buildNavItem(Icons.person_outline, 'ACCOUNT', 3),
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
        if (index == 1) {
          Navigator.pushNamed(context, '/tracking');
        }
        if (index == 3) {
          Navigator.pushNamed(context, '/registration');
        }
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
