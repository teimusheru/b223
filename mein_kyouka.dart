import 'dart:math';

import 'package:b0110/0111%EF%BD%9E%E3%80%80%E3%83%A1%E3%82%A4%E3%83%B3%E6%95%99%E7%A7%91/firestore_kyoka.dart';
import 'package:b0110/card/firestore_JAPAN.dart';
import 'package:b0110/syousai.dart';
import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tab_bar/indicator/custom_indicator.dart';
import 'package:intl/intl.dart';


import '../0113~  詳細/113　shousai.dart';


import '../222shop/222serch  検索.dart';
import '../222shop/screens/home/components/categorries.dart';
import '../card/firestore_helper.dart';
import '../chat/firebase_auth.dart';
import '../item/app_text.dart';
import '../item/colors.dart';


// catテーブルの内容全件を一覧表示するクラス
class ItemList extends StatefulWidget {






  const ItemList({Key? key,




  })
      : super(key: key);

  @override
  _CatListPageState createState() => _CatListPageState();
}

class _CatListPageState extends State<ItemList> {
  List<DocumentSnapshot> catSnapshot = [];
  List<kyoka> catList = []; //catsテーブルの全件を保有する
  bool isLoading = false; //テーブル読み込み中の状態を保有する
  // static const String userId = 'test@apricotcomic.com'; //仮のユーザID。認証機能を実装したら、本物のIDに変更する。
  final String? userId = getUid();//仮のユーザID。認証機能を実装したら、本物のIDに変更する。


// Stateのサブクラスを作成し、initStateをオーバーライドすると、wedgit作成時に処理を動かすことができる。
// ここでは、初期処理としてCatsの全データを取得する。
  @override
  void initState() {
    super.initState();
    setState(() => isLoading = true);
    getCatsList();
    setState(() => isLoading = false);
    setState(() => isLoading = true);


    setState(() => isLoading = false);

  }




// initStateで動かす処理。
// catsテーブルに登録されている全データを取ってくる
  Future getCatsList() async {
    setState(() => isLoading = true);
    if (userId != null) {//テーブル読み込み前に「読み込み中」の状態にする


      catSnapshot = await FirestoreHelper.instance
          .selectAllkyoka();}

    //users配下のcatsコレクションのドキュメントをを全件読み込む
    catList = catSnapshot
        .map((doc) => kyoka(
      id: doc['id'],
      name: doc['name'],
      kamoku: doc['kamoku'],
      image: doc['image'],




    ))
        .toList();
    setState(() => isLoading = false);                  //「読み込み済」の状態にする
  }



  final double width = 320;
  final double height =680;
  final Color borderColor = Color(0xffE2E2E2);
  final double borderRadius = 10;



