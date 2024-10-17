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

  // Переменные для профиля
  int _completedLevels = 0; // Количество пройденных уровней
  int _score = 0; // Счёт пользователя

  // Переменная для хранения выбранного уровня
  int? _selectedLevel;

  // Вопросы для каждого уровня
  final List<String> _questions = [
    'Уровень 1: Напиши программу на Go, которая выводит "Hello, World!"',
    'Уровень 2: Напиши функцию на Go для сложения двух чисел.',
    'Уровень 3: Создай структуру "Person" с полями имя и возраст.',
    'Уровень 4: Напиши программу на Go, которая выводит числа от 1 до 10.',
    'Уровень 5: Напиши функцию на Go для нахождения максимального числа в массиве.'
  ];

  // Метод обработки нажатия на уровень
  void _onLevelTapped(int level) {
    setState(() {
      _selectedLevel = level;
    });
  }

  // Метод обработки нажатия на вкладку
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedLevel = null; // Сбрасываем выбор уровня при переключении вкладок
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
        child: _selectedIndex == 0
            ? (_selectedLevel != null
                // Если уровень выбран, показываем вопрос и поле для ввода
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.emoji_objects, size: 60, color: Colors.yellow),
                      SizedBox(height: 20),
                      Text(
                        _questions[_selectedLevel! - 1],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Ваш ответ',
                            hintText: 'Введите ответ здесь',
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      TextButton(
                        onPressed: () {
                          // Логика для проверки ответа или завершения уровня
                          setState(() {
                            _completedLevels++; // Увеличиваем количество пройденных уровней
                            _score += 10; // Добавляем очки за прохождение уровня
                            _selectedLevel = null; // Сброс выбранного уровня
                          });
                        },
                        child: Text('Отправить'),
                      )
                    ],
                  )
                // Если уровень не выбран, показываем уровни
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int level = 5; level >= 1; level--) ...[
                        GestureDetector(
                          onTap: () => _onLevelTapped(level),
                          child: CircleAvatar(
                            radius: 30,
                            child: Text(
                              '$level',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ],
                  ))
            // Средняя вкладка с приветствием (не изменяем)
            : _selectedIndex == 1
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.sentiment_satisfied, size: 100),
                      SizedBox(height: 20),
                      Text(
                        'Привет, Новичок! Добро пожаловать в мою игру!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  )
                // Третья вкладка с профилем пользователя
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/profile.png', // Замените на путь к вашему изображению
                        width: 200, // Установите ширину изображения
                        height: 200, // Установите высоту изображения
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Профиль пользователя',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Пройдено уровней: $_completedLevels',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Счёт: $_score',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Логика для добавления бонусных очков
                          setState(() {
                            _score += 50; // Например, добавляем бонусные очки
                          });
                        },
                        child: Text('Получить бонусные очки'),
                      ),
                    ],
                  ),

      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
