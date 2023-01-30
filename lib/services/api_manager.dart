import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:covidapp/constants/strings.dart';

class ApiManager {
  //parametry przekazane z main_page
  //konstruktor do tego i fetchData (startDate i endDate)

  Future<List<CovidData>> fetchData(String endDatePoland, String startDatePoland, String coutryCode) async{

    //endDatePoland = DateFormat('yyyy-MM-dd').format(DateTime.parse(endDatePoland));
    //print(endDatePoland);
    //print(coutryCode);
    final response = await http.get(Uri.parse(Strings.covid_data_url+'?countryCode='+coutryCode+'&startDate='+startDatePoland+'&endDate='+endDatePoland));
    List jsonResponse = json.decode(response.body);

    if(response.statusCode == 200){
      //return CovidData.fromJson(jsonresponse[0]);
      return jsonResponse.map((data) => CovidData.fromJson(data)).toList();
    }
    else{
      throw Exception('Failed');
    }
  }

  Future<List<CovidDataWorld>> fetchWorldData() async{
    final response = await http.get(Uri.parse(Strings.covid_data_wolrd));
    List jsonResponse = json.decode(response.body);

    if(response.statusCode == 200){
      //return CovidData.fromJson(jsonresponse[0]);
      return jsonResponse.map((data) => CovidDataWorld.fromJson(data)).toList();
    }
    else{
      throw Exception('Failed');
    }
  }

  Future<DailyWorldData> fetchDailyWorld() async {
    final response = await http.get(Uri.parse(Strings.daily_data_world));

    if (response.statusCode == 200) {
      return DailyWorldData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed');
    }
  }

  Future<DailyPolandData> fetchDailyPoland(String coutryCode) async {
    final response = await http.get(Uri.parse(Strings.daily_data_poland+coutryCode));
    List jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      return DailyPolandData.fromJson(jsonResponse[0]);
      //return DailyPolandData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed');
    }
  }

  Future<List<CoutryCode>> fetchCoutries() async{
    final response = await http.get(Uri.parse(Strings.coutry_data_combobox));
    List jsonResponse = json.decode(response.body);

    if(response.statusCode == 200){
      return jsonResponse.map((data) => CoutryCode.fromJson(data)).toList();
    }
    else{
      throw Exception('Failed');
    }
  }

}

class CovidData {
  final int new_infections;
  final int new_deaths;
  final int new_recovered;
  final String last_updated;

  const CovidData({
    required this.new_infections,
    required this.new_deaths,
    required this.new_recovered,
    required this.last_updated,
  });

  factory CovidData.fromJson(Map<String, dynamic> json) {
    return CovidData(
      new_infections: json['new_infections'],
      new_deaths: json['new_deaths'],
      new_recovered: json['new_recovered'],
      last_updated: json['last_updated'],
    );
  }
}

class CovidDataWorld{
  final totalConfirmed;
  final totalDeaths;
  final totalRecovered;
  final lastUpdated;

  const CovidDataWorld({
    required this.totalConfirmed,
    required this.totalDeaths,
    required this.totalRecovered,
    required this.lastUpdated,
  });

  factory CovidDataWorld.fromJson(Map<String, dynamic> json) {
    return CovidDataWorld(
      totalConfirmed: json['totalConfirmed'],
      totalDeaths: json['totalDeaths'],
      totalRecovered: json['totalRecovered'],
      lastUpdated: json['lastUpdated'],
    );
  }
}

class DailyWorldData {
  final totalNewCases;
  final totalNewDeaths;
  final totalConfirmed;
  final totalDeaths;
  final totalRecovered;

  const DailyWorldData({
    required this.totalNewCases,
    required this.totalNewDeaths,
    required this.totalConfirmed,
    required this.totalDeaths,
    required this.totalRecovered,
  });

  factory DailyWorldData.fromJson(Map<String, dynamic> json) {
    return DailyWorldData(
      totalNewCases: json['totalNewCases'],
      totalNewDeaths: json['totalNewDeaths'],
      totalConfirmed: json['totalConfirmed'],
      totalDeaths: json['totalDeaths'],
      totalRecovered: json['totalRecovered'],
    );
  }
}

class DailyPolandData {
  final dailyConfirmed;
  final dailyDeaths;
  final totalConfirmed;
  final totalDeaths;
  final totalRecovered;

  const DailyPolandData({
    required this.dailyConfirmed,
    required this.dailyDeaths,
    required this.totalConfirmed,
    required this.totalDeaths,
    required this.totalRecovered,
  });

  factory DailyPolandData.fromJson(Map<String, dynamic> json) {
    return DailyPolandData(
      dailyConfirmed: json['dailyConfirmed'],
      dailyDeaths: json['dailyDeaths'],
      totalConfirmed: json['totalConfirmed'],
      totalDeaths: json['totalDeaths'],
      totalRecovered: json['totalRecovered'],
    );
  }
}

class CoutryCode {
  final countryCode;

  const CoutryCode({
    required this.countryCode,
  });

  factory CoutryCode.fromJson(Map<String, dynamic> json) {
    return CoutryCode(
      countryCode: json['countryCode'],
    );
  }
}

