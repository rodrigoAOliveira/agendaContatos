import 'dart:io';

import 'package:agenda_contatos/helpers/contactHelper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editedContact;
  bool _userEdited =false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  final _nameFocus = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestpop,
      child:  Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedContact.name ?? "Novo Contato"),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save),
            backgroundColor: Colors.red,
            onPressed: (){

              if(_editedContact.name !=null && _editedContact.name.isNotEmpty){
                Navigator.pop(context,_editedContact);
              }else{
                FocusScope.of(context).requestFocus(_nameFocus);
              }

            }),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center ,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _editedContact.img != null
                            ? FileImage(File(_editedContact.img))
                            : AssetImage("images/person.png")),
                  ),
                ),
                onTap: (){
                  ImagePicker.pickImage(source: ImageSource.camera).then((file){
                    if(file ==null) return;
                    setState(() {
                      _editedContact.img = file.path;
                    });
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Nome",

                ),
                onChanged:(text){
                  _userEdited = true;

                  setState(() {
                    _editedContact.name = text;
                  });
                } ,
                focusNode: _nameFocus,
                controller: _nameController,
              ),

              TextField(
                decoration: InputDecoration(
                  labelText: "Email",

                ),
                onChanged:(text){
                  _userEdited = true;
                  _editedContact.email = text;
                } ,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Phone",

                ),
                onChanged:(text){
                  _userEdited = true;
                  _editedContact.phone = text;
                } ,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              )
            ],
          ),
        ),
      ),
    );
  }

 Future<bool>  _requestpop() {
    if(_userEdited){
      showDialog(context: context,builder: (context){
        return AlertDialog(
          title: Text("Descartar Alterações?"),
          content: Text("Se sair as alterações serão perdidas!") ,
          actions: <Widget>[
            FlatButton(
              child: Text("cancelar"),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("sim"),
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);
              },
            )
          ],
        );
      });
      return Future.value(false);
    }else{
      return Future.value(true);
    }

  }
}
