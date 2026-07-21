import 'package:flutter/material.dart';
import 'package:nprogress_flutter/nprogress_flutter.dart';

void main() {
  runApp(const NProgressExampleApp());
}

class NProgressExampleApp extends StatelessWidget {
  const NProgressExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NProgress Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2997FF),
          brightness: Brightness.dark,
        ),
      ),
      // Integrate NProgress globally with MaterialApp.builder
      builder: NProgress.builder(),
      navigatorObservers: [
        NProgressNavigatorObserver(),
      ],
      home: const DemoHomePage(),
    );
  }
}

class DemoHomePage extends StatefulWidget {
  const DemoHomePage({super.key});

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
  Color _selectedColor = const Color(0xFF2997FF);
  bool _useGradient = false;
  double _barHeight = 3.0;
  bool _showSpinner = true;
  bool _showPeg = true;
  bool _trickle = true;
  NProgressPosition _position = NProgressPosition.top;

  static const List<Color> _colorPalette = [
    Color(0xFF2997FF), // Signature Blue
    Color(0xFFFF2D55), // Vibrant Coral
    Color(0xFF34C759), // Emerald
    Color(0xFFAF52DE), // Royal Purple
    Color(0xFFFF9500), // Amber
  ];

  static const Gradient _sampleGradient = LinearGradient(
    colors: [
      Color(0xFF007AFF),
      Color(0xFF00C6FF),
      Color(0xFF00E5FF),
    ],
  );

  void _applyConfiguration() {
    NProgress.configure(NProgressOptions(
      color: _selectedColor,
      gradient: _useGradient ? _sampleGradient : null,
      height: _barHeight,
      showSpinner: _showSpinner,
      showPeg: _showPeg,
      trickle: _trickle,
      position: _position,
    ));
  }

  void _simulateNetworkTask() async {
    NProgress.start();
    await Future.delayed(const Duration(milliseconds: 300));
    NProgress.inc(0.25);
    await Future.delayed(const Duration(milliseconds: 400));
    NProgress.set(0.65);
    await Future.delayed(const Duration(milliseconds: 350));
    NProgress.inc(0.2);
    await Future.delayed(const Duration(milliseconds: 250));
    NProgress.done();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NProgress Flutter Demo'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              NProgress.remove();
            },
            tooltip: 'Reset NProgress',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Banner
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.speed_rounded,
                          size: 48,
                          color: Color(0xFF2997FF),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'nprogress_flutter',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Slim, smooth, and customizable top progress bar for Flutter apps.\nInspired by Rico Sta. Cruz\'s NProgress.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Control Action Buttons
                Text(
                  'API Action Controls',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => NProgress.start(),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('start()'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007AFF),
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => NProgress.set(0.5),
                      icon: const Icon(Icons.tune),
                      label: const Text('set(0.5)'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => NProgress.inc(),
                      icon: const Icon(Icons.add),
                      label: const Text('inc()'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => NProgress.done(),
                      icon: const Icon(Icons.check),
                      label: const Text('done()'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => NProgress.remove(),
                      icon: const Icon(Icons.close),
                      label: const Text('remove()'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _simulateNetworkTask,
                      icon: const Icon(Icons.cloud_download),
                      label: const Text('Simulate Fetch'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade600,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Live Customization Controls
                Text(
                  'Live Styling & Behavior Options',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Color Picker
                        Text('Theme Accent Color', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ..._colorPalette.map((color) {
                              final isSelected = !_useGradient && _selectedColor == color;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _useGradient = false;
                                    _selectedColor = color;
                                    _applyConfiguration();
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: isSelected
                                        ? Border.all(color: Colors.white, width: 3)
                                        : null,
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(width: 8),
                            FilterChip(
                              label: const Text('Gradient Bar'),
                              selected: _useGradient,
                              onSelected: (val) {
                                setState(() {
                                  _useGradient = val;
                                  _applyConfiguration();
                                });
                              },
                            ),
                          ],
                        ),
                        const Divider(height: 32),

                        // Height Slider
                        Row(
                          children: [
                            Expanded(
                              child: Text('Bar Height: ${_barHeight.toStringAsFixed(1)} px'),
                            ),
                            Expanded(
                              flex: 2,
                              child: Slider(
                                value: _barHeight,
                                min: 1.0,
                                max: 10.0,
                                divisions: 18,
                                label: '${_barHeight.toStringAsFixed(1)}px',
                                onChanged: (val) {
                                  setState(() {
                                    _barHeight = val;
                                    _applyConfiguration();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 32),

                        // Feature Toggles
                        SwitchListTile(
                          title: const Text('Show Corner Spinner'),
                          subtitle: const Text('Displays rotating loading spinner in the corner'),
                          value: _showSpinner,
                          onChanged: (val) {
                            setState(() {
                              _showSpinner = val;
                              _applyConfiguration();
                            });
                          },
                        ),
                        SwitchListTile(
                          title: const Text('Show Peg Glow Shadow'),
                          subtitle: const Text('Adds glowing light effect to the tip of progress bar'),
                          value: _showPeg,
                          onChanged: (val) {
                            setState(() {
                              _showPeg = val;
                              _applyConfiguration();
                            });
                          },
                        ),
                        SwitchListTile(
                          title: const Text('Auto-Trickle Progress'),
                          subtitle: const Text('Automatically increments progress periodically'),
                          value: _trickle,
                          onChanged: (val) {
                            setState(() {
                              _trickle = val;
                              _applyConfiguration();
                            });
                          },
                        ),
                        ListTile(
                          title: const Text('Bar Position'),
                          subtitle: Text(_position == NProgressPosition.top ? 'Top of Screen' : 'Bottom of Screen'),
                          trailing: SegmentedButton<NProgressPosition>(
                            segments: const [
                              ButtonSegment(
                                value: NProgressPosition.top,
                                label: Text('Top'),
                              ),
                              ButtonSegment(
                                value: NProgressPosition.bottom,
                                label: Text('Bottom'),
                              ),
                            ],
                            selected: {_position},
                            onSelectionChanged: (set) {
                              setState(() {
                                _position = set.first;
                                _applyConfiguration();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Navigation Test Section
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.navigate_next),
                    title: const Text('Test Route Navigation Observer'),
                    subtitle: const Text('Pushing a route automatically triggers NProgress!'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SecondPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              'Route Transition Completed!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
