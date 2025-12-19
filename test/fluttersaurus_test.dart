import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersaurus/fluttersaurus.dart';
import 'package:fluttersaurus/search/search.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thesaurus_repository/thesaurus_repository.dart';

class MockThesaurusRepository extends Mock implements ThesaurusRepository {}

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (key == 'AssetManifest.json') {
      return '{}';
    }
    return '{}';
  }

  @override
  Future<ByteData> load(String key) async {
    return ByteData(0);
  }
}

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;

  group('Fluttersaurus', () {
    testWidgets('renders SearchPage when thesaurusRepository is not null',
        (tester) async {
      await tester.pumpWidget(
        DefaultAssetBundle(
          bundle: TestAssetBundle(),
          child: Fluttersaurus(
            thesaurusRepository: MockThesaurusRepository(),
          ),
        ),
      );
      expect(find.byType(SearchPage), findsOneWidget);
    });
  });
}
