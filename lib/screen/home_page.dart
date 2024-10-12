import 'package:flutter/material.dart';
import 'package:note_app/screen/add_note.dart';
import 'package:note_app/screen/note_detail.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Note {
  final int? id;
  final String title;
  final String content;

  Note({this.id, required this.title, required this.content});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'content': content};
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
    );
  }
}

class DataBaseHelper {
  static final DataBaseHelper instance = DataBaseHelper._internal();
  factory DataBaseHelper() => instance;
  DataBaseHelper._internal();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'notes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      content Text)''');
  }

  Future<int> insertNote(Note note) async {
    Database db = await database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<Note>> getNotes() async {
    Database db = await database;
    List<Map<String, dynamic>> maps =
        await db.query('notes', orderBy: 'id DESC');
    return maps.map((map) => Note.fromMap(map)).toList();
  }

  Future<int> deleteNote(int id) async {
    Database db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateNote(Note note) async {
    Database db = await database;
    return await db
        .update('notes', note.toMap(), where: 'id = ? ', whereArgs: [note.id]);
  }
}

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

  void _goAddNotePage() async {
    bool? isNoteAdded = await Navigator.of(this.context)
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
