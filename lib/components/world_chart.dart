import 'package:covidapp/services/api_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WorldChart extends StatelessWidget{
  final List<CovidDataWorld> chartData;
  final TooltipBehavior toolTip;

  final String startDate;
  final String endDate;

  WorldChart({required this.chartData, required this.toolTip, required this.startDate, required this.endDate});
  //maybe do some dots in points at chart

  List<CovidDataWorld> calculate(){
    List<CovidDataWorld> list = [];
    for(int i=chartData.length-1;i>=0;i--){
      if(i==chartData.length-1) {
        list.add(CovidDataWorld(totalConfirmed: chartData[i].totalConfirmed, totalDeaths: chartData[i].totalDeaths, totalRecovered: chartData[i].totalRecovered, lastUpdated: DateFormat('yyyy-MM-dd').format(DateTime.parse(chartData[i].lastUpdated))));
      } else{
        list.add(CovidDataWorld(totalConfirmed: (chartData[i].totalConfirmed-chartData[i+1].totalConfirmed), totalDeaths: (chartData[i].totalDeaths-chartData[i+1].totalDeaths), totalRecovered: chartData[i].totalRecovered-chartData[i+1].totalRecovered, lastUpdated: DateFormat('yyyy-MM-dd').format(DateTime.parse(chartData[i].lastUpdated))));
      }
    }
    return list;
  }

  late List<CovidDataWorld> newList = calculate();


  List<CovidDataWorld> filterData(){
    List<CovidDataWorld> list = [];
    DateTime startDateFormat = DateFormat('yyyy-MM-dd').parse(startDate);
    DateTime endDateFormat = DateFormat('yyyy-MM-dd').parse(endDate);

    int difference = endDateFormat.difference(startDateFormat).inDays;

    for(int i=0; i<newList.length;i++){
      if(newList[i].lastUpdated.toString()==startDate){
        for(int j=0;j<=difference;j++){
          list.add(CovidDataWorld(totalConfirmed: newList[i+j].totalConfirmed, totalDeaths: newList[i+j].totalDeaths, totalRecovered: newList[i+j].totalRecovered, lastUpdated: newList[i+j].lastUpdated));
        }
      }
    }
    return list;
  }

  late List<CovidDataWorld> filteredList = filterData();


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
      child: Column(
        children: [
          Center(child: SfCartesianChart(
            primaryXAxis: CategoryAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
            primaryYAxis: NumericAxis(),
            title: ChartTitle(text: "Dane COVID - Świat"),
            legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
            ),
            tooltipBehavior: toolTip,
            series: <ChartSeries>[
              LineSeries<CovidDataWorld, String>(
                name: 'potwierdzone',
                dataSource: filteredList,
                xValueMapper: (CovidDataWorld date, _) => date.lastUpdated,
                yValueMapper: (CovidDataWorld infections, _) => infections.totalConfirmed,
                enableTooltip: true,
              ),
              LineSeries<CovidDataWorld, String>(
                name: 'zgony',
                dataSource: filteredList,
                xValueMapper: (CovidDataWorld date, _) => date.lastUpdated,
                yValueMapper: (CovidDataWorld deaths, _) => deaths.totalDeaths,
                enableTooltip: true,
              ),
              LineSeries<CovidDataWorld, String>(
                name: 'uzdrowieni',
                dataSource: filteredList,
                xValueMapper: (CovidDataWorld date, _) => date.lastUpdated,
                yValueMapper: (CovidDataWorld recovered, _) => recovered.totalRecovered,
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
