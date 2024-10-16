import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../widgets/bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // По умолчанию выбрана средняя вкладка
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlayingSong1 = true;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Вкладка 1'),
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.sentiment_satisfied, size: 100),
          SizedBox(height: 20),
          Text(
            'Привет, Новичок! Добро пожаловать в мою игру, пока мне здесь одиноко, но скоро будет здесь много всего!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    ),
    Text('Вкладка 2'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _playBackgroundMusic();
  }

  void _playBackgroundMusic() async {
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        _isPlayingSong1 = !_isPlayingSong1;
        _playBackgroundMusic();
      }
    });

    if (_isPlayingSong1) {
      await _audioPlayer.play(AssetSource('song1.mp3'));
    } else {
      await _audioPlayer.play(AssetSource('song2.mp3'));
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
