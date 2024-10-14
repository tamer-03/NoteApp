import 'package:flutter/material.dart';
import 'package:note_app/model/Note.dart';
import 'package:note_app/screen/add_note.dart';
import 'package:note_app/screen/note_detail.dart';
import 'package:note_app/repository/data_base_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DataBaseHelper _dataBaseHelper = DataBaseHelper();
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  Future<void> _refreshNotes() async {
    List<Note> notes = await _dataBaseHelper.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _builderNoteList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _goAddNotePage,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _builderNoteList() {
    return ListView.builder(
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        final note = _notes[index];
        return Card(
          color: Theme.of(context).primaryColor,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: ListTile(
            title: Text(
              note.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              _getShortContent(note.content),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () async {
              bool? isNoteUpdated = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NoteDetail(
                    note: note,
                  ),
                ),
              );
              if (isNoteUpdated ?? false) {
                _refreshNotes();
              }
            },
            trailing: IconButton(
              onPressed: () async {
                await _dataBaseHelper.deleteNote(note.id!);
                _refreshNotes();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('note silindi')));
                }
              },
              icon: const Icon(Icons.delete),
            ),
          ),
        );
      },
    );
  }

  void _goAddNotePage() async {
    bool? isNoteAdded = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const AddNote()));

    if (isNoteAdded == true) {
      _refreshNotes();
    }
  }

  String _getShortContent(String content) {
    const int maxLength = 50; // Kısaltmak istediğiniz karakter sayısı
    if (content.length <= maxLength) {
      return content;
    } else {
      return '${content.substring(0, maxLength)}...';
    }
  }
}
