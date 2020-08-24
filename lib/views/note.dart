import 'package:flutter/material.dart';
//import 'package:note_app/inherited_widgets/note_inherited_widget.dart';
import 'package:note_app/providers/note_provider.dart';


TextEditingController _titleController = TextEditingController();
TextEditingController _textController = TextEditingController();

enum NoteMode {
  Editing,
  Adding
}

class Note extends StatefulWidget {

  final NoteMode noteMode;
  final Map<String, dynamic> note;

  Note(this.noteMode, this.note);

  @override
  NoteState createState(){
    return new NoteState();
  }


}

class NoteState extends State<Note> {

   //List<Map<String, String>> get _notes => NoteInheritedWidget.of(context).notes;
   
  
  @override
  void didChangeDependencies() {
    if (widget.noteMode == NoteMode.Editing) {
      _titleController.text = widget.note['title'];
    _textController.text = widget.note['note'];
    }
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        actions: <Widget>[
          NoteButton(Icons.save, () {
            final title = _titleController.text;
            final text = _textController.text;
            if (widget?.noteMode == NoteMode.Adding) {
              _titleController.text = '';
              _textController.text = '';
              NoteProvider.insertNote({
                'title': title,
                'note': text
              });
              _titleController.text = '';
              _textController.text = '';
            } else if (widget?.noteMode == NoteMode.Editing) {
                NoteProvider.updateNote({
                  'id': widget.note['id'],
                  'title': _titleController.text,
                  'note': _textController.text ,
                });
                _titleController.text = '';
              _textController.text = '';
            }
            Navigator.pop(context);
            }),
          widget.noteMode == NoteMode.Editing ? NoteButton(Icons.delete, () async {
            await NoteProvider.deleteNote(widget.note['id']);
            _titleController.text = '';
            _textController.text = '';
            Navigator.pop(context);
            }) : NoteButton(null, null)
        ],
        ),
        body: WillPopScope(
          onWillPop: () {
            _titleController.text = '';
            _textController.text = '';
            return Future.value(true);
          },
          child: Form()
          ),
          );
  }
}

class NoteButton extends StatelessWidget {

  final IconData _icon;
  final Function _onPressed;

  NoteButton(this._icon, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return  IconButton(
            // save
            onPressed: _onPressed,
            icon: Icon(_icon),
    );
  }
}

class Form extends StatefulWidget {
  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<Form> {
  
  FocusNode focusNode1;
  @override
  void initState() {
    super.initState();

    focusNode1 = FocusNode();
  }

  void dispose() {
    focusNode1.dispose();

    super.dispose();
  }

  Widget build(BuildContext context) {
    return ListView(
          children: <Widget> [
            Padding(
              padding: const EdgeInsets.only(
                 top: 8.0,
                bottom: 8.0,
                right: 20.0,
                left: 20.0,

              ),
              child: TextField(
                controller: _titleController,
                autofocus: true,
               keyboardType: TextInputType.multiline,
                maxLength: 30,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                  counterText: '',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
                right: 20.0,
                left: 20.0,

              ),
              child: TextField(
                controller: _textController,
                onEditingComplete: () => FocusScope.of(context).requestFocus(focusNode1),
                focusNode: focusNode1,
                keyboardType: TextInputType.multiline,
                maxLength: 19999,
                maxLines: null,
                scrollController: null,
                decoration: InputDecoration(
                  hintText: 'Note',
                  border: InputBorder.none,
                  counterText: '',
                  ),
              ),
            ),
          ]
        );
  }
}