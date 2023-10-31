// ignore_for_file: implementation_imports

import 'package:clock/clock.dart';
import 'package:file/memory.dart';
import 'package:unified_analytics/unified_analytics.dart';

import 'utils.dart';

void run() async {
  var countOfSuccesses = 0;
  final iterations = 1000;

  final remoteContent = await fetchContents();

  for (var i = 0; i < iterations; i++) {
    print('${i + 1} out of $iterations...');
    final simulatedStartDateTime = DateTime(2023, 11, 11);
    final fs = MemoryFileSystem.test();
    final homeDirectory = fs.directory('/');

    await withClock(Clock.fixed(simulatedStartDateTime), () async {
      final analytics = getInitializedFakeAnalytics(
        fs: fs,
        homeDirectory: homeDirectory,
        surveyContent: remoteContent,
      );

      for (var i = 0; i < 50; i++) {
        analytics.send(Event.analyticsCollectionEnabled(status: false));
      }

      final surveysFetched = await analytics.fetchAvailableSurveys();
      if (surveysFetched.isNotEmpty) countOfSuccesses += 1;
    });
  }

  print('\n\n'
      '--------\n'
      'Count of successes: $countOfSuccesses\n'
      'Total number of iterations: $iterations\n'
      'Rate: '
      '${((countOfSuccesses / iterations) * 100).toStringAsFixed(3)}%');
}
