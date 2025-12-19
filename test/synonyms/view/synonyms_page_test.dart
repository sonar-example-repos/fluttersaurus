import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersaurus/synonyms/synonyms.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thesaurus_repository/thesaurus_repository.dart';

class MockThesaurusRepository extends Mock implements ThesaurusRepository {}

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    return '{}';
  }

  @override
  Future<ByteData> load(String key) async {
    return ByteData(0);
  }
}

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;

  group('SynonymsPage', () {
    const word = 'flutter';
    late ThesaurusRepository thesaurusRepository;

    setUp(() {
      thesaurusRepository = MockThesaurusRepository();
      when(() => thesaurusRepository.synonyms(word: any(named: 'word')))
          .thenAnswer((_) async => const <String>[]);
    });

    testWidgets('renders a SynonymsView', (tester) async {
      await tester.pumpWidget(
        DefaultAssetBundle(
          bundle: TestAssetBundle(),
          child: RepositoryProvider.value(
            value: thesaurusRepository,
            child: MaterialApp(
              onGenerateRoute: (_) => SynonymsPage.route(word: word),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SynonymsView), findsOneWidget);
    });

    testWidgets('requests synonyms', (tester) async {
      await tester.pumpWidget(
        DefaultAssetBundle(
          bundle: TestAssetBundle(),
          child: RepositoryProvider.value(
            value: thesaurusRepository,
            child: MaterialApp(
              onGenerateRoute: (_) => SynonymsPage.route(word: word),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      verify(() => thesaurusRepository.synonyms(word: word)).called(1);
    });
  });
}
