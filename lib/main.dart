import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    // Підключаємо Provider на рівні всього додатку
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ColorState()),
      ],
      child: const MyApp(),
    ),
  );
}

// ---------------------------------------------------------
// 1. КЛАС СТАНУ (ChangeNotifier)
// Тут зберігаються дані RGB і логіка їх зміни
// ---------------------------------------------------------
class ColorState extends ChangeNotifier {
  // Початкові значення (як на скріншоті)
  int _red = 50;
  int _green = 203;
  int _blue = 182;

  int get red => _red;
  int get green => _green;
  int get blue => _blue;

  // Геттер, що повертає об'єкт Color на основі RGB
  Color get currentColor => Color.fromRGBO(_red, _green, _blue, 1.0);

  void updateRed(double value) {
    _red = value.toInt();
    notifyListeners(); // Повідомляємо віджети про зміни
  }

  void updateGreen(double value) {
    _green = value.toInt();
    notifyListeners();
  }

  void updateBlue(double value) {
    _blue = value.toInt();
    notifyListeners();
  }
}

// ---------------------------------------------------------
// 2. ГОЛОВНИЙ ВІДЖЕТ ДОДАТКУ
// ---------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RGB Color Picker',
      theme: ThemeData(
        useMaterial3: true,
        // Налаштування теми, щоб відповідати скріншоту (фіолетові відтінки)
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFFFBF5FF), // Світло-рожевий фон
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[100],
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 3. ВИКОРИСТАННЯ КАСТОМНОГО ВІДЖЕТА ПРЕВ'Ю
            Expanded(child: Center(child: ColorPreviewWidget())),

            // 4. ВИКОРИСТАННЯ КАСТОМНОГО ВІДЖЕТА СЛАЙДЕРІВ
            ColorSlidersSection(),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// 3. КАСТОМНИЙ ВІДЖЕТ: ПРЕВ'Ю (Preview Container)
// ---------------------------------------------------------
class ColorPreviewWidget extends StatelessWidget {
  const ColorPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Отримуємо доступ до стану
    final colorState = context.watch<ColorState>();

    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: colorState.currentColor, // Колір береться з провайдера
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// 4. КАСТОМНИЙ ВІДЖЕТ: СЕКЦІЯ СЛАЙДЕРІВ
// ---------------------------------------------------------
class ColorSlidersSection extends StatelessWidget {
  const ColorSlidersSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Використовуємо context.watch, щоб перемальовувати віджет при зміні даних
    final colorState = context.watch<ColorState>();

    return Column(
      children: [
        _buildSingleSlider(
          label: 'Red',
          value: colorState.red,
          onChanged: (val) => context.read<ColorState>().updateRed(val),
        ),
        _buildSingleSlider(
          label: 'Green',
          value: colorState.green,
          onChanged: (val) => context.read<ColorState>().updateGreen(val),
        ),
        _buildSingleSlider(
          label: 'Blue',
          value: colorState.blue,
          onChanged: (val) => context.read<ColorState>().updateBlue(val),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Допоміжний метод для побудови одного рядка слайдера (щоб не дублювати код)
  Widget _buildSingleSlider({
    required String label,
    required int value,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              '$value', // Відображення числового значення
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: 0,
          max: 255,
          activeColor: Colors.deepPurple, // Колір активної частини (як на фото)
          thumbColor: Colors.deepPurple,  // Колір "кульки"
          inactiveColor: Colors.deepPurple[100],
          onChanged: onChanged,
        ),
      ],
    );
  }
}
