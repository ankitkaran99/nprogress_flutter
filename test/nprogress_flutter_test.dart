import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nprogress_flutter/nprogress_flutter.dart';

void main() {
  group('NProgressController Tests', () {
    late NProgressController controller;

    setUp(() {
      controller = NProgressController();
    });

    tearDown(() {
      if (!controller.isDisposed) {
        controller.dispose();
      }
    });

    test('Initial state is unstarted and null status', () {
      expect(controller.status, isNull);
      expect(controller.isStarted, isFalse);
      expect(controller.isRendered, isFalse);
    });

    test('start() initializes progress to minimum option', () {
      controller.start();
      expect(controller.isStarted, isTrue);
      expect(controller.isRendered, isTrue);
      expect(controller.status, equals(controller.options.minimum));
    });

    test('set() sets progress clamped between 0.0 and 1.0', () {
      controller.set(0.5);
      expect(controller.status, equals(0.5));

      controller.set(-0.2);
      expect(controller.status, equals(0.0));

      controller.set(1.5);
      expect(controller.status, equals(1.0));
    });

    test('inc() increases progress', () {
      controller.start();
      final initial = controller.status!;
      controller.inc(0.2);
      expect(controller.status, greaterThan(initial));
    });

    test('done() completes progress to 1.0', () {
      controller.start();
      controller.done();
      expect(controller.status, equals(1.0));
    });

    test('remove() resets state', () {
      controller.start();
      controller.remove();
      expect(controller.status, isNull);
      expect(controller.isStarted, isFalse);
    });

    test('configure updates options', () {
      controller.configure(const NProgressOptions(
        color: Colors.red,
        height: 5.0,
      ));
      expect(controller.options.color, equals(Colors.red));
      expect(controller.options.height, equals(5.0));
    });

    test('disposed controller safely ignores calls without throwing', () {
      controller.dispose();
      expect(controller.isDisposed, isTrue);
      expect(() => controller.start(), returnsNormally);
      expect(() => controller.set(0.5), returnsNormally);
      expect(() => controller.done(), returnsNormally);
    });
  });

  group('NProgressOptions Tests', () {
    test('NProgressOptions equality and copyWith', () {
      const opt1 = NProgressOptions(height: 4.0, color: Colors.blue);
      const opt2 = NProgressOptions(height: 4.0, color: Colors.blue);
      final opt3 = opt1.copyWith(height: 6.0);

      expect(opt1, equals(opt2));
      expect(opt1.hashCode, equals(opt2.hashCode));
      expect(opt3.height, equals(6.0));
      expect(opt3.color, equals(Colors.blue));
    });
  });

  group('NProgress Singleton Facade Tests', () {
    tearDown(() {
      NProgress.remove();
    });

    test('NProgress.run wraps async tasks with start and done', () async {
      final result = await NProgress.run(() async {
        expect(NProgress.isStarted, isTrue);
        await Future.delayed(const Duration(milliseconds: 10));
        return 42;
      });

      expect(result, equals(42));
      expect(NProgress.status, equals(1.0));
    });

    test('NProgress static facade delegates to default controller', () {
      NProgress.start();
      expect(NProgress.isStarted, isTrue);
      expect(NProgress.status, equals(0.08));

      NProgress.set(0.6);
      expect(NProgress.status, equals(0.6));

      NProgress.inc(0.1);
      expect(NProgress.status, closeTo(0.7, 0.001));

      NProgress.done();
      expect(NProgress.status, equals(1.0));

      NProgress.remove();
      expect(NProgress.isStarted, isFalse);
    });
  });

  group('NProgress Widget & Overlay Tests', () {
    testWidgets('NProgressOverlay renders child and NProgressWidget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: NProgress.builder(),
          home: const Scaffold(
            body: Text('Hello NProgress'),
          ),
        ),
      );

      expect(find.text('Hello NProgress'), findsOneWidget);
      expect(find.byType(NProgressWidget), findsOneWidget);

      NProgress.start();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(NProgress.isStarted, isTrue);

      NProgress.done();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
    });

    testWidgets('NProgressWidget shows spinner when enabled', (WidgetTester tester) async {
      final controller = NProgressController(
        options: const NProgressOptions(showSpinner: true),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NProgressWidget(controller: controller),
          ),
        ),
      );

      controller.start();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      controller.dispose();
    });
  });
}
