// ignore_for_file: implementation_imports

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

FakeAnalytics getInitializedFakeAnalytics({required String surveyContent}) {
  final fs = MemoryFileSystem.test();
  final homeDirectory = fs.directory('/');
  final fakeSurveyHandler = FakeSurveyHandler.fromString(
    homeDirectory: homeDirectory,
    fs: fs,
    content: surveyContent,
  );

  // Necessary for the initialization logic
  final Analytics initializationAnalytics = FakeAnalytics(
    tool: DashTool.flutterTool,
    homeDirectory: homeDirectory,
    dartVersion: 'dartVersion',
    platform: DevicePlatform.macos,
    flutterChannel: 'beta',
    flutterVersion: 'flutterVersion',
    fs: fs,
    surveyHandler: FakeSurveyHandler.fromList(
      homeDirectory: homeDirectory,
      fs: fs,
      initializedSurveys: [],
    ),
  );
  initializationAnalytics.clientShowedMessage();

  return FakeAnalytics(
    tool: DashTool.flutterTool,
    homeDirectory: homeDirectory,
    dartVersion: 'dartVersion',
    platform: DevicePlatform.macos,
    flutterChannel: 'beta',
    flutterVersion: 'flutterVersion',
    fs: fs,
    surveyHandler: fakeSurveyHandler,
  );
}
