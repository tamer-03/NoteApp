import 'package:flutter/material.dart';
import 'package:note_app/screen/home_page.dart';

class AddNote extends StatefulWidget {
  final List<Note> notes;
  const AddNote({super.key, required this.notes});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  String title = "";
  String content = "";

  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Note"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          TextField(
            maxLines: null,
            cursorColor: Colors.black,
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              labelText: "Başlık",
              labelStyle: TextStyle(color: Colors.black),
              filled: true,
              fillColor: Color.fromARGB(255, 255, 255, 255),
            ),
            onChanged: (value) {
              title = value;
            },
          ),
          TextField(
            controller: descriptionController,
            maxLines: null,
            cursorColor: Colors.black,
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              labelText: "İçerik",
              labelStyle: TextStyle(color: Colors.black),
              filled: true,
              fillColor: Color.fromARGB(255, 255, 255, 255),
            ),
            onChanged: (value) {
              content = value;
            },
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Theme.of(context).primaryColor),
                  foregroundColor: WidgetStatePropertyAll(Colors.white)),
              onPressed: () {
                if (title.isNotEmpty && descriptionController.text.isNotEmpty) {
                  setState(() {
                    widget.notes.add(Note(
                        title: title, content: descriptionController.text));
                  });
                }
              },
              child: const Text("Add Note"))
        ],
      ),
    );
  }
}
