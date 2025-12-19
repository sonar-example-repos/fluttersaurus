import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersaurus/synonyms/synonyms.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thesaurus_repository/thesaurus_repository.dart';

class MockThesaurusRepository extends Mock implements ThesaurusRepository {}

ByteData _createEmptyAssetManifestBin() {
  final buffer = WriteBuffer();
  const StandardMessageCodec().writeValue(buffer, <String, dynamic>{});
  return buffer.done();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (message) async {
      final key = utf8.decode(message!.buffer.asUint8List());
      if (key.contains('AssetManifest.bin')) {
        return _createEmptyAssetManifestBin();
      }
      return ByteData.sublistView(utf8.encode('{}'));
    });
  });

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
        RepositoryProvider.value(
          value: thesaurusRepository,
          child: MaterialApp(
            onGenerateRoute: (_) => SynonymsPage.route(word: word),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SynonymsView), findsOneWidget);
    });

    testWidgets('requests synonyms', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: thesaurusRepository,
          child: MaterialApp(
            onGenerateRoute: (_) => SynonymsPage.route(word: word),
          ),
        ),
      );
      await tester.pumpAndSettle();
      verify(() => thesaurusRepository.synonyms(word: word)).called(1);
    });
  });
}
