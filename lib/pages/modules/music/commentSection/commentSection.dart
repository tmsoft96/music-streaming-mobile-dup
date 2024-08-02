import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paginated_items_builder/paginated_items_builder.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/firebase/firebaseService.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/services.dart';
import 'package:rally/models/commentModel.dart';
import 'package:rally/spec/colors.dart';

import 'widget/commentSectionWidget.dart';

class CommentSection extends StatefulWidget {
  final bool? showAppbar;
  final String? contentId;

  CommentSection({
    this.showAppbar = true,
    @required this.contentId,
  });

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final _commentController = new TextEditingController();

  FocusNode? _commentFocusNode;
  String _commentText = "";
  bool _isLoading = false;

  FirebaseService _firebaseService = new FirebaseService();
  CollectionReference? _collectionReference;
  CommentModel? _commentModel;

  @override
  void initState() {
    super.initState();
    _commentFocusNode = new FocusNode();
    _fetchAllComment();
  }

  @override
  void dispose() {
    super.dispose();
    _commentFocusNode!.dispose();
  }

  void _fetchAllComment() {
    _collectionReference = FirebaseFirestore.instance
        .collection("Comments")
        .doc(widget.contentId)
        .collection("users");
  }

  PaginatedItemsResponse<CommentData>? _postsResponse;

  PaginatedItemsResponse<CommentData>? get postsResponse => _postsResponse;

  @override
  Widget build(BuildContext context) {
    return widget.showAppbar!
        ? Scaffold(
            appBar: AppBar(title: Text("Comments and Review")),
            body: _streamContent(),
          )
        : _streamContent();
  }

  Widget _streamContent() {
    return StreamBuilder<QuerySnapshot>(
      stream: _collectionReference!.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _commentModel = CommentModel.fromJson(
            snapshot.data!.docs
                as List<QueryDocumentSnapshot<Map<String, dynamic>>>,
          );
          // print(_commentModel!.data![0].comment);

          return _mainContent();
        }
        if (snapshot.hasError) {
          return widget.showAppbar!
              ? emptyBox(context, msg: "No comment...")
              : emptyBoxLinear(context, msg: "No comment...");
        }
        return shimmerItem();
      },
    );
  }

  Widget _mainContent() {
    return Stack(
      children: [
        commentSectionWidget(
          context: context,
          showTextBox: widget.showAppbar!,
          commentFocusNode: _commentFocusNode,
          commentText: _commentText,
          onComment: () => _onComment(),
          onCommentChange: (String text) {
            setState(() {
              _commentText = text;
            });
          },
          onReaction: (bool reaction, CommentData data) =>
              _onReaction(reaction, data),
          commentController: _commentController,
          model: _commentModel,
          onSeeMore: () => _onSeeMore(),
        ),
        if (_isLoading) customLoadingPage(),
      ],
    );
  }

  void _onSeeMore() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CommentSection(
          contentId: widget.contentId,
        ),
      ),
    );
  }

  void _onReaction(bool reaction, CommentData data) {
    String userId = userModel!.data!.user!.userid!;

    List<String> likeReactionList = data.likeReaction!;
    List<String> unlikeReactionList = data.unlikeReaction!;

    int likeIndex = likeReactionList.indexOf(userId);
    int unlikeIndex = unlikeReactionList.indexOf(userId);

    if (reaction) {
      if (likeIndex == -1) likeReactionList.add(userId);
      if (unlikeIndex != -1) unlikeReactionList.removeAt(unlikeIndex);
    } else {
      if (unlikeIndex == -1) unlikeReactionList.add(userId);
      if (likeIndex != -1) likeReactionList.removeAt(likeIndex);
    }
    _firebaseService.reactionComment(
      contentId: data.contentId,
      commentId: data.commentId,
      allLikeReactorsId: likeReactionList,
      allUnlikeReactorsId: unlikeReactionList,
    );
  }

  Future<void> _onComment() async {
    _commentFocusNode!.unfocus();
    setState(() => _isLoading = true);
    try {
      httpChecker(
        httpRequesting: () => httpRequesting(
          endPoint: COMMENTMUSIC_URL,
          method: HTTPMETHOD.POST,
          httpPostBody: {
            "userid": userModel!.data!.user!.userid,
            "post_id": widget.contentId,
            "content": _commentText,
            "parent": "0",
          },
        ),
        showToastMsg: false,
      );

      await _firebaseService.saveComment(
        contentId: widget.contentId,
        comment: _commentText,
      );
      _commentController.clear();
      setState(() => _isLoading = false);
    } catch (e) {
      toastContainer(
        text: "Unable to post comment. Please try again...",
        backgroundColor: RED,
      );
      setState(() => _isLoading = false);
    }
  }
}
