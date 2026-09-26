import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const GosuCalendarApp());
}

class GosuCalendarApp extends StatelessWidget {
  const GosuCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gosu Neon Calendar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF030014), // Cyberpunk dark abyss
      ),
      home: const CyberCalendarScreen(),
    );
  }
}

class CyberCalendarScreen extends StatefulWidget {
  const CyberCalendarScreen({super.key});

  @override
  State<CyberCalendarScreen> createState() => _CyberCalendarScreenState();
}

class _CyberCalendarScreenState extends State<CyberCalendarScreen> with TickerProviderStateMixin {
  // Calendar State
  int _currentMonth = 10;
  int _currentYear = 2026;
  int _selectedDay = 15;
  int _hoveredDay = -1;
  
  final List<String> _monthNames = ["ENERO", "FEBRERO", "MARZO", "ABRIL", "MAYO", "JUNIO", "JULIO", "AGOSTO", "SEPTIEMBRE", "OCTUBRE", "NOVIEMBRE", "DICIEMBRE"];

  // Neon Cyberpunk Colors
  final Color neonCyan = const Color(0xFF00F0FF);
  final Color neonPink = const Color(0xFFFF007F);
  final Color neonPurple = const Color(0xFFB026FF);
  final Color darkCard = const Color(0xFF0A0A1A);

  // Background Animations
  late AnimationController _bgController;
  
  // 3D Tilt State para el efecto GOSU
  double _tiltX = 0.0;
  double _tiltY = 0.0;

