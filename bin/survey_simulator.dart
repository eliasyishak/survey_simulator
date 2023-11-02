import 'package:survey_simulator/survey_simulator.dart';
import 'package:unified_analytics/unified_analytics.dart';

void functionToRun(FakeAnalytics analyticsInstance) {
  for (var i = 0; i < 50; i++) {
    analyticsInstance.send(Event.analyticsCollectionEnabled(status: false));
  }
}

void main(List<String> arguments) async {
  final remoteContent = await fetchContents();

  final simulator = Simulator(
    label: 'Running on flutter beta channel',
    surveyId: 'd27d24da-f789-45e3-83af-7ebaeade75c1',
    simulationDateTime: DateTime.now(),
    tool: DashTool.dartTool,
    flutterChannel: 'beta',
    flutterVersion: 'flutterVersion',
    dartVersion: 'dartVersion',
    sendFunction: functionToRun,
    iterations: 100,
    remoteContent: remoteContent,
  );

  print(await simulator.run());
}
