import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import '../utils/shared_import.dart';

int? selectedImageIndex = -1;
bool? isLoading = false;
List<QuestionImageAnswerModel> questionAnswers = [];
List<Map<String, dynamic>> myMessages = [];

class ChattingImageScreen extends StatefulWidget {
  static String tag = '/chatgpt';

  final bool isDirect;

  const ChattingImageScreen({super.key, this.isDirect = false});

  @override
  _ChattingImageScreenState createState() => _ChattingImageScreenState();
}

class _ChattingImageScreenState extends State<ChattingImageScreen> {
  // ChatGpt chatGpt = ChatGpt(apiKey: userStore.chatGptApiKey);

  ScrollController scrollController = ScrollController();

  TextEditingController msgController = TextEditingController();

  StreamSubscription<StreamCompletionResponse>? streamSubscription;

  int adCount = 0;
  int selectedIndex = -1;

  String lastError = "";
  String imageSelected = "";
  String lastStatus = "";
  String selectedText = '';
  String firstQuestion = '';
  String question = '';

  bool isBannerLoad = false;
  bool isShowOption = false;
  bool isSelectedIndex = false;
  bool isScroll = false;
  bool showResponse = false;
  List<String> foundWords = [];

  late OpenAI openAI;
  bool showUI = false;
  //  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    Future<void>.value().then((_) async {
      isFirstTime = await getFirstTimeOpen();
      openAI = OpenAI.instance.build(
        token: userStore.chatGptApiKey,
        // token: "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",
        baseOption: HttpSetup(
          receiveTimeout: const Duration(seconds: 20),
          connectTimeout: const Duration(seconds: 20),
        ),
        enableLog: true,
      );

      log("-----------------82>>>>$isFirstTime");
      if (isFirstTime == false || isFirstTime == null) {
        firstQuestion =
            "my gender is ${userStore.gender.validate()}, my age is ${userStore.age.validate()}, my weight is${userStore.weight.validate()}${userStore.weightUnit.validate()}, my height is ${userStore.height.validate()}${userStore.heightUnit.validate()}, $selectMainGoal, $selectExperienced,$selectEquipments,$selectWeekWorkout please schedule my workout?";
        sendAutoFirstMsg(firstQuestion);
      }
      if (widget.isDirect &&
          userStore.showAdsOnChatbot == 1 &&
          userStore.isSubscribe == 0) {
        loadAds();
      } else {
        showUI = true;
      }
      init();
    });
  }

  Future<void> loadAds() async {
    await createInterstitialAd();
    await adShow();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        showUI = true;
      });
    });
  }

  Future<void> setFitBotDataApiCall(String? question, String? answer) async {
    //  speakLongText(answer??'');
    appStore.setLoading(true);
    final Map<String, dynamic> req = {"question": question, "answer": answer};
    await saveFitBotData(req).then((value) async {}).catchError((dynamic e) {
      appStore.setLoading(false);
      log(e.toString());
    });
  }

  Future<void> deleteFitBotDataApiCall() async {
    appStore.setLoading(true);
    await deleteFitBotData()
        .then((value) async {
          questionAnswers.clear();
          setState(() {});
        })
        .catchError((dynamic e) {
          appStore.setLoading(false);
          log(e.toString());
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

  Future<void> sendAutoFirstMsg(String? questions) async {
    isLoading = true;

    hideKeyboard(context);
    showResponse = true;
    questionAnswers.insert(
      0,
      QuestionImageAnswerModel(
        question: questions,
        imageUri: imageSelected,
        answer: StringBuffer(),
        isLoading: true,
        smartCompose: selectedText,
      ),
    );
    setState(() {});
    myMessages.add({"role": "user", "content": "$questions"});

    final request = ChatCompleteText(
      messages: myMessages,
      maxToken: 350,
      model: Gpt4ChatModel(),
    );

    await _streamResponse(request);
    await setFirstTimeOpen(isFirstTime = true);
    log("------------------>>>>$isFirstTime");
    isFirstTime = await getFirstTimeOpen();
    log("------------------>>>>----$isFirstTime");

    isLoading = false;
    questionAnswers[0].isLoading = false;
    showResponse = false;
    setState(() {});
  }

  Future<void> sendMessage() async {
    showResponse = true;
    isLoading = true;
    hideKeyboard(context);
    if (selectedText.isNotEmpty) {
      question = selectedText + msgController.text;
      setState(() {});
    } else {
      question = msgController.text;
      setState(() {});
    }
    msgController.clear();
    /* for (var word in foundString) {
      if (question.contains(word)) {
        foundWords.add(word);
      }
    }*/
    questionAnswers.insert(
      0,
      QuestionImageAnswerModel(
        question: question,
        imageUri: imageSelected,
        answer: StringBuffer(),
        isLoading: true,
        smartCompose: selectedText,
      ),
    );

    setState(() {});
    myMessages.add({"role": "user", "content": question});
    final request = ChatCompleteText(
      messages: myMessages,
      maxToken: 250,
      model: Gpt4ChatModel(),
    );

    await _streamResponse(request);

    isLoading = false;

    questionAnswers[0].isLoading = false;
    showResponse = false;

    setState(() {});
  }

  Future<dynamic> _streamResponse(ChatCompleteText request) async {
    streamSubscription?.cancel();

    try {
      final stream = await openAI.onChatCompletion(request: request);
      myMessages.add({
        "role": "assistant",
        "content": "${stream?.choices.first.message?.content}",
      });
      stream?.choices.forEach((data) {
        questionAnswers.first.answer!.write(data.message?.content);
        setFitBotDataApiCall(question, data.message?.content);
      });
      imageSelected = '';
      selectedImageIndex = -1;
    } on Exception catch (error) {
      isLoading = false;
      questionAnswers.first.answer!.write("Too many requests please try again");
      imageSelected = '';
      selectedImageIndex = -1;
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
        deleteFitBotDataApiCall();
      },
    );
  }

  void share(
    BuildContext context, {
    required List<QuestionImageAnswerModel> questionAnswers,
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
  Widget build(BuildContext context) => showUI
      ? Scaffold(
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
                    final QuestionImageAnswerModel data =
                        questionAnswers[index];
                    log("----------287>>>>${data.question}");
                    return ChatMessageImageWidget(
                      answer: data.answer.toString().trim(),
                      data: data,
                      isLoading: data.isLoading.validate(),
                      firstQuestion: firstQuestion,
                    );
                  },
                ),
              ),
              (isLoading == true)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/loading.json',
                            width: 70,
                            height: 70,
                            delegates: LottieDelegates(
                              values: [
                                ValueDelegate.color(
                                  const [
                                    'Shape Layer 1',
                                    'Rectangle 1',
                                    'Fill 1',
                                  ],
                                  value: primaryColor,
                                  // value: Colors.blueAccent,
                                ),
                                ValueDelegate.color(
                                  const [
                                    'Shape Layer 2',
                                    'Rectangle 1',
                                    'Fill 1',
                                  ],
                                  value: primaryColor,
                                  // value: Colors.blueAccent,
                                ),
                                ValueDelegate.color(
                                  const ['Ellipse 28', 'Ellipse 28', 'Fill 1'],
                                  value: primaryColor,
                                  // value: Colors.blueAccent,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Please wait...',
                            style: primaryTextStyle(size: 14),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),

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
                    showResponse == false
                        ? Row(
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
                                  sendMessage();
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
                          ).paddingSymmetric(horizontal: 16)
                        : const SizedBox.shrink(),
                    16.height,
                  ],
                ),
              ),
            ],
          ),
        )
      : const Scaffold(body: Center(child: CircularProgressIndicator()));
}
