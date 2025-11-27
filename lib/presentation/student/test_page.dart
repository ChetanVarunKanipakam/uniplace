import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int _currentIndex = 0;
  int _score = 0;

  // Sample test data – replace with backend data
  final List<Map<String, dynamic>> questions = [
    {
      "question": "What is 2 + 2?",
      "options": ["3", "4", "5"],
      "answer": "4"
    },
    {
      "question": "Capital of India?",
      "options": ["Delhi", "Mumbai", "Bangalore"],
      "answer": "Delhi"
    },
  ];

  String? _selectedAnswer;

  void _nextQuestion() {
    if (_selectedAnswer == questions[_currentIndex]["answer"]) {
      _score++;
    }
    if (_currentIndex < questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Test Completed"),
        content: Text("Your score: $_score / ${questions.length}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text("Test Module")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Q${_currentIndex + 1}. ${q["question"]}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...q["options"].map<Widget>((opt) {
              return RadioListTile<String>(
                value: opt,
                groupValue: _selectedAnswer,
                onChanged: (val) => setState(() => _selectedAnswer = val),
                title: Text(opt),
              );
            }).toList(),
            const Spacer(),
            CustomButton(
              text: _currentIndex < questions.length - 1 ? "Next" : "Submit",
              onPressed: _nextQuestion,
            )
          ],
        ),
      ),
    );
  }
}
