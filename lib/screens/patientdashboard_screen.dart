import 'package:flutter/material.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF0FAF5),
              Color(0xFFE8F4FB),
              Color(0xFFEEF7F0),
              Color(0xFFF5F0FB),
            ],
            stops: [0.0, 0.4, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            _blob(
              top: -50,
              right: -50,
              size: 200,
              color: const Color(0x1F1D9E75),
            ),
            _blob(
              top: 300,
              left: -70,
              size: 220,
              color: const Color(0x1A185FA5),
            ),
            _blob(
              top: 700,
              right: -40,
              size: 160,
              color: const Color(0x1A639922),
            ),
            SafeArea(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(),
                    _buildHealthStatusBanner(),
                    _buildQuickActions(),
                    _buildVitals(),
                    _buildUpcomingAppointments(),
                    _buildTodaysMedicines(),
                    _buildRecentPrescriptions(),
                    _buildNearbyDoctors(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Background Blob ────────────────────────────────────────────────────────
  Widget _blob({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, Colors.transparent]),
        ),
      ),
    );
  }

  // ── Top Bar ────────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Good morning 🌤️',
                  style: TextStyle(fontSize: 13, color: Color(0xFF888780)),
                ),
                SizedBox(height: 2),
                Text(
                  'Rahul Sharma',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
          // Notification bell
          Stack(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('🔔', style: TextStyle(fontSize: 18)),
                ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          // Avatar
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF185FA5), Color(0xFF1D9E75)],
              ),
            ),
            child: const Center(
              child: Text(
                'R',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Health Status Banner ───────────────────────────────────────────────────
  Widget _buildHealthStatusBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF185FA5), Color(0xFF1D9E75)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              right: 30,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Health Status',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.75),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Good 💪',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _bannerStat('Last checkup', '3 days ago'),
                    const SizedBox(width: 20),
                    _bannerStat('Next appointment', 'May 10, 2026'),
                    const SizedBox(width: 20),
                    _bannerStat('Active medicines', '3 ongoing'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bannerStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.7)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ── Quick Actions ──────────────────────────────────────────────────────────
  Widget _buildQuickActions() {
    final actions = [
      {
        'emoji': '📅',
        'label': 'Book\nAppointment',
        'color': const Color(0x1A185FA5),
      },
      {'emoji': '💊', 'label': 'Medicines', 'color': const Color(0x1A1D9E75)},
      {
        'emoji': '🩺',
        'label': 'Consult\nDoctor',
        'color': const Color(0x1AEF4444),
      },
      {'emoji': '📋', 'label': 'Records', 'color': const Color(0x1AF59E0B)},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Quick Actions'),
          Row(
            children: actions.map((a) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {}, // TODO: handle tap
                  child: Container(
                    margin: EdgeInsets.only(right: a == actions.last ? 0 : 8),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFF1D9E75).withOpacity(0.15),
                      ),
                      color: Colors.white.withOpacity(0.7),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: a['color'] as Color,
                          ),
                          child: Center(
                            child: Text(
                              a['emoji'] as String,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          a['label'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF444444),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Vitals ─────────────────────────────────────────────────────────────────
  Widget _buildVitals() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Vitals', showViewAll: true),
          Row(
            children: [
              Expanded(
                child: _vitalCard(
                  '❤️',
                  '78',
                  'bpm',
                  'Heart Rate',
                  'Normal',
                  const Color(0xFFEF4444),
                  const Color(0xFF1D9E75),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _vitalCard(
                  '🩸',
                  '120/80',
                  'mmHg',
                  'Blood Pressure',
                  'Normal',
                  const Color(0xFF185FA5),
                  const Color(0xFF1D9E75),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _vitalCard(
                  '🌡️',
                  '98.6',
                  '°F',
                  'Temperature',
                  'Normal',
                  const Color(0xFFF59E0B),
                  const Color(0xFFF59E0B),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _vitalCard(
                  '💉',
                  '99',
                  'mg/dL',
                  'Blood Sugar',
                  'Normal',
                  const Color(0xFF1D9E75),
                  const Color(0xFF1D9E75),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _vitalCard(
    String emoji,
    String value,
    String unit,
    String label,
    String status,
    Color valueColor,
    Color chipColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: valueColor,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF888780),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF888780)),
          ),
          const SizedBox(height: 6),
          _chip(status, chipColor.withOpacity(0.15), chipColor),
        ],
      ),
    );
  }

  // ── Upcoming Appointments ──────────────────────────────────────────────────
  Widget _buildUpcomingAppointments() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Upcoming Appointments', showViewAll: true),
          _appointmentCard(
            emoji: '👨‍⚕️',
            name: 'Dr. Priya Mehta',
            specialty: 'Cardiologist • Apollo Hospital',
            date: 'May 10, 2026',
            time: '10:30 AM',
            status: 'Confirmed',
            statusBg: const Color(0x1A185FA5),
            statusColor: const Color(0xFF185FA5),
            gradientColors: [const Color(0x1E185FA5), const Color(0x1E1D9E75)],
          ),
          const SizedBox(height: 10),
          _appointmentCard(
            emoji: '🧑‍⚕️',
            name: 'Dr. Suresh Patil',
            specialty: 'General Physician • City Clinic',
            date: 'May 15, 2026',
            time: '2:00 PM',
            status: 'Pending',
            statusBg: const Color(0x1AF59E0B),
            statusColor: const Color(0xFFF59E0B),
            gradientColors: [const Color(0x1EF59E0B), const Color(0x1EEF4444)],
          ),
        ],
      ),
    );
  }

  Widget _appointmentCard({
    required String emoji,
    required String name,
    required String specialty,
    required String date,
    required String time,
    required String status,
    required Color statusBg,
    required Color statusColor,
    required List<Color> gradientColors,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.85)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D9E75).withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(colors: gradientColors),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      specialty,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF888780),
                      ),
                    ),
                  ],
                ),
              ),
              _chip(status, statusBg, statusColor),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _infoTag('📅', date)),
              const SizedBox(width: 8),
              Expanded(child: _infoTag('⏰', time)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTag(String emoji, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1D9E75).withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF444444),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Today's Medicines ──────────────────────────────────────────────────────
  Widget _buildTodaysMedicines() {
    final meds = [
      {
        'emoji': '💊',
        'name': 'Metformin 500mg',
        'time': 'After breakfast • 1 tablet',
        'status': '✓ Taken',
        'statusBg': const Color(0x1A1D9E75),
        'statusColor': const Color(0xFF1D9E75),
        'iconBg': const Color(0x1AEF4444),
      },
      {
        'emoji': '💊',
        'name': 'Amlodipine 5mg',
        'time': 'After lunch • 1 tablet',
        'status': '⏳ Pending',
        'statusBg': const Color(0x1AF59E0B),
        'statusColor': const Color(0xFFF59E0B),
        'iconBg': const Color(0x1A185FA5),
      },
      {
        'emoji': '💊',
        'name': 'Vitamin D3',
        'time': 'At night • 1 tablet',
        'status': '⏰ Due',
        'statusBg': const Color(0x1AEF4444),
        'statusColor': const Color(0xFFEF4444),
        'iconBg': const Color(0x1A639922),
      },
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader("Today's Medicines", showViewAll: true),
          ...meds
              .map(
                (m) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    vertical: 11,
                    horizontal: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.9)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: m['iconBg'] as Color,
                        ),
                        child: Center(
                          child: Text(
                            m['emoji'] as String,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m['name'] as String,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              m['time'] as String,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF888780),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _chip(
                        m['status'] as String,
                        m['statusBg'] as Color,
                        m['statusColor'] as Color,
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  // ── Recent Prescriptions ───────────────────────────────────────────────────
  Widget _buildRecentPrescriptions() {
    final prescriptions = [
      {
        'emoji': '📄',
        'doctor': 'Dr. Mehta',
        'date': 'Apr 30, 2026',
        'tag': 'Cardiology',
        'tagBg': const Color(0x1A185FA5),
        'tagColor': const Color(0xFF185FA5),
      },
      {
        'emoji': '📄',
        'doctor': 'Dr. Patil',
        'date': 'Apr 18, 2026',
        'tag': 'General',
        'tagBg': const Color(0x1A1D9E75),
        'tagColor': const Color(0xFF1D9E75),
      },
      {
        'emoji': '🩻',
        'doctor': 'Lab Report',
        'date': 'Apr 10, 2026',
        'tag': 'Blood Test',
        'tagBg': const Color(0x1AF59E0B),
        'tagColor': const Color(0xFFF59E0B),
      },
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Recent Prescriptions', showViewAll: true),
          Row(
            children: prescriptions.map((p) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: p == prescriptions.last ? 0 : 10,
                  ),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.85)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p['emoji'] as String,
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        p['doctor'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        p['date'] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF888780),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _chip(
                        p['tag'] as String,
                        p['tagBg'] as Color,
                        p['tagColor'] as Color,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Nearby Doctors ─────────────────────────────────────────────────────────
  Widget _buildNearbyDoctors() {
    final doctors = [
      {
        'emoji': '👩‍⚕️',
        'name': 'Dr. Anita Kulkarni',
        'specialty': 'Dermatologist',
        'distance': '0.8 km',
        'rating': '4.9',
        'stars': '★★★★★',
        'gradientColors': [const Color(0x261D9E75), const Color(0x26185FA5)],
      },
      {
        'emoji': '👨‍⚕️',
        'name': 'Dr. Ramesh Joshi',
        'specialty': 'Orthopedic',
        'distance': '1.2 km',
        'rating': '4.6',
        'stars': '★★★★☆',
        'gradientColors': [const Color(0x26F59E0B), const Color(0x26EF4444)],
      },
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Nearby Doctors', showViewAll: true),
          ...doctors
              .map(
                (d) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.9)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: d['gradientColors'] as List<Color>,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            d['emoji'] as String,
                            style: const TextStyle(fontSize: 22),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              d['name'] as String,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${d['specialty']} • ${d['distance']}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF888780),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                Text(
                                  d['stars'] as String,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFFF59E0B),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  d['rating'] as String,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF888780),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {}, // TODO: Book appointment
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 7,
                            horizontal: 14,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF185FA5), Color(0xFF1D9E75)],
                            ),
                          ),
                          child: const Text(
                            'Book',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  // ── Shared helpers ─────────────────────────────────────────────────────────
  Widget _sectionHeader(String title, {bool showViewAll = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          if (showViewAll)
            GestureDetector(
              onTap: () {}, // TODO: handle view all
              child: const Text(
                'View all →',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF1D9E75),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _chip(String label, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
