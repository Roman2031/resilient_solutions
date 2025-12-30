import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kindomcall/features/actions/widgets/action_filter_chips.dart';

void main() {
  group('ActionFilterChips Widget', () {
    testWidgets('should display all filter options', (WidgetTester tester) async {
      String selectedFilter = 'all';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionFilterChips(
              selectedFilter: selectedFilter,
              onFilterChanged: (filter) {},
            ),
          ),
        ),
      );

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('In Progress'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
    });

    testWidgets('should display icons for each filter', (WidgetTester tester) async {
      String selectedFilter = 'all';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionFilterChips(
              selectedFilter: selectedFilter,
              onFilterChanged: (filter) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.list), findsOneWidget);
      expect(find.byIcon(Icons.pending), findsOneWidget);
      expect(find.byIcon(Icons.update), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should highlight selected filter', (WidgetTester tester) async {
      String selectedFilter = 'pending';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionFilterChips(
              selectedFilter: selectedFilter,
              onFilterChanged: (filter) {},
            ),
          ),
        ),
      );

      // Find the pending filter chip
      final pendingChip = find.ancestor(
        of: find.text('Pending'),
        matching: find.byType(FilterChip),
      );
      
      expect(pendingChip, findsOneWidget);
    });

    testWidgets('should call onFilterChanged when chip is tapped',
        (WidgetTester tester) async {
      String selectedFilter = 'all';
      String? changedTo;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionFilterChips(
              selectedFilter: selectedFilter,
              onFilterChanged: (filter) {
                changedTo = filter;
              },
            ),
          ),
        ),
      );

      // Tap on the Pending chip
      await tester.tap(find.text('Pending'));
      await tester.pump();

      expect(changedTo, 'pending');
    });

    testWidgets('should be scrollable horizontally', (WidgetTester tester) async {
      String selectedFilter = 'all';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionFilterChips(
              selectedFilter: selectedFilter,
              onFilterChanged: (filter) {},
            ),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should update selection when tapping different chips',
        (WidgetTester tester) async {
      String selectedFilter = 'all';

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: ActionFilterChips(
                  selectedFilter: selectedFilter,
                  onFilterChanged: (filter) {
                    setState(() {
                      selectedFilter = filter;
                    });
                  },
                ),
              );
            },
          ),
        ),
      );

      // Initially 'all' is selected
      expect(selectedFilter, 'all');

      // Tap on Completed
      await tester.tap(find.text('Completed'));
      await tester.pump();

      expect(selectedFilter, 'completed');
    });
  });
}
