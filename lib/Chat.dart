import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Chat extends StatefulWidget {
  @override
  State<Chat> createState() => ChatState();
}

const languages = const [
  const Languages('English', 'en_US'),
];

class Languages {
  final String name;
  final String code;

  const Languages(this.name, this.code);
}

class ChatState extends State<Chat> {
  // var habox = Hive.box('mybox');

  final FlutterTts flutterTts = FlutterTts(); //for speach
  final TextEditingController textEditingController =
      TextEditingController(); //for speach

//

  String transcription = '';
  Languages selectedLang = languages.first;

  @override
  initState() {
    super.initState();
  }

  List<CheckedPopupMenuItem<Languages>> get _buildLanguagesWidgets => languages
      .map(
        (l) => CheckedPopupMenuItem<Languages>(
          value: l,
          checked: selectedLang == l,
          child: Text(l.name),
        ),
      )
      .toList();

  void response(String query) async {
//where the response happen
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/grad-project-smht-0bbbd3489d9f.json")
            .build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse aiResponse = await dialogflow.detectIntent(query);

    setState(() {
      messsages.insert(0, {
        "data": 0,
        "message": aiResponse.getListMessage()[0]["text"]["text"][0].toString()
      });
    });
  }

  final messageInsert = TextEditingController();
  List<Map> messsages = List();

  @override
  Widget build(BuildContext context) {
    double heightphone = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: heightphone * 0.9,
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                reverse: true, //new massages come from the bottom
                itemCount:
                    messsages.length, //the number of massages showd be shown
                itemBuilder: (context, index) =>
                    chat(messsages[index]["message"], messsages[index]["data"]),
              ), //add massages
            ),
            SizedBox(
              height: 2, //destince from bottom to listview
            ),
            SingleChildScrollView(
              child: Container(
                color: Color.fromARGB(255, 66, 92, 131), //Low bar color
                child: ListTile(
                    leading: IconButton(
                      padding: EdgeInsets.all(0),
                      iconSize: 30.0,
                      icon: Icon(
                        Icons.mic,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    //microphone icon
                    title: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromARGB(255, 255, 255, 255),
                      ), //writing box style
                      padding: EdgeInsets.only(left: 10),
                      //
                      child: TextField(
                        controller: messageInsert, //the written text
                        decoration: InputDecoration(
                          hintText: "Enter a Message...",
                          hintStyle: TextStyle(color: Colors.black26),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        onChanged: (value) {},
                      ),
                    ),
                    trailing: IconButton(
                        icon: Icon(
                          Icons.send,
                          size: 30.0,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ), //icon send style
                        onPressed: () {
                          if (messageInsert.text.isEmpty) {
                            print("empty message");
                          } else {
                            setState(() {
                              messsages.insert(0,
                                  {"data": 1, "message": messageInsert.text});
                            });
                            response(messageInsert.text);
                            messageInsert.clear();
                          }
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            // currentFocus.unfocus();
                          }
                        })),
              ),
            ),
            SizedBox(
              height: 0.0,
            ),
          ],
        ),
      ),
    );
  }

///////////////
//Chat widget//
//Chat widget//
//Chat widget//
//Chat widget//
//Chat widget//
//Chat widget//
//Chat widget//
///////////////
  Widget chat(String message, int data) {
    if (message == null) {
      return null;
    } //if chat field is empty don't send anything.

    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment:
            data == 0 ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          data == 0 //the Bot massage style
              ? Container(
                  height: 60,
                  width: 60,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/robot.jpg"),
                  ),
                )
              : Container(),
          Padding(
            padding:
                EdgeInsets.all(5.0), //distence between avatar and the massage
            child: Bubble(
              radius: Radius.circular(10.0), //massage edge radius
              color: data == 0
                  ? Color.fromARGB(255, 112, 161, 226) //bot massage color
                  : Color.fromARGB(255, 66, 129, 115), //user massage color
              elevation: 5.0, //shadow of the messages
              //
              child: Padding(
                padding: EdgeInsets.all(2.0), //massgae box padding
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: 200), //max massgae box width
                        child: Text(
                          message,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //
            ),
          ),
          data == 1 // the user massage style
              ? Container(
                  height: 60,
                  width: 60,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/default.jpg"),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
