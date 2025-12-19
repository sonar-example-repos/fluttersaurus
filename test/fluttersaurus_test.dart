import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersaurus/fluttersaurus.dart';
import 'package:fluttersaurus/search/search.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thesaurus_repository/thesaurus_repository.dart';

class MockThesaurusRepository extends Mock implements ThesaurusRepository {}

ByteData _createEmptyAssetManifestBin() {
  final buffer = WriteBuffer();
  const StandardMessageCodec().writeValue(buffer, <String, dynamic>{});
  return buffer.done();
}

// Minimal valid 1x1 transparent PNG
final _kTransparentPng = Uint8List.fromList([
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);

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
      if (key.endsWith('.png') || key.endsWith('.jpg') || key.endsWith('.jpeg')) {
        return ByteData.sublistView(_kTransparentPng);
      }
      return ByteData.sublistView(utf8.encode('{}'));
    });
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