  // Base de datos de eventos (Cyberpunk style)
  final Map<int, List<Map<String, dynamic>>> _cyberEvents = {
    5: [{'title': 'SINCRONIZACIÓN DE NÚCLEO', 'time': '10:00 AM', 'color': const Color(0xFF00F0FF), 'icon': FontAwesomeIcons.microchip}],
    12: [{'title': 'SIMULACIÓN TÁCTICA', 'time': '09:00 AM', 'color': const Color(0xFFFF007F), 'icon': FontAwesomeIcons.vrCardboard}],
    15: [
      {'title': 'DESPLIEGUE DEL LABORATORIO', 'time': '23:59 PM', 'color': const Color(0xFFB026FF), 'icon': FontAwesomeIcons.codeBranch},
      {'title': 'RECARGA ENERGÉTICA', 'time': '02:00 PM', 'color': const Color(0xFF00F0FF), 'icon': FontAwesomeIcons.bolt},
    ],
    21: [{'title': 'PURGA DE SISTEMA', 'time': '04:00 AM', 'color': const Color(0xFFFF007F), 'icon': FontAwesomeIcons.skullCrossbones}],
  };

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  void _changeMonth(int direction) {
    setState(() {
      _currentMonth += direction;
      if (_currentMonth > 12) {
        _currentMonth = 1;
        _currentYear++;
      } else if (_currentMonth < 1) {
        _currentMonth = 12;
        _currentYear--;
      }
      _selectedDay = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Fondo Animado Cyberpunk (Líneas de gradiente rotando)
          _buildNeonBackground(),
          
          // 2. Contenido UI
          SafeArea(
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutExpo,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 50 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Column(
                  children: [
                    _buildCyberHeader(),
                    const SizedBox(height: 30),
                    
                    // Efecto 3D Hover ultra GOSU para el calendario
                    _build3DCalendarCard(),
                    
                    const SizedBox(height: 40),
                    _buildEventsGlitchTitle(),
                    const SizedBox(height: 20),
                    
                    _buildCyberEventsList(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
          
          // Barra inferior futurista
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: _buildCyberBottomBar(),
          )
        ],
      ),
    );
  }

  Widget _buildNeonBackground() {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: SweepGradient(
              center: Alignment.center,
              startAngle: 0.0,
              endAngle: 3.14 * 2,
              colors: [
                const Color(0xFF030014),
                neonPurple.withOpacity(0.2),
                const Color(0xFF030014),
                neonCyan.withOpacity(0.2),
                const Color(0xFF030014),
              ],
              transform: GradientRotation(_bgController.value * 3.14 * 2),
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Container(color: Colors.transparent),
          ),
        );
      },
    );
  }

  Widget _buildCyberHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "SISTEMA ONLINE",
              style: GoogleFonts.shareTechMono(color: neonCyan, fontSize: 14, letterSpacing: 2),
            ),
            Text(
              "AGENTE ANDERSON",
              style: GoogleFonts.orbitron(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ],
        ),
        // Avatar hexagonal o brillante
        Container(
          width: 50, height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: neonPink, width: 2),
            boxShadow: [BoxShadow(color: neonPink.withOpacity(0.6), blurRadius: 15, spreadRadius: 2)],
            image: const DecorationImage(image: NetworkImage('https://i.pravatar.cc/150?img=33'), fit: BoxFit.cover),
          ),
        )
      ],
    );
  }

  Widget _build3DCalendarCard() {
    return MouseRegion(
      onHover: (e) {
        setState(() {
          // Calcula el tilt basado en la posición del mouse para efecto 3D
          _tiltX = (e.localPosition.dy - 200) / -2000;
          _tiltY = (e.localPosition.dx - 200) / 2000;
        });
      },
      onExit: (_) {
        setState(() {
          _tiltX = 0;
          _tiltY = 0;
        });
      },
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // Perspectiva 3D
          ..rotateX(_tiltX)
          ..rotateY(_tiltY),
        alignment: FractionalOffset.center,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: darkCard.withOpacity(0.8),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: neonCyan.withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(color: neonCyan.withOpacity(0.15), blurRadius: 40, spreadRadius: 5),
              BoxShadow(color: neonPurple.withOpacity(0.1), blurRadius: 20, spreadRadius: -5, offset: const Offset(0, 20)),
            ],
          ),
          child: Column(
            children: [
              // Controles del mes con fuentes GOSU
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNeonIconButton(FontAwesomeIcons.chevronLeft, neonPink, () => _changeMonth(-1)),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      "${_monthNames[_currentMonth - 1]} // $_currentYear",
                      key: ValueKey("$_currentMonth$_currentYear"),
                      style: GoogleFonts.orbitron(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2),
                    ),
                  ),
                  _buildNeonIconButton(FontAwesomeIcons.chevronRight, neonCyan, () => _changeMonth(1)),
                ],
              ),
              const SizedBox(height: 30),
              _buildDaysOfWeek(),
              const SizedBox(height: 20),
              _buildRealCalendarGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNeonIconButton(dynamic icon, Color neonColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: neonColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: neonColor.withOpacity(0.5)),
          boxShadow: [BoxShadow(color: neonColor.withOpacity(0.3), blurRadius: 10)],
        ),
        child: FaIcon(icon, color: neonColor, size: 16),
      ),
    );
  }

  Widget _buildDaysOfWeek() {
    const days = ['LUN', 'MAR', 'MIE', 'JUE', 'VIE', 'SAB', 'DOM'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: GoogleFonts.rajdhani(fontWeight: FontWeight.w700, color: neonCyan.withOpacity(0.7), fontSize: 14, letterSpacing: 1),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRealCalendarGrid() {
    DateTime firstDay = DateTime(_currentYear, _currentMonth, 1);
    int daysInMonth = DateUtils.getDaysInMonth(_currentYear, _currentMonth);
    int firstDayOffset = firstDay.weekday - 1;
    
    List<Widget> rows = [];
    List<Widget> currentWeek = [];
    
    for (int i = 0; i < firstDayOffset; i++) {
      currentWeek.add(const Expanded(child: SizedBox()));
    }
    
    for (int day = 1; day <= daysInMonth; day++) {
      currentWeek.add(Expanded(child: _buildCyberDayCell(day)));
      if (currentWeek.length == 7) {
        rows.add(Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: currentWeek));
        rows.add(const SizedBox(height: 14));
        currentWeek = [];
      }
    }
    
    if (currentWeek.isNotEmpty) {
      while (currentWeek.length < 7) {
        currentWeek.add(const Expanded(child: SizedBox()));
      }
      rows.add(Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: currentWeek));
    }
    
    return Column(children: rows);
  }

  Widget _buildCyberDayCell(int day) {
    bool isSelected = _selectedDay == day;
    bool isHovered = _hoveredDay == day;
    List<Map<String, dynamic>> events = _cyberEvents[day] ?? [];
    
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredDay = day),
      onExit: (_) => setState(() => _hoveredDay = -1),
      child: GestureDetector(
        onTap: () => setState(() => _selectedDay = day),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? neonPurple.withOpacity(0.3) : (isHovered ? Colors.white.withOpacity(0.05) : Colors.transparent),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? neonPurple : (events.isNotEmpty ? Colors.white24 : Colors.transparent), width: isSelected ? 2 : 1),
            boxShadow: isSelected ? [BoxShadow(color: neonPurple.withOpacity(0.6), blurRadius: 15, spreadRadius: 1)] : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                day.toString(),
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.bold : (events.isNotEmpty ? FontWeight.w600 : FontWeight.w400),
                  color: isSelected ? Colors.white : (events.isNotEmpty ? neonCyan : Colors.white54),
                  shadows: isSelected ? [Shadow(color: neonPurple, blurRadius: 10)] : [],
                ),
              ),
              const SizedBox(height: 4),
              // Indicadores Cyberpunk (Barras de neón abajo)
              if (events.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: events.take(3).map((e) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      width: 8, height: 3,
                      decoration: BoxDecoration(
                        color: e['color'],
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [BoxShadow(color: e['color'], blurRadius: 5)],
                      ),
                    );
                  }).toList(),
                )
              else
                const SizedBox(height: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventsGlitchTitle() {
    return Row(
      children: [
        Container(width: 4, height: 24, color: neonPink, margin: const EdgeInsets.only(right: 12)),
        Text(
          "DATOS DEL DÍA // $_selectedDay",
          style: GoogleFonts.orbitron(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2),
        ),
      ],
    );
  }

  Widget _buildCyberEventsList() {
    List<Map<String, dynamic>> todaysEvents = _cyberEvents[_selectedDay] ?? [];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0.1, 0), end: Offset.zero).animate(animation),
            child: child,
          ),
        );
      },
      child: todaysEvents.isEmpty 
          ? _buildEmptyCyberState() 
          : Column(
              key: ValueKey<int>(_selectedDay),
              children: todaysEvents.map((event) => _buildCyberEventCard(event)).toList(),
            ),
    );
  }

  Widget _buildEmptyCyberState() {
    return Container(
      key: ValueKey<String>("empty_$_selectedDay"),
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          FaIcon(FontAwesomeIcons.satelliteDish, size: 50, color: neonCyan.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text("NO SE DETECTAN ANOMALÍAS", style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildCyberEventCard(Map<String, dynamic> event) {
    Color color = event['color'];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: darkCard.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.15), blurRadius: 20, spreadRadius: -5),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Barra lateral brillante
                Container(
                  width: 6,
                  decoration: BoxDecoration(
                    color: color,
                    boxShadow: [BoxShadow(color: color, blurRadius: 10, spreadRadius: 2)],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: FaIcon(event['icon'], color: color, size: 24),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          event['title'],
                          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            FaIcon(FontAwesomeIcons.clock, size: 12, color: color.withOpacity(0.8)),
                            const SizedBox(width: 6),
                            Text(
                              event['time'],
                              style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 14),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: FaIcon(FontAwesomeIcons.angleRight, color: Colors.white30, size: 20),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCyberBottomBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF030014).withOpacity(0.7),
            border: Border(top: BorderSide(color: neonCyan.withOpacity(0.3), width: 1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCyberNavIcon(FontAwesomeIcons.calendarDay, neonCyan, true),
              _buildCyberNavIcon(FontAwesomeIcons.chartLine, Colors.white54, false),
              // Botón central de escaner (GOSU FAB)
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: neonPurple.withOpacity(0.2),
                  border: Border.all(color: neonPurple, width: 2),
                  boxShadow: [BoxShadow(color: neonPurple.withOpacity(0.6), blurRadius: 20, spreadRadius: 2)],
                ),
                child: Center(
                  child: FaIcon(FontAwesomeIcons.crosshairs, color: neonCyan, size: 28),
                ),
              ),
              _buildCyberNavIcon(FontAwesomeIcons.solidBell, Colors.white54, false),
              _buildCyberNavIcon(FontAwesomeIcons.userAstronaut, Colors.white54, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCyberNavIcon(dynamic icon, Color color, bool isSelected) {
    return IconButton(
      icon: FaIcon(icon, size: 26, color: color),
      onPressed: () {},
    );
  }
}
