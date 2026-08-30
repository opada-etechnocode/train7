import 'package:mobx/mobx.dart';
import '../utils/shared_import.dart';

/// Shared utility for relative time display in comments
String extractRelativeTime(String createdAt) {
  if (createdAt.contains("on")) {
    return createdAt.split("on")[0].trim();
  }
  return createdAt;
}

class ExpandableLinkify extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextStyle? linkStyle;
  final int trimLines;
  final bool fromComment;

  const ExpandableLinkify({
    super.key,
    required this.text,
    this.style,
    this.linkStyle,
    this.trimLines = 3,
    this.fromComment = false,
  });

  @override
  _ExpandableLinkifyState createState() => _ExpandableLinkifyState();
}

class _ExpandableLinkifyState extends State<ExpandableLinkify> {
  bool _expanded = false;
  bool _isOverflow = false;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      final textSpan = TextSpan(
        text: widget.text,
        style: widget.style ?? DefaultTextStyle.of(context).style,
      );
      final tp = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        maxLines: widget.trimLines,
        ellipsis: '…',
      );

      tp.layout(maxWidth: constraints.maxWidth);

      _isOverflow = tp.didExceedMaxLines;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Linkify(
            onOpen: (link) async {
              final uri = Uri.parse(link.url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                toast('Could not open ${link.url}');
              }
            },
            text: widget.text,
            style: widget.style,
            linkStyle: widget.linkStyle,
            maxLines: _expanded ? null : widget.trimLines,
            overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          if (_isOverflow)
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  _expanded ? languages.lblReadLess : languages.lblReadMore,
                  style: (widget.style ?? DefaultTextStyle.of(context).style)
                      .copyWith(
                        color: primaryColor,
                        fontWeight: widget.fromComment ? null : FontWeight.w600,
                      ),
                ),
              ),
            ),
        ],
      );
    },
  );
}

class Post {
  Future<void> deletePost(dynamic id, ObservableList<dynamic> mPostList) async {
    appStore.setLoading(true);
    final Map<String, dynamic> req = {"id": id};
    await deletePostApi(req)
        .then((value) {
          mPostList.removeWhere((item) {
            if (item is PostData) {
              return item.id == id;
            }
            if (item is BookmarkData) {
              return item.posts?.id == id;
            }
            return false;
          });
          appStore.setLoading(false);
        })
        .catchError((Object e) {
          appStore.setLoading(false);
        });
  }

