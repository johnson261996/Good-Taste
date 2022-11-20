import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
 
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});



  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
final webViewKey = GlobalKey<_MyHomePageState>();
class _MyHomePageState extends State<MyHomePage> {
  late WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () => _goBack(context),
      child: Platform.isAndroid ? Scaffold(
         appBar: AppBar(
          backgroundColor: const Color(0xffFFEE32),
          title: const Text("Good Taste",style: TextStyle(color: Colors.black),),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.refresh,color:  Colors.black,),
              onPressed: () {
                // reload the webpage
                setState(() {
                   _webViewController.reload();
                });
              },
            ),
          ],
         ),
        body: BodyWidget(context),
      ):CupertinoPageScaffold(
      navigationBar:CupertinoNavigationBar(
          leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:const <Widget>[
                 Text("Good Taste"),
             ],
        ),
          trailing: GestureDetector(
            child:const Icon(CupertinoIcons.refresh,size: 20.0,),
            onTap: (){
                _webViewController.reload();
            },
          ),
        ),
      child:BodyWidget(context),
    ),
    );
  }

  Widget BodyWidget(BuildContext context){
    return WebView(
            onWebViewCreated: (controller) {
            _webViewController = controller;
        },
          initialUrl: 'https://goodtaste.fleksa.de/en',
          javascriptMode: JavascriptMode.unrestricted,
        );
  }

 
  Future<bool> _goBack(BuildContext context) async {
    var status = await _webViewController.canGoBack();
      if (!mounted) return false;
  if (status) {
    print("go back");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("loading....")));
    _webViewController.goBack();
    return Future.value(false);
  } else {
    if (Platform.isAndroid) {
  // Android-specific code
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title:const Text('Do you want to exit'),
                actions: <Widget>[
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor :const  Color(0xffFFEE32), ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:const Text('No',style: TextStyle(color:Colors.black)),
                  ),
                  ElevatedButton(
                     style: ElevatedButton.styleFrom(
                        backgroundColor :const  Color(0xffFFEE32), ),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child:const Text('Yes',style: TextStyle(color: Colors.black),),
                  ),
                ],
              ));
    } else  {
  // iOS-specific code
   showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text("Do you want to exit"),
        
            actions: [
              CupertinoDialogAction(
                  isDefaultAction: true, 
                  child:const  Text("Yes"),
                  onPressed: () =>  SystemNavigator.pop(),
                  ),
              CupertinoDialogAction(
                  child:const Text("No"),
                  onPressed:() =>  Navigator.of(context).pop()
                  ),
            ],
          ),
    );
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No back history item")),
    );
    return Future.value(false);
  }
}

  
}
