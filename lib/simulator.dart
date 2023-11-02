import 'package:clock/clock.dart';
import 'package:unified_analytics/unified_analytics.dart';

import 'utils.dart';

typedef SendFunction = void Function(FakeAnalytics analyticsInstance);

class SimulationResult {
  final String label;
  final String surveyId;
  final int countOfSuccesses;
  final int iterations;

  /// Dataclass that contains the results from a simulation run.
  SimulationResult({
    required this.label,
    required this.surveyId,
    required this.countOfSuccesses,
    required this.iterations,
  });

  @override
  String toString() => 'Result for simulator: "$label"\n'
      'Tested survey id: "$surveyId"\n'
      'Number of successes: $countOfSuccesses\n'
      'Total number of iterations (clients) per run: $iterations\n'
      'Success rate: '
      '${((countOfSuccesses / iterations) * 100).toStringAsFixed(3)}%\n';
}

class Simulator {
  final DateTime simulationDateTime;
  final String remoteContent;
  final DashTool tool;
  final String flutterChannel;
  final String flutterVersion;
  final String dartVersion;
  final int iterations;
  final String label;

  /// This string represents that survey we want to simulate for.
  ///
  /// It will be what we look for when we use the
  /// [Analytics.fetchAvailableSurveys] method to fetch a list
  /// of surveys that met the conditions.
  final String surveyId;

  int countOfSuccesses = 0;

  /// The function that should run that will be sending the
  /// events for each instance of the simulator.
  ///
  /// The example below shows an example that be passed:
  /// ```dart
  /// void functionToRun() {
  ///   for (var i = 0; i < 50; i++) {
  ///     analytics.send(Event.analyticsCollectionEnabled(status: false));
  ///   }
  /// }
  /// ```
  final SendFunction sendFunction;

  Simulator({
    required this.label,
    required this.simulationDateTime,
    required this.tool,
    required this.flutterChannel,
    required this.flutterVersion,
    required this.dartVersion,
    required this.sendFunction,
    required this.remoteContent,
    required this.iterations,
    required this.surveyId,
  });

  Future<SimulationResult> run() async {
    countOfSuccesses = 0;

    for (var i = 0; i < iterations; i++) {
      // print('[$label] ${i + 1} out of $iterations...');

      await withClock(Clock.fixed(simulationDateTime), () async {
        final analytics =
            getInitializedFakeAnalytics(surveyContent: remoteContent);

        sendFunction(analytics);

        final surveysFetched = await analytics.fetchAvailableSurveys();
        if (surveysFetched.isNotEmpty &&
            foundSurvey(surveyId, surveysFetched)) {
          countOfSuccesses += 1;
        }
      });
    }

    return SimulationResult(
      label: label,
      surveyId: surveyId,
      countOfSuccesses: countOfSuccesses,
      iterations: iterations,
    );
  }
}
