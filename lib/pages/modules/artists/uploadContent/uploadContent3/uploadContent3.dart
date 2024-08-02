import 'package:flutter/material.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/pages/modules/artists/uploadContent/uploadContent4/uploadContent4.dart';
import 'package:rally/pages/modules/artists/uploadContent/uploadContent5/uploadContent5.dart';
import 'package:rally/spec/colors.dart';

import 'widget/uploadContent3Widget.dart';

final descriptionController = new TextEditingController();
final titleController = new TextEditingController();
final stageNameController = new TextEditingController();

List<String> tagsList = [];

List<Map<String, dynamic>> publicationStatusList = [
  {
    "title": "Instant Publish",
    "description":
        "If the creation is successful, content will be made public automatically.",
    "selected": true,
  },
  {
    "title": "Publish Later",
    "description":
        "After the content is completed, it will be made available to the public manually.",
    "selected": false,
  },
];

int publicationStatusSelectedIndex = 0;

class UploadContent3 extends StatefulWidget {
  final Map<String, dynamic>? meta;

  UploadContent3(this.meta);

  @override
  State<UploadContent3> createState() => _UploadContent3State();
}

class _UploadContent3State extends State<UploadContent3> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _tagController = new TextEditingController();

  FocusNode? _titleFocusNode,
      _descriptionFocusNode,
      _tagFocusNode,
      _stageNameFocusNode;

  int _tagLength = 0, _descriptionLength = 0;
  bool _isTagFull = false, _isDescriptionFull = false;

  @override
  void initState() {
    super.initState();
    _titleFocusNode = new FocusNode();
    _descriptionFocusNode = new FocusNode();
    _tagFocusNode = new FocusNode();
    _stageNameFocusNode = new FocusNode();

    if (stageNameController.text == "")
      stageNameController.text = widget.meta!["stageName"];

    if (widget.meta!["contentType"] == 0)
      titleController.text =
          widget.meta!["contentsFileName"][0].toString().split(".").first;
    else
      titleController.clear();

    // tag length
    for (String tag in tagsList) _tagLength += tag.length;
    _isTagFull = _tagLength > 5000;

    // description length
    _descriptionLength = descriptionController.text.length;
    _isDescriptionFull = _descriptionLength > 5000;
  }

  @override
  void dispose() {
    super.dispose();
    _titleFocusNode!.dispose();
    _descriptionFocusNode!.dispose();
    _tagFocusNode!.dispose();
    _stageNameFocusNode!.dispose();
  }

  void _unfocusAllNodes() {
    _titleFocusNode!.unfocus();
    _descriptionFocusNode!.unfocus();
    _tagFocusNode!.unfocus();
    _stageNameFocusNode!.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Content")),
      body: uploadContent3Widget(
        descriptionController: descriptionController,
        descriptionFocusNode: _descriptionFocusNode,
        tagController: _tagController,
        tagFocusNode: _tagFocusNode,
        titleController: titleController,
        titleFocusNode: _titleFocusNode,
        context: context,
        onContinue: () => _onPreview(),
        onTagDelete: (int index) => _onTagDelete(index),
        onTagAdd: () => _onTagAdd(_tagController.text),
        key: _formKey,
        descriptionLength: _descriptionLength,
        onDescriptionTextChange: (String text) => _onDescriptionTextChange(
          text,
        ),
        tagLength: _tagLength,
        tagsList: tagsList,
        isDescriptionFull: _isDescriptionFull,
        isTagFull: _isTagFull,
        onTagTextChange: (String text) => _onTagAdd(
          text,
          isTextChange: true,
        ),
        meta: widget.meta,
        publicationStatusList: publicationStatusList,
        onAlbumPublication: (int index) => _onAlbumPublication(index),
        stageNameController: stageNameController,
        stageNameFocusNode: _stageNameFocusNode,
      ),
    );
  }

  void _onAlbumPublication(int index) {
    for (var data in publicationStatusList) data["selected"] = false;
    publicationStatusList[index]["selected"] = true;
    publicationStatusSelectedIndex = index;
    setState(() {});
  }

  void _onPreview() {
    _unfocusAllNodes();
    if (!_formKey.currentState!.validate()) return;

    if (_tagController.text.length > 0) _onTagAdd(_tagController.text);

    Map<String, dynamic> meta = {
      ...widget.meta!,
      "title": titleController.text,
      "description": descriptionController.text,
      "tags": tagsList,
      "publicationStatusIndex": publicationStatusSelectedIndex,
      "stageName": stageNameController.text,
    };
    if (widget.meta!["contentType"] == 0)
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UploadContent4(meta),
        ),
      );
    else
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UploadContent5(meta),
        ),
      );
  }

  void _onTagAdd(String text, {bool isTextChange = false}) {
    if (text == "" || text == " ") {
      toastContainer(text: "Enter text", backgroundColor: RED);
      return;
    }
    if (text.contains(";") || !isTextChange) {
      _unfocusAllNodes();
      tagsList += [text.split(";")[0].trimLeft().trimRight()];
      _tagLength = 0;
      for (String tag in tagsList) _tagLength += tag.length;
      _isTagFull = _tagLength > 5000;
      _tagController.clear();
      setState(() {});
    }
  }

  void _onTagDelete(int index) {
    tagsList.removeAt(index);
    _tagLength = 0;
    for (String tag in tagsList) _tagLength += tag.length;
    _isTagFull = _tagLength > 5000;
    setState(() {});
  }

  void _onDescriptionTextChange(String text) {
    _descriptionLength = text.length;
    _isDescriptionFull = _descriptionLength > 5000;
    setState(() {});
  }
}
