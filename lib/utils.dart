// ignore_for_file: implementation_imports

import 'dart:io';

import 'package:file/memory.dart';
import 'package:http/http.dart' as http;
import 'package:unified_analytics/src/constants.dart';
import 'package:unified_analytics/src/enums.dart';
import 'package:unified_analytics/src/survey_handler.dart';
import 'package:unified_analytics/unified_analytics.dart';

Future<String> fetchContents() async {
  final uri = Uri.parse(kContextualSurveyUrl);
  final response = await http.get(uri);
  return response.body;
}

bool foundSurvey(String surveyId, List<Survey> surveysFetched) {
  for (final survey in surveysFetched) {
    if (survey.uniqueId == surveyId) return true;
  }
  return false;
}

FakeAnalytics getInitializedFakeAnalytics({
  required String surveyContent,
  required DashTool tool,
  required String flutterChannel,
  required String flutterVersion,
  required String dartVersion,
  required MemoryFileSystem fs,
}) {
  final homeDirectory = fs.directory('/');
  final fakeSurveyHandler = FakeSurveyHandler.fromString(
    homeDirectory: homeDirectory,
    fs: fs,
    content: surveyContent,
  );
  final devicePlatform = DevicePlatform.linux;

  // Necessary for the initialization logic
  final initializationAnalytics = FakeAnalytics(
    tool: tool,
    homeDirectory: homeDirectory,
    dartVersion: dartVersion,
    platform: devicePlatform,
    flutterChannel: flutterChannel,
    flutterVersion: flutterVersion,
    fs: fs,
    surveyHandler: FakeSurveyHandler.fromList(
      homeDirectory: homeDirectory,
      fs: fs,
      initializedSurveys: [],
    ),
  );
  initializationAnalytics.clientShowedMessage();

  return FakeAnalytics(
    tool: tool,
    homeDirectory: homeDirectory,
    dartVersion: dartVersion,
    platform: devicePlatform,
    flutterChannel: flutterChannel,
    flutterVersion: flutterVersion,
    fs: fs,
    surveyHandler: fakeSurveyHandler,
  );
}

void printProgressBar(int current, int total, int barLength) {
  final percentage = current / total;
  final progressLength = (percentage * barLength).floor();
  final remainingLength = barLength - progressLength;

  stdout.write('[');
  stdout.write('=' * progressLength);
  stdout.write(' ' * remainingLength);
  stdout.write('] ${(percentage * 100).toStringAsFixed(2)}%');
  stdout.write('\r'); // Move the cursor back to the beginning of the line.
}
