import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kindomcall/features/admin_portal/widgets/stat_card.dart';

void main() {
  group('StatCard Widget', () {
    testWidgets('should display title and value', (WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: StatCard(
                title: 'Total Users',
                value: '100',
                icon: Icons.people,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Total Users'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
      expect(find.byIcon(Icons.people), findsOneWidget);
    });

    testWidgets('should display trend when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: StatCard(
                title: 'Total Users',
                value: '100',
                icon: Icons.people,
                trend: '+5.5%',
                isTrendPositive: true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('+5.5%'), findsOneWidget);
      expect(find.byIcon(Icons.trending_up), findsOneWidget);
    });

    testWidgets('should display negative trend', (WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: StatCard(
                title: 'Active Users',
                value: '80',
                icon: Icons.people,
                trend: '-2.0%',
                isTrendPositive: false,
              ),
            ),
          ),
        ),
      );

      expect(find.text('-2.0%'), findsOneWidget);
      expect(find.byIcon(Icons.trending_down), findsOneWidget);
    });

    testWidgets('should call onTap when card is tapped', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: StatCard(
                title: 'Total Users',
                value: '100',
                icon: Icons.people,
                onTap: () => tapped = true,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(StatCard));
      await tester.pumpAndSettle();

      expect(tapped, true);
    });
  });
}
