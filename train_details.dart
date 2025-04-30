import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:transporttracking/Controller/controller.dart';
import 'package:transporttracking/View/text_field.dart';

class TrainDetails extends StatefulWidget {
  const TrainDetails({super.key});

  @override
  State<TrainDetails> createState() => _TrainDetailsState();
}

class _TrainDetailsState extends State<TrainDetails> {
  final stationsNbController = TextEditingController();
  final trainSpeedController = TextEditingController();
  List<TextEditingController> distanceControllers = [];

  @override
  void initState() {
    super.initState();
    stationsNbController.addListener(_updateDistanceFields);
  }

  void _updateDistanceFields() {
    final input = int.tryParse(stationsNbController.text);
    if (input != null && input >= 0) {
      setState(() {
        if (input > distanceControllers.length) {
          for (int i = distanceControllers.length; i < input; i++) {
            distanceControllers.add(TextEditingController());
          }
        } else if (input < distanceControllers.length) {
          distanceControllers = distanceControllers.sublist(0, input);
        }
      });
    }
  }

  @override
  void dispose() {
    stationsNbController.dispose();
    for (final controller in distanceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

void _handleSubmit() async {
    final numberOfStations = int.tryParse(stationsNbController.text);
    final trainSpeed = trainSpeedController.text;

    if (numberOfStations == null || numberOfStations <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid number of stations'.tr())),
      );
      return;
    }

    if (trainSpeed.isEmpty || double.tryParse(trainSpeed) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid train speed'.tr())),
      );
      return;
    }

    List<String> distances = [];
    for (var controller in distanceControllers) {
      if (controller.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all distance fields'.tr())),
        );
        return;
      }
      distances.add(controller.text);
    }

    try {
      
      Controller.addTrainDetails(numberOfStations, trainSpeed, distances);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Train details saved successfully!'.tr())),
      );

      stationsNbController.clear();
      trainSpeedController.clear();
      setState(() {
        distanceControllers.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Train Details',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Kanit'),
        ),
        leading: Icon(Icons.train, color: Colors.amber),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.tealAccent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Text(
                'Stations Number :'.tr(),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 5),
            MyTextField(
              controller: stationsNbController,
              hintText: 'Stations number'.tr(),
              obscureText: false,
            ),
            const SizedBox(height: 20),
            if (distanceControllers.isNotEmpty)
              Center(
                child: Text(
                  'Stations distances : '.tr(),
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 5),
              Center(
              child: Text(
                'Train speed (km/h):'.tr(),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 5),
            MyTextField(
              controller: trainSpeedController,
              hintText: 'Enter train speed'.tr(),
              obscureText: false,
            ),
            const SizedBox(height: 10),
            for (int i = 0; i < (distanceControllers.length)-1; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: MyTextField(
                  controller: distanceControllers[i],
                  hintText: 'Distance from station ${i + 1} to station ${i+2}'.tr(),
                  obscureText: false,
                ),
              ),
              const SizedBox(height: 5),
           ElevatedButton(
          onPressed: _handleSubmit,
          style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
  child: Text(
    'Submit'.tr(),
    style: TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
),
          ],
        ),
      ),
    );
  }
}
