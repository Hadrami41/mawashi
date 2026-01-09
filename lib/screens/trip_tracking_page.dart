import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transport_provider.dart';
import '../models/trip.dart';

class TripTrackingPage extends StatefulWidget {
  const TripTrackingPage({super.key});

  @override
  State<TripTrackingPage> createState() => _TripTrackingPageState();
}

class _TripTrackingPageState extends State<TripTrackingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransportProvider>().loadActiveTrips();
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
        title: const Text(
          'Suivi du trajet',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87),
            onPressed: () =>
                context.read<TransportProvider>().loadActiveTrips(),
          ),
        ],
      ),
      body: Consumer<TransportProvider>(
        builder: (context, transportProvider, child) {
          if (transportProvider.isLoadingTrips) {
            return const Center(child: CircularProgressIndicator());
          }

          final trip = transportProvider.currentTrip;
          if (trip == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.history, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Aucun trajet en cours'),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Retour'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Offline Mode Banner
                _buildOfflineBanner(),
                const SizedBox(height: 16),
                // Map Section
                _buildMapSection(trip),
                const SizedBox(height: 24),
                // Timeline Section
                _buildTimelineSection(trip),
                const SizedBox(height: 24),
                // Report Incident Button
                _buildReportButton(),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOfflineBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.wifi_off, color: Colors.black54, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mode hors-ligne (وضع بدون انترنت)',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Synchronisation automatique active',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection(Trip trip) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Map
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFE8D5C4).withValues(alpha: 0.7),
                  const Color(0xFFD4EAD7).withValues(alpha: 0.7),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Simulated map road lines
                CustomPaint(
                  size: const Size(double.infinity, 180),
                  painter: MapLinePainter(),
                ),
                // Vehicle Marker
                Positioned(
                  left: 100 + (trip.progress * 150),
                  top: 70 - (trip.progress * 20),
                  child: Column(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4ADE80),
                          borderRadius: BorderRadius.circular(18),
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
                          size: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          trip.id.substring(0, 4),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Place labels
                Positioned(
                  left: 20,
                  bottom: 20,
                  child: Text(
                    trip.departure,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 20,
                  child: Text(
                    trip.destination,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Next Stop Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF0FDF4),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PROCHAINE ÉTAPE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Station Konna - 14km',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'ARRIVÉE ESTIMÉE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trip.formattedEndTime,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
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

  Widget _buildTimelineSection(Trip trip) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Timeline des points d'eau",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '(محطات السقي)',
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
          const SizedBox(height: 20),
          // Timeline Items
          _buildTimelineItem(
            icon: Icons.check_circle,
            iconColor: const Color(0xFF4ADE80),
            title: 'Départ (بدء)',
            titleAr: '',
            subtitle: '${trip.departure} - Hub Central',
            description: 'Inspection vétérinaire terminée',
            time: trip.formattedStartTime,
            isCompleted: true,
            isActive: false,
            showLine: true,
          ),
          _buildTimelineItem(
            icon: Icons.circle,
            iconColor: const Color(0xFFFBBF24),
            title: 'Escale eau - En cours',
            titleAr: '(محطة سقي - جاري)',
            subtitle: '',
            description: '',
            time: 'LIVE',
            isCompleted: false,
            isActive: true,
            showLine: true,
            activeContent: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  const Text(
                    'Remplissage des abreuvoirs en cours',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
          _buildTimelineItem(
            icon: Icons.circle_outlined,
            iconColor: Colors.grey,
            title: 'Escale eau - Suivante',
            titleAr: '(المحطة القادمة)',
            subtitle: '',
            description: 'Destination: ${trip.destination}',
            time: '',
            isCompleted: false,
            isActive: false,
            showLine: false,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String titleAr,
    required String subtitle,
    required String description,
    required String time,
    required bool isCompleted,
    required bool isActive,
    required bool showLine,
    Widget? activeContent,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isActive
                      ? iconColor.withValues(alpha: 0.2)
                      : isCompleted
                      ? iconColor.withValues(alpha: 0.1)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              if (showLine)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted
                        ? const Color(0xFF4ADE80)
                        : Colors.grey.shade300,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isActive
                                    ? Colors.black87
                                    : Colors.black54,
                              ),
                            ),
                            if (titleAr.isNotEmpty)
                              Text(
                                titleAr,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isActive
                                      ? const Color(0xFFFBBF24)
                                      : Colors.grey[500],
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (time.isNotEmpty)
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: time == 'LIVE'
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: time == 'LIVE'
                                ? const Color(0xFF4ADE80)
                                : Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF4ADE80),
                      ),
                    ),
                  ],
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: isActive
                            ? const Color(0xFF4ADE80)
                            : Colors.grey[500],
                        fontStyle: isActive
                            ? FontStyle.normal
                            : FontStyle.italic,
                      ),
                    ),
                  ],
                  if (activeContent != null) activeContent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFEF4444),
                  size: 24,
                ),
                SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Signaler incident',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                    Text(
                      '(تبليغ عن مشكلة)',
                      style: TextStyle(fontSize: 11, color: Color(0xFFEF4444)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Keep the custom painter as it's UI specific
class MapLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.6);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.5,
      size.width * 0.5,
      size.height * 0.55,
    );
    path.quadraticBezierTo(
      size.width * 0.7,
      size.height * 0.6,
      size.width,
      size.height * 0.4,
    );
    canvas.drawPath(path, paint);

    final path2 = Path();
    path2.moveTo(size.width * 0.3, 0);
    path2.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.3,
      size.width * 0.5,
      size.height * 0.55,
    );
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
