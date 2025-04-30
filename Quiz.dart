class Quiz {
  final Map<String,Map<String, bool>> questionsResponses;
  Quiz({
    required this.questionsResponses,
  });
  void addQuestion(String question, Map<String, bool> responses){
      questionsResponses[question] = responses;
  }
  void deleteQuestion(String question){
    if (questionsResponses.containsKey(question)) {
        questionsResponses.remove(question);
  }
}}
