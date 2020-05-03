import 'package:flutter/material.dart';

// question ID, option selected pairs - i.e. {1: 1, 2: 5, 3: 9, 4: 11}
var questionOptionDict = {};

class QuestionCard extends StatefulWidget {
  final questionDict;

  QuestionCard(this.questionDict);

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  String questionText;
  int questionId;
  List<Widget> questionDisplay = [];

  @override
  void initState() {
    super.initState();
    buildQuestionCard();
  }

  void buildQuestionCard() {
    questionText = widget.questionDict['question'];
    questionId = widget.questionDict['question_id'];
    Widget questionTextWidget = Padding(
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 0, 30.0),
      child: Text(
        questionText,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
    );
    questionDisplay.add(questionTextWidget);

    if (widget.questionDict['multiple_choice']) {
      List options = widget.questionDict['options'];

      options.forEach(
        (option) {
          String optionText = option['text'];
          int optionId = option['option_id'];
          Widget optionCheckbox =
              CustomCheckboxListTile(optionText, optionId, questionId);
          questionDisplay.add(optionCheckbox);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.indigo,
        elevation: 20.0,
        child: Column(
          children: questionDisplay,
        ),
      ),
    );
  }
}

class CustomCheckboxListTile extends StatefulWidget {
  final String text;
  final int optionId;
  final int questionId;

  CustomCheckboxListTile(this.text, this.optionId, this.questionId);

  @override
  _CustomCheckboxListTileState createState() => _CustomCheckboxListTileState();
}

class _CustomCheckboxListTileState extends State<CustomCheckboxListTile> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: _isSelected,
      selected: _isSelected,
      title: Text(widget.text),
      secondary: Icon(Icons.adjust),
      onChanged: (newVal) {
        setState(() {
          _isSelected = newVal;
          questionOptionDict[widget.questionId] = widget.optionId;
        });
      },
    );
  }
}
