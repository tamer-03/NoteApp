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

  bool _isSelectionMode = false;
  final Set<int> _selectedNoteIds = {};

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
    return PopScope(
      onPopInvokedWithResult: (value, result) {
        if (value) {
          return;
        }
        _selectedNoteIds.clear();
        _isSelectionMode = false;
        _refreshNotes();
      },
      canPop: false,
      child: Scaffold(
        appBar:
            _isSelectionMode ? _buildSelectionAppBar() : _buildNormalAppBar(),
        body: _builderNoteList(),
        floatingActionButton: _isSelectionMode
            ? null
            : FloatingActionButton(
                onPressed: _goAddNotePage,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(Icons.add),
              ),
      ),
    );
  }

  Widget _builderNoteList() {
    return ListView.builder(
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        final note = _notes[index];
        final isSelected = _selectedNoteIds.contains(note.id);
        return Card(
          color: _isSelectionMode && isSelected
              ? Colors.grey[300]
              : Theme.of(context).primaryColor,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: ListTile(
            trailing: _isSelectionMode
                ? Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedNoteIds.add(note.id!);
                        } else {
                          _selectedNoteIds.remove(note.id!);
                        }

                        if (_selectedNoteIds.isEmpty) {
                          _isSelectionMode = false;
                        }
                      });
                    })
                : null,
            title: Text(
              note.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              _getShortContent(note.content),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: _isSelectionMode
                ? () {
                    setState(() {
                      if (isSelected) {
                        _selectedNoteIds.remove(note.id!);
                        if (_selectedNoteIds.isEmpty) {
                          _isSelectionMode = false;
                        }
                      } else {
                        _selectedNoteIds.add(note.id!);
                      }
                    });
                  }
                : () async {
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
            onLongPress: () {
              setState(() {
                _isSelectionMode = true;
                _selectedNoteIds.add(note.id!);
              });
            },
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

  AppBar _buildNormalAppBar() {
    return AppBar(
      title: const Text('My Notes'),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  AppBar _buildSelectionAppBar() {
    return AppBar(
      title: Text('${_selectedNoteIds.length} Seçildi'),
      backgroundColor: Theme.of(context).primaryColor,
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {
          setState(() {
            _isSelectionMode = false;
            _selectedNoteIds.clear();
          });
        },
        icon: const Icon(Icons.close),
      ),
      actions: [
        IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    alignment: Alignment.bottomCenter,
                    title:
                        const Text("Notları silmek istedğinize emin misiniz?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isSelectionMode = false;
                            _selectedNoteIds.clear();
                          });

                          Navigator.pop(context);
                        },
                        child: const Text('Hayır'),
                      ),
                      TextButton(
                          onPressed: () {
                            _deleteSelectedNotes();
                            Navigator.pop(context);
                          },
                          child: const Text("Evet"))
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete))
      ],
    );
  }

  void _deleteSelectedNotes() async {
    for (var id in _selectedNoteIds) {
      await _dataBaseHelper.deleteNote(id);
    }

    setState(() {
      _isSelectionMode = false;
      _selectedNoteIds.clear();
    });

    _refreshNotes();
  }
}
