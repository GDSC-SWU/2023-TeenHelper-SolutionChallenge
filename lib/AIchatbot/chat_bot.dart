import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:velocity_x/velocity_x.dart';

import 'threedots.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'message_model.dart';
import 'package:translator/translator.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final txtMessage = TextEditingController();
  late OpenAI? chatGPT;
  StreamSubscription? subscription;

  bool _isTyping = false;

  //open ai api key
  final translate_apikey = dotenv.env["TRANSLATE_KEY"];

  @override
  void initState() {
    chatGPT = OpenAI.instance.build(
        token: dotenv.env["ChatGPTAPI_KEY"],
        baseOption: HttpSetup(receiveTimeout: 60000));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //List messages
  final messages = [
    MessageModel(true, '오늘도 건강한 하루 되세요! 저에게 질문이 있다면 언제든 말을 걸어주세요.')
  ];

  void sendMessage(String message) async {
    final translator = GoogleTranslator();
    //final translator = GoogleTranslator.fromLanguage('ko');
    final translatedMessage = await translator.translate(
      message,
      to: 'en',
    );

    final request = CompleteText(
        prompt: translatedMessage.toString(), model: kTranslateModelV3);

    final res = await chatGPT!.onCompleteText(request: request);
    Vx.log(res!.choices[0].text);

    final translatedResponse =
        await translator.translate(res.choices.last.text, to: 'ko');

    setState(() {
      messages.add(MessageModel(true, translatedResponse.toString()));
      _isTyping = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String convertedDateTime =
        "${now.year.toString()}년 ${now.month.toString().padLeft(2, '0')}월 ${now.day.toString().padLeft(2, '0')}일}";
    //${now.hour.toString()}-${now.minute.toString()
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: Color(0xFFFFF7F3),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 0.1),
                blurRadius: 4.0,
              )
            ]),
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text('TeenHelper', style: TextStyle(color: Colors.black)),
              centerTitle: true,
              shadowColor: Color(0xFF353535),
              /*leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF0E0D0D),
                    size: 5 * 5,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    print("Icon Button clicked");
                  }),*/
            ),
          )),
      body: Stack(
        children: [
          Column(
            children: [
              //_appBar(context),
              _messageList(),
              if (_isTyping) const ThreeDots(),
              const Divider(
                height: 1.0,
              ),
              Center(
                child: Container(
                    padding: EdgeInsets.only(top: ScreenUtil().setSp(15)),
                    child: Text(
                      convertedDateTime,
                      style: const TextStyle(fontSize: 20),
                    )),
              )
            ],
          ),
          _bottomNavigation(context)
        ],
      ),
    );
  }

  Expanded _messageList() {
    return Expanded(
      flex: 7,
      child: ListView.builder(
        itemCount: messages.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return messages[index].isBot
              ? _botCard(index: index)
              : _userCard(index: index);
        },
      ),
    );
  }

  Padding _userCard({required int index}) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setSp(14),
            vertical: ScreenUtil().setSp(14)),
        child: Container(
            margin: const EdgeInsets.only(left: 150),
            //right: ScreenUtil().setSp(50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setSp(10),
                      vertical: ScreenUtil().setSp(8)),
                  decoration: BoxDecoration(
                      color: const Color(0xFFE76D3B),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(.3),
                            offset: const Offset(0, 0.03),
                            blurRadius: 5)
                      ]),
                  child: Text(
                    messages[index].message,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )));
  }

  Padding _botCard({required int index}) {
    String response = messages[index].message.trim();
    int lastPeriodIndex = response.lastIndexOf(".");
    int lastQuestionMarkIndex = response.lastIndexOf("?");
    int lastIndex = lastPeriodIndex > lastQuestionMarkIndex
        ? lastPeriodIndex
        : lastQuestionMarkIndex;
    if (lastIndex >= 0) {
      response = response.substring(0, lastIndex + 1);
    }
    response = response
        .replaceAll(RegExp(r'\b\d+\.\s*$'), '')
        .trim(); // remove last numbering
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setSp(14), vertical: ScreenUtil().setSp(14)),
      child: Stack(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage("images/chatbot.png"),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 18 * 3.2),
            padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setSp(15),
                vertical: ScreenUtil().setSp(5)),
            decoration: BoxDecoration(
                color: const Color(0xFFFCD8C6),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(.3),
                      offset: const Offset(0, 0.03),
                      blurRadius: 5)
                ]),
            child: Text(
              response,
            ),
          ),
        ],
      ),
    );
  }

  Align _bottomNavigation(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: MediaQuery.of(context).size.height * .10,
          width: double.maxFinite,
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14 / 1.2),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(.23),
                offset: const Offset(16 / 1.2, .5),
                blurRadius: 14)
          ]),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 220, 219, 219),
                borderRadius: BorderRadius.circular(14)),
            child: TextField(
                controller: txtMessage,
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                        onTap: () {
                          sendMessage(txtMessage.text.toString());
                          setState(() {
                            _isTyping = true;
                            messages.add(MessageModel(
                                false, txtMessage.text.toString()));
                            txtMessage.text = '';
                          });
                        },
                        child: const Icon(
                          Icons.send,
                          size: 14 * 1.8,
                          color: Colors.grey,
                        )),
                    hintText: 'TeenHelper에게 건강관련 질문해보세요',
                    hintStyle: TextStyle(color: Colors.grey),
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none)),
          ),
        ));

    /*return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * .10,
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14 / 1.2),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(.23),
              offset: const Offset(16 / 1.2, .5),
              blurRadius: 14)
        ]),
        child: ListTile(
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 220, 219, 219),
                borderRadius: BorderRadius.circular(14)),
            child: TextFormField(
              controller: txtMessage,
              decoration: InputDecoration(
                  hintText: 'TeenHelper에게 건강관련 질문해보세요',
                  hintStyle: TextStyle(color: Colors.grey),
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none),
            ),
          ),
          trailing: IconButton(
              icon: Icon(
                Icons.send,
                size: 16 * 1.8,
                color: Colors.grey,
              ),
              onPressed: () {
                sendMessage(txtMessage.text.toString());
                setState(() {
                  messages.add(MessageModel(false, txtMessage.text.toString()));
                  txtMessage.text = '';
                });
              }),
        ),
      ),
    );*/
  }

  Expanded _appBar(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        //margin: const EdgeInsets.only(top: 50),
        padding: EdgeInsets.only(
            right: ScreenUtil().setSp(20), top: ScreenUtil().setSp(7)),
        decoration: BoxDecoration(
            color: Colors.white,
            //borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.10),
                  offset: const Offset(20, .5),
                  blurRadius: 4)
            ]),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 5 * 5,
              ),
              //alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: ScreenUtil().setSp(16)),
              onPressed: () {
                print("Icon Button clicked");
              },
            ),
            /*Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,*/
            //children: [
            /*SizedBox(
                          width: 64,
                          height: 14,
                          child:*/
            Container(
              child: Text("TeenHelper",
                  style: TextStyle(fontSize: 20, color: Colors.black)),
              padding: EdgeInsets.only(left: 100, top: 16),
            )
          ],
          //)
          //],
        ),
      ),
    );
  }
}
