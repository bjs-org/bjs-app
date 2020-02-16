import 'dart:async';

import 'package:bjs/models/models.dart';
import 'package:bjs/states/states.dart';
import 'package:bjs/widgets/classes/class_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockClassFormNotifier extends Mock implements ClassFormNotifier {}

class MockClassesNotifier extends Mock implements ClassesNotifier {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group("class form", () {
    testWidgets('new class heading', (WidgetTester tester) async {
      final mock = MockClassFormNotifier();
      when(mock.existed).thenReturn(false);

      await tester.pumpWidget(buildTestableWidget(
        ChangeNotifierProvider<ClassFormNotifier>.value(
            value: mock, child: ClassForm()),
      ));

      expect(find.text("Neue Klasse erstellen"), findsOneWidget);
    });

    testWidgets('edit class heading', (WidgetTester tester) async {
      final mock = MockClassFormNotifier();
      when(mock.existed).thenReturn(true);

      await tester.pumpWidget(buildTestableWidget(
        ChangeNotifierProvider<ClassFormNotifier>.value(
            value: mock, child: ClassForm()),
      ));

      expect(find.text("Klasse bearbeiten"), findsOneWidget);
    });

    testWidgets('saves values', (WidgetTester tester) async {
      final formMock = MockClassFormNotifier();
      final classesMock = MockClassesNotifier();
      final schoolClass = SchoolClass();

      when(formMock.existed).thenReturn(true);
      when(formMock.schoolClass).thenReturn(schoolClass);
      when(formMock.send()).thenAnswer((_) => Completer<void>().future);

      await tester.pumpWidget(buildTestableWidget(MultiProvider(providers: [
        ChangeNotifierProvider<ClassFormNotifier>.value(value: formMock),
        ChangeNotifierProvider<ClassesNotifier>.value(value: classesMock)
      ], child: ClassForm())));

      await tester.enterText(find.byKey(Key("gradeFormField")), "7");
      await tester.enterText(find.byKey(Key("classFormField")), "A");
      await tester.enterText(find.byKey(Key("teacherFormField")), "Gutsche");

      await tester.tap(find.byIcon(Icons.send));

      expect(schoolClass.grade, equals("7"));
      expect(schoolClass.name, equals("A"));
      expect(schoolClass.teacherName, equals("Gutsche"));
    });

    testWidgets('exits correctly', (WidgetTester tester) async {
      final formMock = MockClassFormNotifier();
      final classesMock = MockClassesNotifier();
      final mockObserver = MockNavigatorObserver();
      final schoolClass = SchoolClass();

      when(formMock.existed).thenReturn(true);
      when(formMock.schoolClass).thenReturn(schoolClass);

      await tester.pumpWidget(MaterialApp(
        home: buildTestableWidget(
          MultiProvider(providers: [
            ChangeNotifierProvider<ClassFormNotifier>.value(value: formMock),
            ChangeNotifierProvider<ClassesNotifier>.value(value: classesMock)
          ], child: ClassForm()),
        ),
        navigatorObservers: [mockObserver],
      ));

      await tester.tap(find.byIcon(Icons.send));

      verify(formMock.send());
      verify(classesMock.updateClasses());
      verify(mockObserver.didPush(any, any));
    });
  });
}

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
}
