import 'package:flutter/material.dart';
import 'package:note_app/model/Note.dart';
import 'package:note_app/repository/data_base_helper.dart';

class NoteDetail extends StatefulWidget {
  final Note note;
  const NoteDetail({super.key, required this.note});

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final DataBaseHelper _baseHelper = DataBaseHelper();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() async {
    if (widget.note.title.isNotEmpty || widget.note.content.isNotEmpty) {
      Note note = Note(
          id: widget.note.id,
          title: widget.note.title,
          content: widget.note.content);
      await _baseHelper.updateNote(note);
    } else {
      await _baseHelper.deleteNote(widget.note.id!);
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Note Detail"),
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
          leading: BackButton(
            onPressed: () {
              _saveNote();
            },
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await _baseHelper.deleteNote(widget.note.id!);
                if (context.mounted) {
                  Navigator.pop(context, true);
                }
              },
              icon: const Icon(Icons.delete),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                cursorColor: Colors.black,
                controller: _titleController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintText: "Başlık",
                  labelStyle: TextStyle(color: Colors.black),
                ),
                onChanged: (value) {
                  widget.note.title = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                maxLines: null,
                cursorColor: Colors.black,
                controller: _contentController,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintText: "Başlık",
                  labelStyle: TextStyle(color: Colors.black),
                ),
                onChanged: (value) {
                  widget.note.content = value;
                },
              )
            ],
          ),
        ));
  }
}
