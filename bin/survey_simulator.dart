import 'package:file/file.dart';
import 'package:survey_simulator/survey_simulator.dart';
import 'package:unified_analytics/unified_analytics.dart';

void functionToRun(
  FakeAnalytics analyticsInstance,
  File logFile,
) {
  analyticsInstance.send(Event.analyticsCollectionEnabled(status: false));
  final currentLines = logFile.readAsLinesSync();

  // Iterate through to duplicate the first event found
  final newLines = [for (var i = 0; i < 1500; i++) ...currentLines];
  logFile.writeAsStringSync(newLines.join('\n'));
}

void main(List<String> arguments) async {
  final remoteContent = await fetchContents();

  final simulator = Simulator(
      label: 'Running on flutter beta channel',
      surveyId: 'd27d24da-f789-45e3-83af-7ebaeade75c1',
      simulationDateTime: DateTime.now(),
      iterations: 1500,
      remoteContent: remoteContent,
      instanceParameters: [
        InstanceParameters(
          tool: DashTool.dartTool,
          flutterChannel: 'beta',
          flutterVersion: 'flutterVersion',
          dartVersion: 'dartVersion',
          sendFunction: functionToRun,
        ),
      ]);

  print(await simulator.run());
}
