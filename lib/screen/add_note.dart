import 'package:flutter/material.dart';

import 'package:note_app/repository/data_base_helper.dart';

import 'package:note_app/model/Note.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final DataBaseHelper dbHelper = DataBaseHelper();
  String title = "";
  String content = "";
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool visibility = false;

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        addNote();
      },
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add New Note"),
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
          leading: BackButton(
            onPressed: () => addNote(),
          ),
          actions: [
            addNoteButton(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                maxLines: 1,
                textInputAction: TextInputAction.next,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintText: 'Başlık',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                onChanged: (value) {
                  title = value;
                  setState(() {
                    visibility = true;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: contentController,
                maxLines: null,
                textInputAction: TextInputAction.newline,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintText: "İçerik",
                  labelStyle: TextStyle(color: Colors.black),
                ),
                onChanged: (value) {
                  content = value;
                  setState(() {
                    visibility = true;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addNote() async {
    if (title.isNotEmpty || content.isNotEmpty) {
      Note note = Note(
        title: title,
        content: content,
      );
      await dbHelper.insertNote(note);
    }

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Widget addNoteButton() {
    return Visibility(
      visible: visibility,
      child: IconButton(
        onPressed: () {
          addNote();
        },
        icon: const Icon(Icons.check),
      ),
    );
  }
}
