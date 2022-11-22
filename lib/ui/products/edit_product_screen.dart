import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../shared/dialog_utils.dart';
import './products_manager.dart';

class EditProbookScreen extends StatefulWidget {
  static const routeName = '/edit-probook';

  EditProbookScreen(
    Probook? probook, {
    super.key,
  }) {
    if (probook == null) {
      this.probook = Probook(
        id: null,
        title: '',
        author: '',
        description: '',
        imageUrl: '',
      );
    } else {
      this.probook = probook;
    }
  }

  late final Probook probook;

  @override
  State<EditProbookScreen> createState() => _EditProbookScreenState();
}

class _EditProbookScreenState extends State<EditProbookScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _editForm = GlobalKey<FormState>();
  late Probook _editedProbook;
  var _isLoading = false;

  bool _isValidImageUrl(String value) {
    return (value.startsWith('http') || value.startsWith('http')) &&
        (value.endsWith('.png') ||
            value.endsWith('.jpg') ||
            value.endsWith('.jpeg'));
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(() {
      if (!_imageUrlFocusNode.hasFocus) {
        if (!_isValidImageUrl(_imageUrlController.text)) {
          return;
        }
        // Ảnh hợp lệ -> Vẽ lại màn hình để hiện preview
        setState(() {});
      }
    });
    _editedProbook = widget.probook;
    _imageUrlController.text = _editedProbook.imageUrl;
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _editForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    _editForm.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      final probooksManager = context.read<ProbooksManager>();
      if (_editedProbook.id != null) {
        await probooksManager.updateProbook(_editedProbook);
      } else {
        await probooksManager.addProbook(_editedProbook);
      }
    } catch (error) {
      await showErrorDialog(context, 'Something went wrong.');
    }

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Probook'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _editForm,
                child: ListView(
                  children: <Widget>[
                    buildTitleField(),
                    buildAuthorField(),
                    buildProbookPreview(),
                    buildDescriptionField(),
                  ],
                ),
              ),
            ),
    );
  }

  TextFormField buildTitleField() {
    return TextFormField(
      initialValue: _editedProbook.title,
      decoration: const InputDecoration(labelText: 'Title'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
      onSaved: (value) {
        _editedProbook = _editedProbook.copyWith(title: value);
      },
    );
  }

  TextFormField buildAuthorField() {
    return TextFormField(
      initialValue: _editedProbook.author,
      decoration: const InputDecoration(labelText: 'Author'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
      onSaved: (value) {
        _editedProbook = _editedProbook.copyWith(author: value);
      },
    );
  }

  TextFormField buildDescriptionField() {
    return TextFormField(
      initialValue: _editedProbook.description,
      style: TextStyle(color: Color.fromARGB(255, 0, 159, 203)),
      decoration: const InputDecoration(labelText: 'Description'),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a description.';
        }
        if (value.length < 10) {
          return 'Should be at least 10 characters long.';
        }
        return null;
      },
      onSaved: (value) {
        _editedProbook = _editedProbook.copyWith(description: value);
      },
    );
  }

  Widget buildProbookPreview() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.only(
            top: 8,
            right: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _imageUrlController.text.isEmpty
              ? const Text('Enter a URL')
              : FittedBox(
                  child: Image.network(
                    _imageUrlController.text,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        Expanded(
          child: buildImageURLField(),
        ),
      ],
    );
  }

  TextFormField buildImageURLField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Image URL'),
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.done,
      controller: _imageUrlController,
      focusNode: _imageUrlFocusNode,
      onFieldSubmitted: (value) => _saveForm(),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a image URL.';
        }
        if (!_isValidImageUrl(value)) {
          return 'Please enter a valid image URL.';
        }
        return null;
      },
      onSaved: (value) {
        _editedProbook = _editedProbook.copyWith(imageUrl: value);
      },
    );
  }
}
