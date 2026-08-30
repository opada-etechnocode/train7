import '../utils/shared_import.dart';

class ChattingScreen extends StatefulWidget {
  static String tag = '/chatgpt';

  final bool isDirect;

  const ChattingScreen({super.key, this.isDirect = false});

  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  ChatGpt chatGpt = ChatGpt(apiKey: userStore.chatGptApiKey);
  // ChatGpt chatGpt = ChatGpt(apiKey: 'sk-svcacct-xWAWbkRImZNtREsm7AAudC2NPAkVllIFWZTFy2NidrZJ1TceuZpdCGKegEBBwST3BlbkFJaIZ0xNzL1PiMY05mv8u55Ejkt7HyJirbNU4MmbCLMwEuMnwjEuoktCU1Mick4A');
  // ChatGpt chatGpt = ChatGpt(apiKey: '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');
  ScrollController scrollController = ScrollController();

  TextEditingController msgController = TextEditingController();

  StreamSubscription<StreamCompletionResponse>? streamSubscription;

  final List<QuestionAnswerModel> questionAnswers = [];
  List<Message> myMessages = [];
  int adCount = 0;
  int selectedIndex = -1;

  String lastError = "";
  String lastStatus = "";
  String selectedText = '';
  String question = '';

  bool isBannerLoad = false;
  bool isShowOption = false;
  bool isSelectedIndex = false;
  bool isScroll = false;

  @override
  void initState() {
    super.initState();
    Future<void>.value().then((_) {
      init();
    });
  }

  Future<void> init() async {
    hideKeyboard(context);
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = status;
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> sendMessage() async {
    hideKeyboard(context);

    if (selectedText.isNotEmpty) {
      question = selectedText + msgController.text;
      setState(() {});
    } else {
      question = msgController.text;
      setState(() {});
    }
    msgController.clear();
    questionAnswers.insert(
      0,
      QuestionAnswerModel(
        question: question,
        answer: StringBuffer(),
        isLoading: true,
        smartCompose: selectedText,
      ),
    );
    setState(() {});
    myMessages.add(Message(role: Role.user.name, content: question));
    final testRequest = ChatCompletionRequest(
      stream: true,
      maxTokens: 4000,
      messages: myMessages,
      model: ChatGptModel.gpt35Turbo.modelName,
    );

    await _streamResponse(testRequest);

    questionAnswers[0].isLoading = false;
    setState(() {});
  }

  Future<dynamic> _streamResponse(ChatCompletionRequest request) async {
    streamSubscription?.cancel();

    try {
      final stream = await chatGpt.createChatCompletionStream(request);
      streamSubscription = stream?.listen((event) {
        myMessages.add(
          Message(
            role: "assistant",
            content: "${event.choices?.first.delta?.content}",
          ),
        );
        if (event.streamMessageEnd) {
          streamSubscription?.cancel();
        } else {
          return questionAnswers.first.answer!.write(
            event.choices?.first.delta?.content,
          );
        }
        setState(() {});
      });
    } on Exception catch (error) {
      questionAnswers.first.answer!.write("Too many requests please try again");
      log("Error occurred: $error");
      setState(() {});
    }
  }

  void showDialog() {
    showConfirmDialogCustom(
      context,
      title: languages.lblChatConfirmMsg,
      positiveText: languages.lblYes,
      positiveTextColor: Colors.white,
      image: ic_logo,
      negativeText: languages.lblNo,
      onAccept: (p0) {
        questionAnswers.clear();
      },
    );
  }

  void share(
    BuildContext context, {
    required List<QuestionAnswerModel> questionAnswers,
    RenderBox? box,
  }) {
    final String getFinalString = questionAnswers
        .map(
          (e) => "Q: ${e.question}\nChatGPT: ${e.answer.toString().trim()}\n\n",
        )
        .join(' ');
    Share.share(
      getFinalString,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  @override
  void dispose() {
    msgController.dispose();
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBarWidget(
      languages.lblFitBot,
      context: context,
      actions: [
        IconButton(
          onPressed: showDialog,
          icon: Icon(
            Icons.restart_alt,
            color: appStore.isDarkMode ? Colors.white : Colors.black,
          ),
          tooltip: languages.lblClearConversion,
        ).visible(questionAnswers.isNotEmpty),
      ],
    ),
    body: Stack(
      fit: StackFit.expand,
      children: [
        Container(
          height: context.height(),
          width: context.width(),
          margin: EdgeInsets.only(bottom: 66 + (isShowOption ? 50 : 0)),
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: ListView.separated(
            separatorBuilder: (_, i) =>
                const Divider(color: Colors.transparent),
            reverse: true,
            padding: const EdgeInsets.only(bottom: 8, top: 16),
            controller: scrollController,
            itemCount: questionAnswers.length,
            itemBuilder: (_, index) {
              final QuestionAnswerModel data = questionAnswers[index];
              final String answer = data.answer.toString().trim();
              return ChatMessageWidget(
                answer: answer,
                data: data,
                isLoading: data.isLoading.validate(),
              );
            },
          ),
        ),
        if (questionAnswers.validate().isEmpty)
          ChatBotEmptyScreen(
            isScroll: isScroll,
            onTap: (value) {
              msgController.text = value;
              setState(() {});
            },
          ).center(),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            children: [
              16.height,
              Row(
                children: [
                  AppTextField(
                    textFieldType: TextFieldType.OTHER,
                    controller: msgController,
                    minLines: 1,
                    maxLines: 1,
                    cursorColor: appStore.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    keyboardType: TextInputType.multiline,
                    decoration: defaultInputDecoration(
                      context,
                      label: languages.lblChatHintText,
                    ),
                    onFieldSubmitted: (s) {
                      //sendMessage();
                    },
                    onTap: () {
                      isScroll = true;
                      setState(() {});
                    },
                  ).expand(),
                  10.width,
                  Container(
                    decoration: boxDecorationWithRoundedCorners(
                      backgroundColor: primaryColor,
                      borderRadius: radius(14),
                    ),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: const Icon(
                        Icons.send,
                        size: 16,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (msgController.text.isNotEmpty) {
                          sendMessage();
                        }
                      },
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: 16),
              16.height,
            ],
          ),
        ),
      ],
    ),
  );
}
