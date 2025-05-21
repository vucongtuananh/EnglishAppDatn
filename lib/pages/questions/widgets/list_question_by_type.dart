import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/complete_conversation_question.dart';
import '../../../utils/constants.dart';
import 'edit_question_by_type.dart';

class ListQuestionByType extends ConsumerStatefulWidget {
  final dynamic listQuestionByType;
  final String title;
  final String mapId;
  final String topicId;
  final String lessonId;
  final String questionId;
  final String typeOfQuestion;

  const ListQuestionByType({super.key, required this.listQuestionByType, required this.title, required this.mapId, required this.topicId, required this.lessonId, required this.questionId, required this.typeOfQuestion});

  @override
  ConsumerState<ListQuestionByType> createState() => _ListQuestionByTypeState();
}

class _ListQuestionByTypeState extends ConsumerState<ListQuestionByType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, widget.listQuestionByType);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Xác nhận thêm'),
                content: const SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Bạn muốn thêm câu hỏi mới?'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Hủy'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Thêm'),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditQuestionByType(
                            title: widget.title,
                            mapId: widget.mapId,
                            topicId: widget.topicId,
                            lessonId: widget.lessonId,
                            type: widget.title,
                            add: true,
                            questionId: widget.questionId,
                            typeOfQuestion: widget.typeOfQuestion,
                          ),
                        ),
                      );

                      if (result != null) {
                        switch (result[2]) {
                          case completeConversationQuestion:
                            final updatedQuestion = result[0] as CompleteConversationQuestion;
                            setState(() {
                              widget.listQuestionByType.add(updatedQuestion);
                            });
                            break;
                          // Other cases remain the same
                          // ...
                        }
                      }

                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: widget.listQuestionByType.length,
        itemBuilder: (context, index) {
          final question = widget.listQuestionByType[index];
          return Card(
            elevation: 3,
            shadowColor: Colors.grey,
            child: ListTile(
              title: Text(" Câu hỏi số ${index + 1}"),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditQuestionByType(
                      question: question,
                      title: widget.title,
                      mapId: widget.mapId,
                      topicId: widget.topicId,
                      lessonId: widget.lessonId,
                      type: widget.title,
                      index: index,
                      add: false,
                      questionId: widget.questionId,
                      typeOfQuestion: '',
                    ),
                  ),
                );

                if (result != null) {
                  // Handle result cases
                  // ...
                }
              },
              trailing: IconButton(
                onPressed: () {
                  _showDeleteConfirmationDialog(context, index, question);
                },
                icon: const Icon(Icons.delete_forever),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, int index, dynamic question) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có chắc chắn muốn xóa câu hỏi này không?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Xóa'),
              onPressed: () {
                setState(() {
                  widget.listQuestionByType.removeAt(index);
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
