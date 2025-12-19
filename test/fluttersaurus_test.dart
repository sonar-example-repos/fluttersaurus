import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersaurus/fluttersaurus.dart';
import 'package:fluttersaurus/search/search.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thesaurus_repository/thesaurus_repository.dart';

class MockThesaurusRepository extends Mock implements ThesaurusRepository {}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('Fluttersaurus', () {
    testWidgets('renders SearchPage when thesaurusRepository is not null',
        (tester) async {
      await tester.pumpWidget(
        Fluttersaurus(
          thesaurusRepository: MockThesaurusRepository(),
        ),
      );
      expect(find.byType(SearchPage), findsOneWidget);
    });
  });
}
