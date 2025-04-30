import 'package:flutter/material.dart';

class QuizPageAdmin extends StatefulWidget {
  const QuizPageAdmin({super.key});
  @override
  QuizPageAdminState createState() => QuizPageAdminState();
}

class QuizPageAdminState extends State<QuizPageAdmin> {
  List<Question> questions = [];
  final _formKey = GlobalKey<FormState>();
  String _questionText = '';
  List<String> _answers = ['', '', '', ''];
  int _editingIndex = -1;
  final primaryColor = Colors.amber;
  void _saveQuestion() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newQuestion = Question(
        questionText: _questionText,
        answers: List.from(_answers),
      );

      setState(() {
        if (_editingIndex >= 0) {
          questions[_editingIndex] = newQuestion;
        } else {
          questions.add(newQuestion);
        }
        _resetForm();
      });
    }
  }

  void _editQuestion(int index) {
    setState(() {
      _editingIndex = index;
      _questionText = questions[index].questionText;
      _answers = List.from(questions[index].answers);
    });
  }

  void _deleteQuestion(int index) {
    setState(() {
      questions.removeAt(index);
      if (_editingIndex == index) {
        _resetForm(); 
      }
    });
  }

  void _resetForm() {
    setState(() {
      _editingIndex = -1;
      _questionText = '';
      _answers = ['', '', '', ''];
      _formKey.currentState?.reset();
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Gestion des Quiz' , style: TextStyle(fontFamily: 'Kanit'),),
         backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.tealAccent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Card(
                color: Colors.teal,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _questionText,
                        decoration: InputDecoration(labelText: 'Question' , labelStyle: TextStyle(color: primaryColor),
                        
                        focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor), 
              ),
                  enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor.shade500),
              ), ),
                        onSaved: (value) => _questionText = value ?? '',
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Veuillez entrer une question' : null,
                      ),
                      SizedBox(height: 10),
                      ...List.generate(4, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: TextFormField(
                            initialValue: _answers[index],
                            decoration: InputDecoration(labelText: 'Réponse ${index + 1}', labelStyle: TextStyle(color: primaryColor), 
                            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor), 
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor.shade500), 
              ),
                            ),
                            onSaved: (value) => _answers[index] = value ?? '',
                            validator: (value) => value == null || value.isEmpty
                                ? 'Veuillez entrer une réponse'
                                : null,
                        
                          ),
                        );
                      }),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: _saveQuestion,
                            
                            style: ElevatedButton.styleFrom(
                             backgroundColor: primaryColor,
                             ),
                             child: Text('Save' ,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                          ),
                          SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: _resetForm,
                             
                              style: ElevatedButton.styleFrom(
                             backgroundColor: primaryColor,
                             ),
                              child: Text('Reset', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Questions existantes', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 10),
            ...questions.asMap().entries.map((entry) {
              int index = entry.key;
              Question q = entry.value;

              final isEditing = index == _editingIndex;
              return Card(
                color: isEditing ? Colors.amber[100] : null,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text(q.questionText),
                  subtitle: Text(q.answers.join(' / ')),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editQuestion(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteQuestion(index),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class Question {
  final String questionText;
  final List<String> answers;

  Question({required this.questionText, required this.answers});
}
