import 'dart:async';
// import 'package:flame/extensions.dart';
import 'package:zeldafly/game/assets.dart';
import 'package:zeldafly/game/flappy_bird_game.dart';

// 주요 클래스 및 기능
// SpriteComponent: 스프라이트(이미지)를 렌더링하고 조작하는 컴포넌트
// PositionComponent: 위치와 크기를 가지는 모든 컴포넌트의 기본 클래스
// AnimationComponent: 애니메이션 스프라이트를 처리하는 컴포넌트
// TextComponent: 텍스트를 렌더링하는 컴포넌트.
// ShapeComponent: 기본적인 도형(원, 사각형 등)을 렌더링하는 컴포넌트
import 'package:flame/components.dart';

// 주요 클래스 및 기능
// Flame: Flame 엔진의 핵심 클래스로, 다양한 유틸리티 메서드와 설정을 제공합니다
// images: 이미지를 로드하고 관리하는 기능
// audio: 오디오 파일을 로드하고 재생하는 기능
// util: 화면 회전, 전체 화면 설정 등 다양한 유틸리티 기능
// Game: 게임의 기본 클래스. Flame 게임을 만들 때 기본적으로 이 클래스를 확장합니다
// GameWidget: Flutter 위젯으로 Flame 게임을 화면에 렌더링하는 데 사용합니다
// FlameAudio: 오디오 관련 유틸리티 기능을 제공하는 클래스
import 'package:flame/flame.dart';

// SpriteComponent 클래스의 주요 기능

// 1. 이미지 로딩 및 관리: 스프라이트(이미지)를 로드하고 이를 관리
// 2. 위치 및 크기 설정: 스프라이트의 위치(x, y 좌표)와 크기를 설정
// 3. 회전 및 스케일링: 스프라이트를 회전시키거나 크기를 조정
// 4. 충돌 감지: 다른 컴포넌트와의 충돌을 감지
// 5. 애니메이션: 스프라이트 애니메이션을 지원하여 여러 프레임의 이미지를 순차적으로 보여줌

class Background extends SpriteComponent with HasGameRef<FlappyBirdGame> {
  Background(); // 기본생성자
  // Background 가 FlappyBirdGame 타입의 gameRef 속성을 가질 수 있게 설정
  @override
  Future<void> onLoad() async {
    final background = await Flame.images.load(Assets.backgorund2);
    size = gameRef.size;
    // 위 코드에서 gameRef.size는 FlappyBirdGame 인스턴스의 크기 속성에 접근하는 것을 의미합니다.
    // 이를 통해 Background 컴포넌트는 게임 화면 크기에 맞춰 자신의 크기를 설정할 수 있습니다.
    sprite = Sprite(background);
  }

  // void containSize(Sprite? sprite) {
  //   if (sprite != null && sprite.image != null) {
  //     final imageWidth = sprite.image!.width.toDouble();
  //     final imageHeight = sprite.image!.height.toDouble();
  //     final outWidth = gameRef.size.x;
  //     final outHeight = gameRef.size.y;

  //     if (outWidth / outHeight > imageWidth / imageHeight) {
  //       size = Vector2(imageWidth * outHeight / imageHeight, outHeight);
  //     } else {
  //       size = Vector2(outWidth, imageHeight * outWidth / imageWidth);
  //     }
  //   } else {
  //     print('Image is not loaded yet or sprite is null.');
  //   }
  // }
}
