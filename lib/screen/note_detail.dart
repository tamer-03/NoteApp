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
    Note note = Note(
        id: widget.note.id,
        title: widget.note.title,
        content: widget.note.content);
    await _baseHelper.updateNote(note);
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
          actions: [
            IconButton(
              onPressed: _saveNote,
              icon: const Icon(Icons.save),
            )
          ],
        ),
        body: Column(
          children: [
            TextField(
              controller: _titleController,
              onChanged: (value) {
                widget.note.title = value;
              },
            ),
            TextField(
              controller: _contentController,
              onChanged: (value) {
                widget.note.content = value;
              },
            )
          ],
        ));
  }
}
