import 'package:covidapp/components/poland_chart.dart';
import 'package:flutter/material.dart';
import 'package:covidapp/services/api_manager.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'components/world_chart.dart';

class Coutry {
  final String coutryName;
  final String coutryCode;
  final Image flag;

  const Coutry({
    required this.coutryName,
    required this.coutryCode,
    required this.flag,
  });
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<List<CovidData>> futureData;
  late TooltipBehavior tooltipBehavior;
  late Future<List<CovidDataWorld>> futureWorldData;
  late TooltipBehavior tooltipOthersBehavior;
  late String strDate;
  TextEditingController endDateInputPoland = TextEditingController();
  TextEditingController startDateInputPoland = TextEditingController();
  TextEditingController startDateInputWorld = TextEditingController();
  TextEditingController endDateInputWorld = TextEditingController();
  late Future<DailyPolandData> futureDailyPoland;
  late Future<DailyWorldData> futureDailyWorld;

  late String startDateWorld;
  late String endDateWorld;

  late DateTime startDatePoland;
  late DateTime endDatePoland;

  late String strStartDatePoland;
  late String strEndDatePoland;

  //here dropdown list
  final List<Coutry> _coutries = [
    Coutry(
        coutryName: 'Polska',
        coutryCode: 'PL',
        flag: Image.asset('assets/images/poland.png', fit: BoxFit.contain, height: 18)),
    Coutry(
        coutryName: 'USA',
        coutryCode: 'US',
        flag: Image.asset('assets/images/usa.png', fit: BoxFit.contain, height: 18)),
    Coutry(
        coutryName: 'Chiny',
        coutryCode: 'CN',
        flag: Image.asset('assets/images/china.png', fit: BoxFit.contain, height: 18)),
    Coutry(
        coutryName: 'Anglia',
        coutryCode: 'GB',
        flag: Image.asset('assets/images/uk.png', fit: BoxFit.contain, height: 18)),
    Coutry(
        coutryName: 'Niemcy',
        coutryCode: 'DE',
        flag: Image.asset('assets/images/germany.png', fit: BoxFit.contain, height: 18)),
    Coutry(
        coutryName: 'Francja',
        coutryCode: 'FR',
        flag: Image.asset('assets/images/france.png', fit: BoxFit.contain, height: 18)),
    Coutry(
        coutryName: 'Hiszpania',
        coutryCode: 'ES',
        flag: Image.asset('assets/images/spain.png', fit: BoxFit.contain, height: 18)),
    Coutry(
        coutryName: 'Szwecja',
        coutryCode: 'SE',
        flag: Image.asset('assets/images/sweden.png', fit: BoxFit.contain, height: 18)),
  ];

  String selectedItem = 'PL';