  void showAnimatedDialog(BuildContext context, int? postId, VoidCallback fn) {
    final TextEditingController textController = TextEditingController();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (BuildContext context, Animation<double> animation1, Animation<double> animation2) => PopScope(
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            languages.lblReports,
            style: primaryTextStyle(
              color: appStore.isDarkMode ? Colors.white : scaffoldColorDark,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: primaryTextStyle(
                  color: appStore.isDarkMode ? Colors.white : scaffoldColorDark,
                ),
                controller: textController,
                decoration: InputDecoration(
                  labelText: languages.lblRepoDes,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(languages.lblCancel),
            ),
            ElevatedButton(
              onPressed: () async {
                if (textController.text.trim().isNotEmpty) {
                  await reportComment(textController.text.trim(), postId, fn);
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                }
              },
              child: Text(languages.lblReports),
            ),
          ],
        ),
      ),
      transitionBuilder: (BuildContext context, Animation<double> animation1, Animation<double> animation2, Widget child) =>
          ScaleTransition(
            scale: CurvedAnimation(parent: animation1, curve: Curves.easeInOut),
            child: child,
          ),
    );
  }

  Future<void> reportComment(String? reason, int? postId, VoidCallback fn) async {
    final Map<String, dynamic> req = {"posting_id": postId, "reason": reason};
    await reportApi(req)
        .then((value) {
          toast(value.message.validate());
          fn.call();
          appStore.setLoading(false);
        })
        .catchError((Object e) {
          appStore.setLoading(false);
        });
  }

  Future<void> likePost(int? postingId) async {
    final Map<String, dynamic> req = {"posting_id": postingId};
    await likePostApi(req)
        .then((value) {
          appStore.setLoading(false);
        })
        .catchError((Object e) {
          appStore.setLoading(false);
        });
  }

  void showFullScreenDialog(
    BuildContext context,
    List<String>? imageUrl,
    String? userName,
    int index,
  ) {
    Navigator.of(context).push<void>(
      PageRouteBuilder<void>(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => FullScreenDialogContent(
          imageUrls: imageUrl.validate(),
          userName: userName,
          initialIndex: index,
        ),
        transitionsBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) => FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  Future<void> bookMarkPost(dynamic id, {VoidCallback? fn}) async {
    final Map<String, dynamic> req = {"posting_id": id};
    await bookMarkPostApi(req)
        .then((value) {
          if (fn != null) {
            fn.call();
          }
        })
        .catchError((Object e) {
          debugPrint('----error-$e---');
        });
  }
}

class LikeComment {
  final TextEditingController commentController = TextEditingController();
  bool isLastPageComment = false;
  int pageComment = 1;
  int? numPageComment;

  int pageLike = 1;
  int? numPageLike;
  bool isLastPageLike = false;
  bool isLastPage = false;

  ObservableList<CommentData> mCommentList = ObservableList<CommentData>();
  ObservableList<BookmarkData> mLikeList = ObservableList<BookmarkData>();
  List<bool> isShowReply = [];

  final ScrollController scrollControllerComment = ScrollController();
  final ScrollController scrollControllerLikes = ScrollController();

  Future<void> updateCommentReply(int? commentId, int? id) async {
    final Map<String, dynamic> req = {
      "id": id,
      "comment_id": commentId,
      "comment": commentController.text,
    };
    await saveReCommentApi(req)
        .then((value) {
          appStore.setLoading(false);
          commentController.clear();
        })
        .catchError((Object e) {
          appStore.setLoading(false);
        });
  }

  Future<void> addComment(int? postId, int? reshreshPostId) async {
    final Map<String, dynamic> req = {
      "id": null,
      "posting_id": postId,
      "comment": commentController.text,
    };
    await saveCommentApi(req)
        .then((value) {
          appStore.setLoading(false);
          commentController.clear();
        })
        .catchError((Object e) {
          appStore.setLoading(false);
        });
  }

  Future<void> updateComment(int? commentId) async {
    final Map<String, dynamic> req = {"comment": commentController.text};
    await updateCommentApi(req, commentId)
        .then((value) {
          appStore.setLoading(false);
          commentController.clear();
        })
        .catchError((Object e) {
          appStore.setLoading(false);
        });
  }

  Future<void> updateReComment(int? commentId, int postingId) async {
    final Map<String, dynamic> req = {
      "id": commentId,
      "posting_id": postingId,
      "comment": commentController.text,
    };
    await updateReCommentApi(req)
        .then((value) {
          appStore.setLoading(false);
          commentController.clear();
        })
        .catchError((Object e) {
          appStore.setLoading(false);
        });
  }

  Future<void> likesList(int? postId, {bool isFirstTime = false}) async {
    if (isFirstTime) {
      appStore.setLoading(true);
    }
    await likesListApi(postId.validate(), pageLike)
        .then((value) {
          appStore.setLoading(false);
          numPageLike = value.pagination!.totalPages;
          isLastPageLike = false;
          if (pageLike == 1) {
            mLikeList.clear();
          }
          final Iterable<BookmarkData> it = value.data!;
          it.map((BookmarkData e) {
            mLikeList.add(e);
          }).toList();
        })
        .catchError((Object e) {
          isLastPage = true;
          appStore.setLoading(false);
        });
  }

  Future<void> commentList(int? postId, {bool isFirstTime = false}) async {
    if (isFirstTime) {
      appStore.setLoading(true);
    }
    appStore.setLoading(true);
    await commentListApi(postId.validate(), pageComment)
        .then((value) {
          appStore.setLoading(false);
          numPageComment = value.pagination!.totalPages;
          isLastPageComment = false;
          if (pageComment == 1) {
            mCommentList.clear();
            isShowReply.clear();
          }
          final Iterable<CommentData> it = value.data!;
          it.map((CommentData e) {
            mCommentList.add(e);
            isShowReply.add(true);
          }).toList();
        })
        .catchError((Object e) {
          isLastPage = true;
          appStore.setLoading(false);
        });
  }

  void bottomSheetBuilder(
    int index,
    int? postId,
    int? userId,
    bool isMyPost,
    BuildContext context,
    List<dynamic> mPostList, {
    bool isFirstTime = false,
    bool fromBookmark = false,
  }) {
    String? replyComment = '';
    String? replyId = '';
    String? replyName = '';
    String? updateText = '';
    String? updateReText = '';
    int? updateCommentId = 0;
    int? updateReCommentId = -1;
    final FocusNode focusNode = FocusNode();

    late VoidCallback pagination;

    pagination = () async {
      if (scrollControllerComment.position.pixels ==
              scrollControllerComment.position.maxScrollExtent &&
          !appStore.isLoading) {
        if (pageComment < numPageComment!) {
          pageComment++;
          appStore.setLoading(true);

          await commentListApi(postId!, pageComment).then((value) {
            appStore.setLoading(false);
            numPageComment = value.pagination!.totalPages;
            isLastPageComment = false;

            if (pageComment == 1) {
              mCommentList.clear();
              isShowReply.clear();
            }

            final Iterable<CommentData> it = value.data!;
            for (var e in it) {
              mCommentList.add(e);
              isShowReply.add(true);
            }
          });
        }
      }
    };
    scrollControllerComment.addListener(pagination);

    showModalBottomSheet<void>(
      showDragHandle: true,
      backgroundColor: appStore.isDarkMode ? scaffoldColorDark : Colors.white,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setState) => SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languages.lblComments,
                      style: boldTextStyle(size: 24),
                    ).paddingOnly(left: 12),
                    20.height,
                    Expanded(
                      child: Observer(
                        builder: (_) => appStore.isLoading && isFirstTime
                            ? const SizedBox.shrink()
                            : ListView.builder(
                                controller: scrollControllerComment,
                                shrinkWrap: true,
                                itemCount: mCommentList.length,
                                itemBuilder: (BuildContext context, int i) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (mCommentList[i].userId !=
                                                    null &&
                                                mCommentList[i].userId !=
                                                    userStore.userId) {
                                              if (mCommentList[i].users !=
                                                  null) {
                                                OtherUserProfileScreen(
                                                  userDetails:
                                                      mCommentList[i].users!,
                                                ).launch<void>(context);
                                              }
                                            } else {
                                              const EditProfileScreen().launch<void>(
                                                context,
                                              );
                                            }
                                          },
                                          child: cachedImage(
                                            mCommentList[i].users?.profileImage,
                                            fit: BoxFit.cover,
                                            height: 33,
                                            width: 33,
                                          ).cornerRadiusWithClipRRect(20),
                                        ),
                                        8.width,
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (mCommentList[i]
                                                                .userId !=
                                                            null &&
                                                        mCommentList[i]
                                                                .userId !=
                                                            userStore.userId) {
                                                      if (mCommentList[i]
                                                              .users !=
                                                          null) {
                                                        OtherUserProfileScreen(
                                                          userDetails:
                                                              mCommentList[i]
                                                                  .users!,
                                                        ).launch<void>(context);
                                                      }
                                                    } else {
                                                      const EditProfileScreen()
                                                          .launch<void>(context);
                                                    }
                                                  },
                                                  child: Text(
                                                    mCommentList[i]
                                                            .users
                                                            ?.displayName ??
                                                        '',
                                                    style: boldTextStyle(
                                                      size: 15,
                                                    ),
                                                    maxLines: 3,
                                                  ),
                                                ),
                                                8.width,
                                                Text(
                                                  extractRelativeTime(
                                                    mCommentList[i].createdAt
                                                        .toString(),
                                                  ),
                                                  style: secondaryTextStyle(
                                                    size: 12,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                            2.height,
                                            ExpandableLinkify(
                                              text:
                                                  mCommentList[i].comment ?? '',
                                              style: primaryTextStyle(size: 15),
                                              linkStyle: const TextStyle(
                                                color: primaryColor,
                                                decoration: TextDecoration.none,
                                              ),
                                              fromComment: true,
                                              trimLines: 2,
                                            ),
                                          ],
                                        ).expand(),
                                        8.width,
                                        if (mCommentList[i].userId ==
                                                userStore.userId ||
                                            isMyPost)
                                          PopupMenuButton<int>(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            color: primaryOpacity,
                                            itemBuilder: (BuildContext context) => [
                                              if (mCommentList[i].canEdit
                                                  .validate()) ...[
                                                PopupMenuItem(
                                                  onTap: () async {
                                                    updateReText =
                                                        mCommentList[i]
                                                            .comment ??
                                                        '';
                                                    updateCommentId =
                                                        mCommentList[i].id ?? 0;
                                                    commentController.text =
                                                        mCommentList[i]
                                                            .comment ??
                                                        '';
                                                    setState(() {});
                                                  },
                                                  value: 2,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Icon(
                                                        FontAwesomeIcons.pen,
                                                        size: 16,
                                                        color: Colors.black,
                                                      ),
                                                      6.width,
                                                      Text(
                                                        languages.edtCmt,
                                                        style: primaryTextStyle(
                                                          color:
                                                              scaffoldColorDark,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem<int>(
                                                  enabled: false,
                                                  height: 1,
                                                  padding: EdgeInsets.zero,
                                                  child: Container(
                                                    height: 1,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                              PopupMenuItem(
                                                onTap: () async {
                                                  showConfirmDialogCustom(
                                                    Navigator.of(
                                                      context,
                                                      rootNavigator: true,
                                                    ).context,
                                                    dialogType:
                                                        DialogType.DELETE,
                                                    title: languages
                                                        .confirmDeleteComment,
                                                    positiveText:
                                                        languages.lblDelete,
                                                    image: ic_delete,
                                                    onAccept: (BuildContext buildContext) async {
                                                      final Map<String, dynamic> req = {
                                                        "id":
                                                            mCommentList[i].id,
                                                      };
                                                      appStore.setLoading(true);
                                                      await deleteReCommentApi(
                                                            req,
                                                          )
                                                          .then((value) {
                                                            if (fromBookmark) {
                                                              mPostList[index]
                                                                      .posts!
                                                                      .postingCommentCount =
                                                                  mPostList[index]
                                                                      .posts!
                                                                      .postingCommentCount! -
                                                                  1;
                                                            } else {
                                                              mPostList[index]
                                                                      .postingCommentCount =
                                                                  mPostList[index]
                                                                      .postingCommentCount! -
                                                                  1;
                                                            }
                                                            appStore.setLoading(
                                                              false,
                                                            );
                                                          })
                                                          .catchError((Object e) {
                                                            appStore.setLoading(
                                                              false,
                                                            );
                                                          });
                                                      await commentList(postId);
                                                    },
                                                  );
                                                },
                                                value: 3,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons.delete,
                                                      size: 20,
                                                      color: Colors.black,
                                                    ),
                                                    6.width,
                                                    Text(
                                                      languages.dltCmt,
                                                      style: primaryTextStyle(
                                                        color:
                                                            scaffoldColorDark,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            child: Image.asset(
                                              ic_menu,
                                              height: 24,
                                              width: 24,
                                              color: primaryColor,
                                            ),
                                          ),
                                      ],
                                    ),
                                    8.height,
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          replyComment =
                                              mCommentList[i].comment ?? "";
                                          replyName =
                                              mCommentList[i]
                                                  .users
                                                  ?.displayName ??
                                              "";
                                          replyId = mCommentList[i].id
                                              .toString();
                                          commentController.clear();
                                          FocusScope.of(
                                            context,
                                          ).requestFocus(focusNode);
                                        });
                                      },
                                      child: Text(
                                        languages.lblReply,
                                        style: secondaryTextStyle(
                                          size: 13,
                                          color: primaryColor,
                                        ),
                                      ).paddingSymmetric(horizontal: 36),
                                    ),
                                    8.height,
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          updateText = '';
                                          setState(() {
                                            isShowReply[i] = !isShowReply[i];
                                          });
                                        });
                                      },
                                      child: Text(
                                        !isShowReply[i]
                                            ? languages.lblViewR
                                            : languages.lblHideR,
                                        style: secondaryTextStyle(
                                          size: 13,
                                          color: primaryColor,
                                        ),
                                      ).paddingSymmetric(horizontal: 36),
                                    ).visible(
                                      mCommentList[i].commentReplyCount
                                              .validate() >
                                          0,
                                    ),
                                    AnimatedListView(
                                      itemCount:
                                          mCommentList[i].commentReplyCount ??
                                          0,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (BuildContext context, int recommentIndex) => Padding(
                                        padding: const EdgeInsets.only(
                                          left: 15,
                                          top: 7,
                                          bottom: 7,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (mCommentList[i]
                                                                .commentReply?[recommentIndex]
                                                                .userId !=
                                                            null &&
                                                        mCommentList[i]
                                                                .commentReply?[recommentIndex]
                                                                .userId !=
                                                            userStore.userId) {
                                                      if (mCommentList[i]
                                                              .commentReply?[recommentIndex]
                                                              .users !=
                                                          null) {
                                                        OtherUserProfileScreen(
                                                          userDetails:
                                                              mCommentList[i]
                                                                  .commentReply![recommentIndex]
                                                                  .users!,
                                                        ).launch<void>(context);
                                                      }
                                                    } else {
                                                      const EditProfileScreen()
                                                          .launch<void>(context);
                                                    }
                                                  },
                                                  child: cachedImage(
                                                    mCommentList[i]
                                                            .commentReply?[recommentIndex]
                                                            .users
                                                            ?.profileImage ??
                                                        '',
                                                    fit: BoxFit.cover,
                                                    height: 35,
                                                    width: 35,
                                                  ).cornerRadiusWithClipRRect(20),
                                                ),
                                                const SizedBox(width: 8),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            if (mCommentList[i]
                                                                        .commentReply?[recommentIndex]
                                                                        .userId !=
                                                                    null &&
                                                                mCommentList[i]
                                                                        .commentReply?[recommentIndex]
                                                                        .userId !=
                                                                    userStore
                                                                        .userId) {
                                                              if (mCommentList[i]
                                                                      .commentReply?[recommentIndex]
                                                                      .users !=
                                                                  null) {
                                                                OtherUserProfileScreen(
                                                                  userDetails:
                                                                      mCommentList[i]
                                                                          .commentReply![recommentIndex]
                                                                          .users!,
                                                                ).launch<void>(
                                                                  context,
                                                                );
                                                              }
                                                            } else {
                                                              const EditProfileScreen()
                                                                  .launch<void>(
                                                                    context,
                                                                  );
                                                            }
                                                          },
                                                          child: Text(
                                                            mCommentList[i]
                                                                    .commentReply?[recommentIndex]
                                                                    .users
                                                                    ?.displayName ??
                                                                '',
                                                            style:
                                                                boldTextStyle(
                                                                  size: 15,
                                                                ),
                                                            maxLines: 3,
                                                          ),
                                                        ),
                                                        6.width,
                                                        Text(
                                                          extractRelativeTime(
                                                            mCommentList[i]
                                                                    .commentReply?[recommentIndex]
                                                                    .createdAt
                                                                    .toString() ??
                                                                "",
                                                          ),
                                                          style:
                                                              secondaryTextStyle(
                                                                size: 12,
                                                              ),
                                                          maxLines: 1,
                                                        ),
                                                      ],
                                                    ),
                                                    ExpandableLinkify(
                                                      text:
                                                          mCommentList[i]
                                                              .commentReply?[recommentIndex]
                                                              .comment ??
                                                          '',
                                                      style: primaryTextStyle(
                                                        size: 15,
                                                      ),
                                                      fromComment: true,
                                                      linkStyle:
                                                          const TextStyle(
                                                            color: primaryColor,
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                          ),
                                                    ),
                                                  ],
                                                ).expand(),
                                                8.width,
                                                if (mCommentList[i]
                                                            .commentReply![recommentIndex]
                                                            .userId ==
                                                        userStore.userId ||
                                                    isMyPost)
                                                  PopupMenuButton<int>(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    color: primaryOpacity,
                                                    itemBuilder: (BuildContext context) => [
                                                      if (mCommentList[i]
                                                          .commentReply![recommentIndex]
                                                          .canEdit
                                                          .validate()) ...[
                                                        PopupMenuItem(
                                                          onTap: () async {
                                                            replyName =
                                                                mCommentList[i]
                                                                    .users
                                                                    ?.displayName ??
                                                                "";
                                                            updateReText =
                                                                mCommentList[i]
                                                                    .commentReply![recommentIndex]
                                                                    .comment ??
                                                                '';
                                                            updateReCommentId =
                                                                mCommentList[i]
                                                                    .commentReply![recommentIndex]
                                                                    .id ??
                                                                -1;
                                                            updateCommentId =
                                                                mCommentList[i]
                                                                    .commentReply![recommentIndex]
                                                                    .commentId ??
                                                                0;
                                                            commentController
                                                                    .text =
                                                                mCommentList[i]
                                                                    .commentReply![recommentIndex]
                                                                    .comment ??
                                                                '';
                                                            FocusScope.of(
                                                              context,
                                                            ).requestFocus(
                                                              focusNode,
                                                            );
                                                            setState(() {});
                                                          },
                                                          value: 2,
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              const Icon(
                                                                FontAwesomeIcons
                                                                    .pen,
                                                                size: 16,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              6.width,
                                                              Text(
                                                                languages
                                                                    .edtRpl,
                                                                style: primaryTextStyle(
                                                                  color:
                                                                      scaffoldColorDark,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        PopupMenuItem<int>(
                                                          enabled: false,
                                                          height: 1,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          child: Container(
                                                            height: 1,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                      PopupMenuItem(
                                                        onTap: () async {
                                                          showConfirmDialogCustom(
                                                            Navigator.of(
                                                              context,
                                                              rootNavigator:
                                                                  true,
                                                            ).context,
                                                            dialogType:
                                                                DialogType
                                                                    .DELETE,
                                                            title: languages
                                                                .confirmDeleteCommentReply,
                                                            positiveText:
                                                                languages
                                                                    .lblDelete,
                                                            image: ic_delete,
                                                            onAccept: (BuildContext buildContext) async {
                                                              final Map<String, dynamic> req = {
                                                                "id": mCommentList[i]
                                                                    .commentReply![recommentIndex]
                                                                    .id,
                                                              };
                                                              appStore
                                                                  .setLoading(
                                                                    true,
                                                                  );
                                                              await deleteCommentReplyApi(
                                                                    req,
                                                                  )
                                                                  .then((
                                                                    value,
                                                                  ) {
                                                                    appStore
                                                                        .setLoading(
                                                                          false,
                                                                        );
                                                                  })
                                                                  .catchError((
                                                                    Object e,
                                                                  ) {
                                                                    appStore
                                                                        .setLoading(
                                                                          false,
                                                                        );
                                                                  });
                                                              await commentList(
                                                                postId,
                                                              );
                                                            },
                                                          );
                                                        },
                                                        value: 3,
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const Icon(
                                                              Icons.delete,
                                                              size: 20,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            6.width,
                                                            Text(
                                                              languages.dltRpl,
                                                              style: primaryTextStyle(
                                                                color:
                                                                    scaffoldColorDark,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                    child: Image.asset(
                                                      ic_menu,
                                                      height: 24,
                                                      width: 24,
                                                      color: primaryColor,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).visible(
                                      mCommentList[i].commentReplyCount
                                                  .validate() >
                                              0 &&
                                          isShowReply[i],
                                    ),
                                    10.height,
                                  ],
                                ).paddingSymmetric(horizontal: 16),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 200, bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          20.width,
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: languages.lblReplyTo,
                                  style: secondaryTextStyle(
                                    size: 12,
                                    color: appStore.isDarkMode
                                        ? Colors.white
                                        : scaffoldColorDark,
                                  ),
                                ),
                                TextSpan(
                                  text: replyName,
                                  style: primaryTextStyle(
                                    size: 13,
                                    color: primaryColor,
                                    weight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          5.width,
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                replyComment = '';
                                replyName = '';
                                replyId = '';
                                updateText = '';
                                updateReText = '';
                                commentController.text = '';
                              });
                            },
                            child: Icon(
                              Icons.close,
                              size: 15,
                              color: appStore.isDarkMode
                                  ? Colors.white
                                  : scaffoldColorDark,
                            ),
                          ),
                        ],
                      ),
                    ).visible(replyName?.isNotEmpty ?? false),
                    Row(
                      children: [
                        SizedBox(
                          height: 50,
                          child: AppTextField(
                            focus: focusNode,
                            controller: commentController,
                            textFieldType: TextFieldType.MULTILINE,
                            isValidationRequired: true,
                            decoration: defaultInputDecoration(
                              context,
                              label: languages.lblAddComments,
                            ),
                          ),
                        ).expand(),
                        8.width,
                        const Icon(
                          Icons.send,
                          color: primaryColor,
                        ).onTap(() async {
                          if (commentController.text.isNotEmpty) {
                            appStore.setLoading(true);
                            if (replyComment?.isNotEmpty ?? true) {
                              final Map<String, dynamic> req = {
                                "id": null,
                                "comment_id": replyId,
                                "comment": commentController.text,
                              };
                              await saveReCommentApi(req)
                                  .then((value) {
                                    appStore.setLoading(false);
                                    commentController.clear();
                                    replyComment = '';
                                    replyName = '';
                                    replyId = '';
                                  })
                                  .catchError((Object e) {
                                    appStore.setLoading(false);
                                  });
                            } else if (updateReText?.isNotEmpty == true &&
                                updateReCommentId != -1 &&
                                updateCommentId != 0) {
                              await updateCommentReply(
                                updateCommentId,
                                updateReCommentId,
                              );
                              updateReText = '';
                              updateReCommentId = -1;
                              updateCommentId = 0;
                              await commentList(postId);
                              return;
                            } else {
                              if (updateReText?.isNotEmpty == true) {
                                if (fromBookmark) {
                                  await updateReComment(
                                    updateCommentId,
                                    mPostList[index].postingId,
                                  );
                                } else {
                                  await updateReComment(
                                    updateCommentId,
                                    mPostList[index].id,
                                  );
                                }
                                updateReText = '';
                                updateCommentId = 0;
                                await commentList(postId);
                                return;
                              }
                              if (updateText?.isNotEmpty == true) {
                                await updateComment(updateCommentId);
                                updateText = '';
                                updateCommentId = 0;
                              } else {
                                if (fromBookmark) {
                                  mPostList[index].posts!.postingCommentCount =
                                      mPostList[index]
                                          .posts!
                                          .postingCommentCount! +
                                      1;
                                  await addComment(
                                    mPostList[index].postingId,
                                    postId,
                                  );
                                } else {
                                  mPostList[index].postingCommentCount =
                                      mPostList[index].postingCommentCount! + 1;
                                  await addComment(mPostList[index].id, postId);
                                }
                              }
                            }
                            await commentList(postId);
                          }
                        }),
                      ],
                    ).paddingOnly(bottom: 16, left: 16, right: 16),
                  ],
                ),
              ),
              Observer(
                builder: (BuildContext context) => SizedBox(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height,
                  child: const Loader().visible(appStore.isLoading).center(),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((value) {
      scrollControllerComment.removeListener(pagination);
    });
  }

  void bottomSheetForLike(
    int index,
    int? postId,
    int? userId,
    BuildContext context, {
    bool isFirstTime = false,
  }) {
    late VoidCallback pagination;

    pagination = () async {
      if (scrollControllerLikes.position.pixels ==
              scrollControllerLikes.position.maxScrollExtent &&
          !appStore.isLoading) {
        if (pageLike < numPageLike!) {
          pageLike++;
          appStore.setLoading(true);

          await likesListApi(postId!, pageLike).then((value) {
            appStore.setLoading(false);
            numPageLike = value.pagination!.totalPages;
            isLastPageLike = false;

            if (pageLike == 1) {
              mLikeList.clear();
            }

            final Iterable<BookmarkData> it = value.data!;
            for (var e in it) {
              mLikeList.add(e);
            }
          });
        }
      }
    };
    scrollControllerLikes.addListener(pagination);

    showModalBottomSheet<void>(
      showDragHandle: true,
      backgroundColor: appStore.isDarkMode ? scaffoldColorDark : Colors.white,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setState) => SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languages.lblLikes,
                      style: boldTextStyle(size: 24),
                    ).paddingOnly(left: 12),
                    20.height,
                    Expanded(
                      child: Observer(
                        builder: (_) => appStore.isLoading && isFirstTime
                            ? const SizedBox.shrink()
                            : ListView.builder(
                                controller: scrollControllerLikes,
                                shrinkWrap: true,
                                itemCount: mLikeList.length,
                                itemBuilder: (BuildContext context, int i) => GestureDetector(
                                  onTap: () {
                                    if (mLikeList[i].userId != null &&
                                        mLikeList[i].userId !=
                                            userStore.userId) {
                                      if (mLikeList[i].users != null) {
                                        OtherUserProfileScreen(
                                          userDetails: mLikeList[i].users!,
                                        ).launch<void>(context);
                                      }
                                    } else {
                                      const EditProfileScreen().launch<void>(context);
                                    }
                                  },
                                  child:
                                      Row(
                                        children: [
                                          cachedImage(
                                            mLikeList[i].profileImage,
                                            fit: BoxFit.cover,
                                            height: 40,
                                            width: 40,
                                          ).cornerRadiusWithClipRRect(20),
                                          8.width,
                                          Text(
                                            mLikeList[i].displayName ?? '',
                                            style: boldTextStyle(size: 16),
                                            maxLines: 3,
                                          ).expand(),
                                        ],
                                      ).paddingOnly(
                                        left: 16,
                                        right: 16,
                                        bottom: 16,
                                      ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Observer(
                builder: (BuildContext context) => SizedBox(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height,
                  child: const Loader().visible(appStore.isLoading).center(),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((value) {
      scrollControllerLikes.removeListener(pagination);
    });
  }
}
