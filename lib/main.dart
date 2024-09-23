import 'package:flutter/material.dart';
import 'dart:async'; // For Timer

void main() {
  runApp(MaterialApp(
    home: PetNameScreen(), // Start with Pet Name Screen
    debugShowCheckedModeBanner: false, // Disable the debug banner
  ));
}

// Screen to enter the pet name
class PetNameScreen extends StatefulWidget {
  @override
  _PetNameScreenState createState() => _PetNameScreenState();
}

class _PetNameScreenState extends State<PetNameScreen> {
  TextEditingController _nameController = TextEditingController();

  void _startGame() {
    String petName =
        _nameController.text.isNotEmpty ? _nameController.text : "Your Pet";
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DigitalPetApp(petName: petName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Name Your Pet'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Enter the pet's name"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _startGame,
                child: Text('Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Main Digital Pet App
class DigitalPetApp extends StatefulWidget {
  final String petName;

  DigitalPetApp({required this.petName});

  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  int happinessLevel = 50;
  int hungerLevel = 50;
  Timer? _hungerTimer;
  Timer? _winTimer;
  bool _isGameOver = false;
  bool _isWinner = false;
  String _statusMessage = ''; // To hold the status message

  String Photo =
      'https://static.vecteezy.com/system/resources/previews/023/629/554/original/rabbit-silhouette-with-transparent-background-png.png';
  Image Rabbit = Image.network(
      'https://static.vecteezy.com/system/resources/previews/023/629/554/original/rabbit-silhouette-with-transparent-background-png.png',
      color: Colors.yellow);
  String Mood = 'Neutral';
  String HappyEmoji =
      'https://i.pinimg.com/736x/fe/d2/a3/fed2a302fe9f8ce3ee2b77849fb3bb39.jpg';
  String NeutralEmoji =
      'https://emojiisland.com/cdn/shop/products/Neutral_Emoji_icon_9f1cc93a-f984-4b6c-896e-d24a643e4c28_grande.png?v=1571606091';
  String UnhappyEmoji =
      'https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTExL3JtNTg2YmF0Y2gyLWVtb2ppLTAwMy5wbmc.png';
  Image Emoji = Image.network(
      'https://emojiisland.com/cdn/shop/products/Neutral_Emoji_icon_9f1cc93a-f984-4b6c-896e-d24a643e4c28_grande.png?v=1571606091',
      width: 50,
      height: 50);

  @override
  void initState() {
    super.initState();
    _startTimers();
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    _winTimer?.cancel();
    super.dispose();
  }

  void _startTimers() {
    // Timer to increase hunger and decrease happiness every 30 seconds
    _hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (!_isGameOver && !_isWinner) {
        setState(() {
          hungerLevel = (hungerLevel + 5).clamp(0, 100);
          happinessLevel = (happinessLevel - 5).clamp(0, 100);
          _updateMood();
          _checkGameOver();
        });
      }
    });

    // Timer for win condition (happiness > 80 for 3 minutes)
    _winTimer = Timer(Duration(minutes: 3), () {
      if (happinessLevel > 80 && !_isGameOver) {
        setState(() {
          _isWinner = true;
          _statusMessage = 'You Win! Your pet is happy for 3 minutes!';
        });
        _showWinDialog();
      }
    });
  }

  void _playWithPet() {
    if (_isGameOver || _isWinner) return;
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      hungerLevel = (hungerLevel + 5).clamp(0, 100); // Slightly increase hunger
      _updateMood();
      _checkGameOver();
    });
  }

  void _feedPet() {
    if (_isGameOver || _isWinner) return;
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      happinessLevel = (happinessLevel + 5).clamp(0, 100);
      _updateMood();
    });
  }

  void _updateMood() {
    if (happinessLevel > 70) {
      Rabbit = Image.network(Photo, color: Colors.green);
      Mood = 'Happy';
      Emoji = Image.network(HappyEmoji, width: 50, height: 50);
    } else if (happinessLevel < 30) {
      Rabbit = Image.network(Photo, color: Colors.red);
      Mood = 'Unhappy';
      Emoji = Image.network(UnhappyEmoji, width: 50, height: 50);
    } else {
      Rabbit = Image.network(Photo, color: Colors.yellow);
      Mood = 'Neutral';
      Emoji = Image.network(NeutralEmoji, width: 50, height: 50);
    }
  }

  void _checkGameOver() {
    if (hungerLevel >= 100 && happinessLevel < 10) {
      setState(() {
        _isGameOver = true;
        _statusMessage = 'Game Over! Your pet is too hungry and unhappy.';
      });
      _showGameOverDialog();
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Over'),
        content: Text('Your pet is too hungry and unhappy.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Return to pet name screen
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('You Win!'),
        content: Text('Your pet is very happy for 3 minutes!'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Return to pet name screen
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.petName}\'s Status'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_statusMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  _statusMessage,
                  style: TextStyle(fontSize: 22, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            Rabbit,
            SizedBox(height: 16),
            Text(
              Mood,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Emoji,
            SizedBox(height: 16),
            Text(
              'Name: ${widget.petName}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
