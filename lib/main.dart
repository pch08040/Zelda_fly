import 'package:firebase_core/firebase_core.dart';
import 'package:zeldafly/firebase_options.dart';
// import 'firebase_options.dart';
import 'package:zeldafly/screens/game_over_screen.dart';
import 'package:zeldafly/screens/leader_board_screen.dart';
import 'package:zeldafly/screens/main_menu_screen.dart';
import 'package:zeldafly/screens/sign_up_screen_test.dart';
import 'package:zeldafly/game/flappy_bird_game.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
// import 'package:flame/flame.dart';
// import 'package:flame_audio/flame_audio.dart';

void main() async {

  // 플러터에서 사용하는 플러그인을 초기화할때 이 플러그인에 초기화 메소드가 비동기 방식이면 문제발생
  // Firebase.initializeApp 해당 메소드는 비동기 방식이 메서드, 그래서 해당 메서드가 플터터와 통신을 원하지만
  // 플러터의 최상위 메서드인 runApp메서드가 호출되기 전에는 플러터 엔진이 초기화 되지 않아서 접근 불가
  // 따라서 메인메소드 내부에서 플러터  엔진과 관련된 파이어베이스 초기화와 같은 비동기 메소드를 사용하려면
  // 우선 플러터 코어 엔진을 초기화시켜 주어야 된다. 그리고 그걸 수행하는 메서드가 WidgetsFlutterBinding.ensureInitialized 임
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); 

  final game = FlappyBirdGame();

  runApp(
    MaterialApp(
      title: 'Zelda Fly',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameWidget(
        game: game,
        // 초기에 활성화될 스크린 id설정
        initialActiveOverlays: const [MainMenuScreen.id],
        overlayBuilderMap: {
          'mainMenu': (context, _) => MainMenuScreen(game: game),
          'gameOver': (context, _) => GameOverScreen(game: game),
          'leaderBoard': (context, _) => LeaderBoardScreen(game: game),
          'signUpIn': (context, _) => LoginSignupScreen(game: game),
        },
      ),
    ),
  );
}
