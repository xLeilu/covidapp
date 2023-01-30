import 'package:covidapp/services/api_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PolandChart extends StatelessWidget{
  final List<CovidData> chartData;
  final TooltipBehavior toolTip;
  final String title;

  const PolandChart({required this.chartData, required this.toolTip, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
      child: Column(
        children: [
          Center(child: SfCartesianChart(
            primaryXAxis: CategoryAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
            primaryYAxis: NumericAxis(),
            title: ChartTitle(text: "Dane COVID - "+ title),
            legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
            ),
            tooltipBehavior: toolTip,
            series: <ChartSeries>[
              LineSeries<CovidData, String>(
                  name: 'potwierdzone',
                  dataSource: chartData,
                  xValueMapper: (CovidData date, _) => DateFormat('dd-MM-yyyy').format(DateTime.parse(date.last_updated)),
                  yValueMapper: (CovidData infections, _) => infections.new_infections,
                  enableTooltip: true,
              ),
              LineSeries<CovidData, String>(
                name: 'zgony',
                dataSource: chartData,
                xValueMapper: (CovidData date, _) => DateFormat('dd-MM-yyyy').format(DateTime.parse(date.last_updated)),
                yValueMapper: (CovidData deaths, _) => deaths.new_deaths,
                enableTooltip: true,
              ),
              LineSeries<CovidData, String>(
                name: 'uzdrowieni',
                dataSource: chartData,
                xValueMapper: (CovidData date, _) => DateFormat('dd-MM-yyyy').format(DateTime.parse(date.last_updated)),
                yValueMapper: (CovidData recovered, _) => recovered.new_recovered,
                enableTooltip: true,
              ),
            ],
          ),
          ),
        ],
      ),
    );
  }
}
