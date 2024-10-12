import 'package:flutter/material.dart';
import 'package:note_app/screen/home_page.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final DataBaseHelper dbHelper = DataBaseHelper();
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
                  foregroundColor: const WidgetStatePropertyAll(Colors.white)),
              onPressed: () async {
                if (title.isNotEmpty && descriptionController.text.isNotEmpty) {
                  Note newNote = Note(title: title, content: content);
                  await dbHelper.insertNote(newNote);
                  //await Future.delayed(const Duration(seconds: 2));
                  if (context.mounted) Navigator.of(context).pop(true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Başlık ve içerik Boş olamaz')));
                }
              },
              child: const Text("Add Note"))
        ],
      ),
    );
  }
}
