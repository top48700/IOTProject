import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // For date formatting

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> data = [];
  bool isLoading = true;

  Future<void> fetchData() async {
    try {
      // Replace with your server's IP address and endpoint
      final response = await http.get(Uri.parse('http://192.168.235.5:3000/data'));

      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('InfluxDB Data Viewer'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : data.isEmpty
              ? Center(child: Text('No data available'))
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];

                    // Handle potential null values
                    final sensorId = item['sensorId'] ?? 'N/A';
                    final energyValue = item['accumulatedEnergyValue'] ?? 'N/A';
                    final powerConsumption = item['powerConsumptionValue'] ?? 'N/A';
                    final powerFactor = item['powerFactorValue'] ?? 'N/A';
                    final measuredAt = item['measuredAt'];

                    // Format timestamp
                    final formattedTime = measuredAt != null
                        ? DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(measuredAt))
                        : 'N/A';

                    return ListTile(
                      title: Text('Sensor ID: $sensorId'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Accumulated Energy: $energyValue'),
                          Text('Power Consumption: $powerConsumption'),
                          Text('Power Factor: $powerFactor'),
                        ],
                      ),
                      trailing: Text('Time: $formattedTime'),
                    );
                  },
                ),
    );
  }
}
