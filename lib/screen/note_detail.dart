import 'package:flutter/material.dart';
import 'package:note_app/screen/home_page.dart';

class NoteDetail extends StatefulWidget {
  final Note note;
  const NoteDetail({super.key, required this.note});

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Note Detail"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Column(
          children: [Text(widget.note.title), Text(widget.note.content)],
        ));
  }
}