  @override
  void initState() {
    tooltipBehavior = TooltipBehavior(enable: true);
    tooltipOthersBehavior = TooltipBehavior(enable: true);

    endDateInputPoland.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    startDateInputPoland.text = DateFormat('yyy-MM-dd').format(DateTime(DateTime.now().year, DateTime.now().month - 1, DateTime.now().day));

    startDatePoland = DateFormat('yyyy-MM-dd').parse(startDateInputPoland.text);
    startDatePoland = DateTime(startDatePoland.year, startDatePoland.month, startDatePoland.day - 1);

    endDatePoland = DateFormat('yyyy-MM-dd').parse(endDateInputPoland.text);
    endDatePoland = DateTime(endDatePoland.year, endDatePoland.month, endDatePoland.day + 1);

    strStartDatePoland = DateFormat('yyyy-MM-dd').format(DateTime.parse(startDatePoland.toString()));
    strEndDatePoland = DateFormat('yyyy-MM-dd').format(DateTime.parse(endDatePoland.toString()));

    futureData = ApiManager().fetchData(strEndDatePoland, strStartDatePoland, selectedItem);

    endDateInputWorld.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    startDateInputWorld.text = DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year, DateTime.now().month - 1, DateTime.now().day));
    futureWorldData = ApiManager().fetchWorldData();
    futureDailyPoland = ApiManager().fetchDailyPoland(selectedItem);
    futureDailyWorld = ApiManager().fetchDailyWorld();

    startDateWorld = startDateInputWorld.text;
    endDateWorld = endDateInputWorld.text;

    super.initState();
  }

  String getName(String selectedCode) {
    String name = "";
    for (int i = 0; i < _coutries.length; i++) {
      if (_coutries[i].coutryCode == selectedCode) {
        name = _coutries[i].coutryName;
      }
    }
    return name;
  }

  Image getFlag(String selectedCode) {
    Image flag = Image.asset('assets/images/location.png');
    for (int i = 0; i < _coutries.length; i++) {
      if (_coutries[i].coutryCode == selectedCode) {
        flag = _coutries[i].flag;
      }
    }
    return flag;
  }

  /*
  String convertDate(String date){

  }
  */

  //PolandChart
  Widget futureBuilderPoland() {
    return FutureBuilder<List<CovidData>>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? PolandChart(
                  chartData: snapshot.data!,
                  toolTip: tooltipBehavior,
                  title: getName(selectedItem),
                )
              : const Center(child: CircularProgressIndicator());
        });
  }

  //Others Coutry Chart
  Widget futureBuilderWorld() {
    return FutureBuilder<List<CovidDataWorld>>(
        future: futureWorldData,
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? WorldChart(
                  chartData: snapshot.data!,
                  toolTip: tooltipOthersBehavior,
                  startDate: startDateWorld,
                  endDate: endDateWorld,
                )
              : const Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('uC'),
                Image.asset(
                  'assets/images/covid-icon1.png',
                  fit: BoxFit.contain,
                  height: 24,
                ),
                const Text('VID'),
              ]
          )
      ),
      body: SafeArea(
        child: Expanded(
          child: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFF63A4FF),
                    Color(0xBC83EAF1),
                  ],
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0x33FFFFFF),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Dzienne dane o COVID',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),

                    //tables row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Poland Table
                        FutureBuilder<DailyPolandData>(
                          future: futureDailyPoland,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 2.5,
                                  child: Column(
                                    children: [
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            getFlag(selectedItem),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                                              child: Text(
                                                getName(selectedItem).toUpperCase(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  decoration: TextDecoration.underline,
                                                  decorationThickness: 3,
                                                ),
                                              ),
                                            ),
                                          ]),
                                      Table(
                                        children: [
                                          TableRow(
                                            children: <Widget>[
                                              Center(
                                                child: Text(
                                                  '${snapshot.data!.dailyConfirmed}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const TableRow(
                                            children: <Widget>[
                                              Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 8.0),
                                                  child: Text(
                                                    'Przypadki',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              Center(
                                                child: Text(
                                                  '${snapshot.data!.dailyDeaths}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const TableRow(
                                            children: <Widget>[
                                              Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(bottom: 8.0),
                                                  child: Text(
                                                    'Zgony',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              Center(
                                                child: Text(
                                                  '${snapshot.data!.totalConfirmed}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const TableRow(
                                            children: <Widget>[
                                              Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(bottom: 8.0),
                                                  child: Text(
                                                    'Wszystkie przypadki',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              Center(
                                                child: Text(
                                                  '${snapshot.data!.totalDeaths}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const TableRow(
                                            children: <Widget>[
                                              Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(bottom: 8.0),
                                                  child: Text(
                                                    'Wszystkie zgony',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              Center(
                                                child: Text(
                                                  '${snapshot.data!.totalRecovered}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const TableRow(
                                            children: <Widget>[
                                              Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(bottom: 8.0),
                                                  child: Text(
                                                    'Uzdrowienia',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return const CircularProgressIndicator();
                          },
                        ),

                        //world table
                        FutureBuilder<DailyWorldData>(
                          future: futureDailyWorld,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
                                child: Column(
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/location.png',
                                            fit: BoxFit.contain,
                                            height: 18,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(left: 5.0, bottom: 5.0),
                                            child: Text(
                                              'ŚWIAT',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationThickness: 3,
                                              ),
                                            ),
                                          ),
                                        ]),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 2.5,
                                      child: Table(
                                        children: [
                                          TableRow(
                                            children: <Widget>[
                                              Center(
                                                child: Text(
                                                  '${snapshot.data!.totalNewCases}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const TableRow(
                                            children: <Widget>[
                                              Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(bottom: 8.0),
                                                  child: Text(
                                                    'Przypadki',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              Center(
                                                child: Text(
                                                  '${snapshot.data!.totalNewDeaths}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const TableRow(
                                            children: <Widget>[
                                              Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(bottom: 8.0),
                                                  child: Text(
                                                    'Zgony',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              Center(
                                                child: Text(
                                                  '${snapshot.data!.totalConfirmed}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const TableRow(
                                            children: <Widget>[
                                              Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(bottom: 8.0),
                                                  child: Text(
                                                    'Wszystkie przypadki',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              Center(
                                                child: Text(
                                                  '${snapshot.data!.totalDeaths}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const TableRow(
                                            children: <Widget>[
                                              Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(bottom: 8.0),
                                                  child: Text(
                                                    'Wszystkieg zgony',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              Center(
                                                child: Text(
                                                  '${snapshot.data!.totalRecovered}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const TableRow(
                                            children: <Widget>[
                                              Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(bottom: 8.0),
                                                  child: Text(
                                                    'Uzdrowienia',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return const CircularProgressIndicator();
                          },
                        ),
                      ],
                    ),

                    //dropdown menu to chose coutry
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        //thing about replace by SizedBox and check difference
                        height: 55,
                        width: MediaQuery.of(context).size.width / 3,
                        child: DropdownButtonFormField(
                          items: _coutries.map((item) {
                            return DropdownMenuItem(
                              child: Text(item.coutryName),
                              value: item.coutryCode,
                            );
                          }).toList(),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFF63A4FF), width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            filled: true,
                            fillColor: const Color(0xFF63A4FF),
                          ),
                          dropdownColor: const Color(0xFF63A4FF),
                          onChanged: (String? newVal) {
                            setState(() {
                              selectedItem = newVal!;
                            });
                            futureData = ApiManager().fetchData(strEndDatePoland, strStartDatePoland, selectedItem);
                            futureDailyPoland = ApiManager().fetchDailyPoland(selectedItem);
                          },
                          value: selectedItem,
                        ),
                      ),
                    ),

                    futureBuilderPoland(),

                    //this is firt row to input for date - poland
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //endDate TextInput for Poland
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: TextField(
                                readOnly: true,
                                showCursor: true,
                                controller: startDateInputPoland,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    icon: Icon(Icons.calendar_today, size: 16),
                                    labelText:
                                        "Data początkowa"
                                    ),
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      locale: const Locale("pl", "PL"),
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2010),
                                      lastDate: DateTime.now());

                                  if (pickedDate != null) {
                                    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

                                    setState(() {
                                      startDateInputPoland.text = formattedDate;
                                      startDatePoland = DateFormat('yyyy-MM-dd').parse(startDateInputPoland.text);
                                      startDatePoland = DateTime(startDatePoland.year, startDatePoland.month, startDatePoland.day - 1);
                                      strStartDatePoland = DateFormat('yyyy-MM-dd').format(DateTime.parse(startDatePoland.toString()));
                                    });
                                    futureData = ApiManager().fetchData(strEndDatePoland, strStartDatePoland, selectedItem);
                                  } else {
                                    print("Date is not selected");
                                  }
                                },
                              ),
                            ),
                          ),

                          //startDate TextInput for Poland
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: TextField(
                                readOnly: true,
                                showCursor: true,
                                controller: endDateInputPoland,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    icon: Icon(Icons.calendar_today, size: 16),
                                    labelText: "Data końcowa"
                                    ),
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      locale: const Locale("pl", "PL"),
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2010),
                                      lastDate: DateTime.now());
                                  if (pickedDate != null) {
                                    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                    setState(() {
                                      endDateInputPoland.text = formattedDate;
                                      endDatePoland = DateFormat('yyyy-MM-dd').parse(endDateInputPoland.text);
                                      endDatePoland = DateTime(endDatePoland.year, endDatePoland.month, endDatePoland.day + 1);
                                      strEndDatePoland = DateFormat('yyyy-MM-dd').format(DateTime.parse(endDatePoland.toString()));
                                    });
                                    futureData = ApiManager().fetchData(strEndDatePoland, strStartDatePoland, selectedItem);
                                  } else {
                                    print("Date is not selected");
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //here futureBuilderOthers
                    futureBuilderWorld(),

                    //second row for input for date - world
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //endDate TextInput for world
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: TextField(
                              readOnly: true,
                              showCursor: true,
                              controller: startDateInputWorld,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  icon: Icon(Icons.calendar_today, size: 16),
                                  labelText: "Data początkowa"
                                  ),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    locale: const Locale("pl", "PL"),
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2010),
                                    lastDate: DateTime.now());
                                if (pickedDate != null) {
                                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                  setState(() {
                                    startDateInputWorld.text = formattedDate;
                                    startDateWorld = startDateInputWorld.text;
                                  });
                                } else {
                                  print("Date is not selected");
                                }
                              },
                            ),
                          ),
                        ),

                        //start date for world
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: TextField(
                              readOnly: true,
                              showCursor: true,
                              controller: endDateInputWorld,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  icon: Icon(Icons.calendar_today, size: 16),
                                  labelText: "Data końcowa"
                                  ),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    locale: const Locale("pl", "PL"),
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2010),
                                    lastDate: DateTime.now());
                                if (pickedDate != null) {
                                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                  setState(() {
                                    endDateInputWorld.text = formattedDate;
                                    endDateWorld = endDateInputWorld.text;
                                  });
                                } else {
                                  print("Date is not selected");
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
