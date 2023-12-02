import 'dart:convert';
import 'dart:io';

num getHighestAmount(String line, String color) {
  final pattern = RegExp('\(\\d+\) ${color}');
  final matches = pattern.allMatches(line);
  final counts = matches.map((e) => int.parse(e.group(1) ?? "0"));
  return counts.fold(0, (prev, curr) => curr > prev ? curr : prev);
}

num part1AnswerForLine(String line, {debug = false}) {
  final id = int.parse(RegExp(r'Game (\d+)').firstMatch(line)?.group(1) ?? "");
  final redsAmount = getHighestAmount(line, 'red');
  final bluesAmount = getHighestAmount(line, 'blue');
  final greensAmount = getHighestAmount(line, 'green');

  final isValidGame =
      redsAmount <= 12 && greensAmount <= 13 && bluesAmount <= 14;

  if (debug)
    print(
        'Checking for $line\tid: $id red: $redsAmount green: $greensAmount blues: $bluesAmount\tvalid: $isValidGame');
  return isValidGame ? id : 0;
}

num part2AnswerForLine(String line) {
  final redsAmount = getHighestAmount(line, 'red');
  final bluesAmount = getHighestAmount(line, 'blue');
  final greensAmount = getHighestAmount(line, 'green');

  return redsAmount * bluesAmount * greensAmount;
}

Future<void> main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print("Provide input filename. Leaving.");
    return;
  }

  final filePath = arguments.first;
  final file = File(filePath);

  if (!file.existsSync()) {
    print('The file at path: $filePath does not exist. Leaving.');
    return;
  }

  Stream<String> lines =
      file.openRead().transform(utf8.decoder).transform(LineSplitter());

  try {
    final result = await lines
        .map((line) => part2AnswerForLine(line))
        .reduce((a, b) => a + b);
    print('Result for part: $result');
  } catch (e) {
    print('Error: $e');
  }
}