  @override
  Widget build(BuildContext context) {


    CalendarAgendaController _calendarAgendaControllerAppBar =
    CalendarAgendaController();
    CalendarAgendaController _calendarAgendaControllerNotAppBar =
    CalendarAgendaController();

    DateTime _selectedDateAppBBar;
    DateTime _selectedDateNotAppBBar;

    Random random = new Random();

    final int pageCount = 4;
    late PageController _controller = PageController(initialPage: 3);
    CustomTabBarController _tabBarController = CustomTabBarController();

    @override
    void initState() {
      super.initState();
      _selectedDateAppBBar = DateTime.now();
      _selectedDateNotAppBBar = DateTime.now();
    }


    ///1023

    //  final cat = catList;
    late DateTime dateFormat;
    String? title;


    return Scaffold(
      resizeToAvoidBottomInset: false,
      ///tab スライド日付
      appBar: AppBar(
        bottomOpacity: 0.0,
        elevation: 0.0,
        leading:  IconButton(
          icon: Icon(Icons.email_outlined, color: Colors.black,), onPressed: () {  },
        ),
        title: const Text('伝統工芸品',
          style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: <Widget>[


          IconButton(
            icon: Icon(Icons.favorite_border_outlined, color: Colors.black,), onPressed: () {  },
          ),
          IconButton(
            icon: Icon(Icons.shopping_bag_outlined, color: Colors.black,), onPressed: () {  },
          ),
        ],
      ),



      body:Column(
/*
      isLoading
      //「読み込み中」だったら「グルグル」が表示される
          ? const Center(
        child: CircularProgressIndicator(),   // これが「グルグル」の処理
      )

          :*/

      children: <Widget>[

        /*  height: 400,*/
        const SearchBar(),
       Categories(),
      Expanded(
        child: GridView.count(
          crossAxisCount: 2, // 1行に表示する数
          crossAxisSpacing: 1, // 縦スペース
          mainAxisSpacing: 1, // 横スペース
          childAspectRatio: 0.7,//0.7が最大かな、、、Gridのタテヨコ比は常に同じ割合となります。そのため縦の長さを伸ばしたい場合は、childAspectRatioで比率を変えてあげます
          shrinkWrap: true,
          // 取得したcatsテーブル全件をリスト表示する
          // 取得したデータの件数を取得
          children: List.generate(catList.length, (index) {

            {


              final cat = catList[index];

              // 1件分のデータをcatに取り出す

//1030  追加　画像サイズ指定
              Widget _myImg(){
                return FittedBox(
            /*      fit: BoxFit.fitWidth,*/
               /*   fit: BoxFit.fill,*/
            /*      fit: BoxFit.scaleDown,*/
                    fit:BoxFit.contain,

                  child:
                  Image.network(cat.image),

                );
              }

              return Container(

                alignment: Alignment.center,
                decoration: BoxDecoration
                  (

                  color: Colors.white,
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.grey,
                      offset: new Offset(5.0, 5.0),
                      blurRadius: 10.0,
                    )
                  ],
                ),
                child: InkWell(
                child:Column(
                    children: <Widget>[
                     _myImg(),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        margin: EdgeInsets.all(16.0),
                        child: AppText(
                          text:cat.kamoku,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,


                        ),
                      ),

                      new Text(
                        cat.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                          fontSize: 13.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFF212121),
                          /* fontWeight: FontWeight.bold,*/
                        ),
                      ),
                    ]
                ),
                  onTap: () async { // cardをtapしたときの処理を設定
                    await Navigator.of(context).push( // ページ遷移をNavigatorで設定
                      MaterialPageRoute(

                        builder:


                            (context) => syousai0113(
                          id: cat.id??"null",
                          image: cat.image??"null",
                          name: cat.name??"null",

                          kamoku: cat.kamoku??"null",



                          // cardのデータの詳細を表示するcat_detail.dartへ遷移
                        ),
                      ),
                    );
                    // getCatsList();    // データが更新されているかもしれないので、catsテーブル全件読み直し
                  },
              ),
              );


            }
          },

          ),

        ),
      ),///222
        ///


      ],
      ),
      /* floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, */// <-
      floatingActionButton: FloatingActionButton(                   // ＋ボタンを下に表示する
        child: const Icon(Icons.flight_rounded),
        backgroundColor: Colors.orange,///language   flight_takeoff_rounded
    onPressed: () async {  }            // ボタンの形を指定
/*        onPressed: () async {                                       // ＋ボタンを押したときの処理を設定
          await Navigator.of(context).push(                         // ページ遷移をNavigatorで設定
            MaterialPageRoute(
                builder: (context) =>  MyApp1201() // 詳細更新画面（元ネタがないから新規登録）を表示するcat_detail_edit.dartへ遷移
            ),
          );
          getCatsList();// 新規登録されているので、catテーブル全件読み直し
          initState();
          JapanData();
          getCatsList_day(DateTime.now());//まだエラー出る
        },*/
      ),
    );
  }
  /* Widget imageWidget() {
    return Container(
      child: Image.asset(item.imagePath),
    );
  }*/

  Widget addWidget() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          color: AppColors.primaryColor),
      child: Center(
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 25,
        ),
      ),
    );
  }

}




