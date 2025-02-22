import 'package:bishop/bishop.dart';

bool isNumeric(String s) {
  return RegExp(r'^-?[0-9]+$').hasMatch(s);
}

bool isAlpha(String str) {
  return RegExp(r'^[a-zA-Z]+$').hasMatch(str);
}

String replaceMultiple(
  String source,
  List<String> originals,
  List<String> replacements,
) {
  assert(originals.length == replacements.length);
  String output = source;
  for (int i = 0; i < originals.length; i++) {
    output = output.replaceAll(originals[i], replacements[i]);
  }
  return output;
}

bool validateFen({
  required Variant variant,
  required String fen,
  bool strict = false,
}) {
  try {
    Game g = Game(variant: variant);
    g.loadFen(fen, strict);
  } catch (e) {
    print('$e ($fen)');
    return false;
  }
  return true;
}

/// Looks up a built in variant by name.
Variant? variantFromString(String name) => Variants.values
    .firstWhereOrNull(
      (e) => e.name.toLowerCase() == name.toLowerCase().replaceAll(' ', ''),
    )
    ?.build();

/// Generates an ASCII representation of the board.
String boardToAscii(
  List<int> board, {
  bool unicode = false,
  BuiltVariant? variant,
}) {
  variant ??= BuiltVariant.standard();
  String border = '   +${'-' * (variant.boardSize.h * 3)}+';
  String output = '$border\n';
  for (int i in Iterable<int>.generate(variant.boardSize.v).toList()) {
    int rank = variant.boardSize.v - i;
    String rankStr = rank > 9 ? '$rank |' : ' $rank |';
    output = '$output$rankStr';
    for (int j in Iterable<int>.generate(variant.boardSize.h).toList()) {
      Square sq = board[i * variant.boardSize.h * 2 + j];
      String char = variant.pieces[sq.type].char(sq.colour);
      if (unicode && Bishop.unicodePieces.containsKey(char)) {
        char = Bishop.unicodePieces[char]!;
      }
      output = '$output $char ';
    }
    output = '$output|\n';
  }
  output = '$output$border\n     ';
  for (String i in Iterable<int>.generate(variant.boardSize.h)
      .map((e) => String.fromCharCode(e + 97))
      .toList()) {
    output = '$output$i  ';
  }
  return output;
}
