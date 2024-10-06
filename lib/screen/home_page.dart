import 'package:flutter/material.dart';
import 'package:note_app/screen/note_detail.dart';

class Note {
  final String title;
  final String content;

  Note({required this.title, required this.content});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Note> notes = [
    Note(
      title: 'Flutter Nedir?',
      content:
          'Flutter, Google tarafından geliştirilen açık kaynaklı bir UI yazılım geliştirme kitidir...',
    ),
    Note(
      title: 'Dart Programlama Dili',
      content:
          'Dart, Flutter uygulamaları geliştirmek için kullanılan bir programlama dilidir...',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _builderNoteList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _builderNoteList() {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: ListTile(
            title: Text(note.title),
            subtitle: Text(
              _getShortContent(note.content),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NoteDetail(
                    note: note,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
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
