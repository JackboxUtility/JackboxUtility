import 'package:flutter_test/flutter_test.dart';
import 'package:jackbox_patcher/services/gamepad/gamepad_mapper.dart';

GamepadSnapshot pad({int buttons = 0, int leftX = 0, int leftY = 0, int rightY = 0, int trigger = 0}) {
  return (buttons: buttons, leftX: leftX, leftY: leftY, rightY: rightY, trigger: trigger);
}

Duration ms(int milliseconds) => Duration(milliseconds: milliseconds);

const Duration repeatDelay = GamepadMapper.directionRepeatDelay;
const Duration repeatInterval = GamepadMapper.directionRepeatInterval;

void main() {
  late GamepadMapper mapper;

  setUp(() {
    mapper = GamepadMapper();
  });

  group('Buttons', () {
    test('A fires once per press and never repeats', () {
      expect(mapper.update([pad(buttons: GamepadButtons.a)], ms(0)), [GamepadCommand.ACTIVATE]);
      expect(mapper.update([pad(buttons: GamepadButtons.a)], ms(16)), isEmpty);
      expect(mapper.update([pad(buttons: GamepadButtons.a)], ms(1000)), isEmpty);
      expect(mapper.update([pad()], ms(1016)), isEmpty);
      expect(mapper.update([pad(buttons: GamepadButtons.a)], ms(1032)), [GamepadCommand.ACTIVATE]);
    });

    test('B, X, LB and RB are mapped', () {
      expect(mapper.update([pad(buttons: GamepadButtons.b)], ms(0)), [GamepadCommand.BACK]);
      expect(mapper.update([pad(buttons: GamepadButtons.x)], ms(8)), [GamepadCommand.QUICK_LAUNCH_PRESS]);
      expect(
          mapper.update([pad(buttons: GamepadButtons.leftShoulder | GamepadButtons.rightShoulder)], ms(16)),
          [GamepadCommand.PREVIOUS, GamepadCommand.NEXT, GamepadCommand.QUICK_LAUNCH_RELEASE]);
    });

    test('View shows or hides the bar of the buttons, once per press', () {
      expect(mapper.update([pad(buttons: GamepadButtons.view)], ms(0)), [GamepadCommand.TOGGLE_BUTTON_BAR]);
      expect(mapper.update([pad(buttons: GamepadButtons.view)], ms(1000)), isEmpty);
      expect(mapper.update([pad()], ms(1016)), isEmpty);
    });

    test('X also fires when it\'s released, like a button on screen', () {
      expect(mapper.update([pad(buttons: GamepadButtons.x)], ms(0)), [GamepadCommand.QUICK_LAUNCH_PRESS]);
      expect(mapper.update([pad(buttons: GamepadButtons.x)], ms(16)), isEmpty);
      expect(mapper.update([pad()], ms(32)), [GamepadCommand.QUICK_LAUNCH_RELEASE]);
      expect(mapper.update([pad()], ms(48)), isEmpty);
      // Released while another button is pressed
      expect(mapper.update([pad(buttons: GamepadButtons.x)], ms(64)), [GamepadCommand.QUICK_LAUNCH_PRESS]);
      expect(mapper.update([pad(buttons: GamepadButtons.a)], ms(80)),
          [GamepadCommand.ACTIVATE, GamepadCommand.QUICK_LAUNCH_RELEASE]);
    });

    test('X is released after the directions, so a direction at the same time cancels it first', () {
      expect(mapper.update([pad(buttons: GamepadButtons.x)], ms(0)), [GamepadCommand.QUICK_LAUNCH_PRESS]);
      expect(mapper.update([pad(buttons: GamepadButtons.dpadUp)], ms(16)),
          [GamepadCommand.UP, GamepadCommand.QUICK_LAUNCH_RELEASE]);
    });
  });

  group('Directions', () {
    test('a held D-pad direction repeats after a delay, then at a faster interval', () {
      Duration secondRepeat = repeatDelay + repeatInterval;
      expect(mapper.update([pad(buttons: GamepadButtons.dpadDown)], ms(0)), [GamepadCommand.DOWN]);
      expect(mapper.update([pad(buttons: GamepadButtons.dpadDown)], repeatDelay - ms(1)), isEmpty);
      expect(mapper.update([pad(buttons: GamepadButtons.dpadDown)], repeatDelay), [GamepadCommand.DOWN]);
      expect(mapper.update([pad(buttons: GamepadButtons.dpadDown)], secondRepeat - ms(1)), isEmpty);
      expect(mapper.update([pad(buttons: GamepadButtons.dpadDown)], secondRepeat), [GamepadCommand.DOWN]);
      expect(mapper.update([pad()], secondRepeat + ms(16)), isEmpty);
    });

    test('a trigger makes a held direction repeat faster', () {
      Duration fastDelay = GamepadMapper.fastDirectionRepeatDelay;
      Duration fastInterval = GamepadMapper.fastDirectionRepeatInterval;
      expect(mapper.update([pad(leftY: -20000, trigger: 255)], ms(0)), [GamepadCommand.DOWN]);
      expect(mapper.update([pad(leftY: -20000, trigger: 255)], fastDelay - ms(1)), isEmpty);
      expect(mapper.update([pad(leftY: -20000, trigger: 255)], fastDelay), [GamepadCommand.DOWN]);
      expect(mapper.update([pad(leftY: -20000, trigger: 255)], fastDelay + fastInterval), [GamepadCommand.DOWN]);
      // A trigger pressed less than half way doesn't count, so the usual interval comes back
      Duration lastRepeat = fastDelay + fastInterval * 2;
      expect(mapper.update([pad(leftY: -20000, trigger: 100)], lastRepeat), [GamepadCommand.DOWN]);
      expect(mapper.update([pad(leftY: -20000, trigger: 100)], lastRepeat + fastInterval), isEmpty);
      expect(mapper.update([pad(leftY: -20000, trigger: 100)], lastRepeat + repeatInterval), [GamepadCommand.DOWN]);
    });

    test('the left stick needs 50% to press and goes under 30% to release', () {
      expect(mapper.update([pad(leftY: -9000)], ms(0)), isEmpty);
      expect(mapper.update([pad(leftY: -16000)], ms(16)), isEmpty);
      expect(mapper.update([pad(leftY: -17000)], ms(32)), [GamepadCommand.DOWN]);
      // Between both thresholds: still held, so no new command
      expect(mapper.update([pad(leftY: -12000)], ms(48)), isEmpty);
      expect(mapper.update([pad(leftY: -9000)], ms(64)), isEmpty);
      // Released: between both thresholds isn't enough to press again
      expect(mapper.update([pad(leftY: -12000)], ms(80)), isEmpty);
      expect(mapper.update([pad(leftX: 17000)], ms(96)), [GamepadCommand.RIGHT]);
    });

    test('a diagonal stick keeps its first direction', () {
      expect(mapper.update([pad(leftX: 20000, leftY: 19000)], ms(0)), [GamepadCommand.RIGHT]);
      expect(mapper.update([pad(leftX: 19000, leftY: 20000)], ms(16)), isEmpty);
      expect(mapper.update([pad(leftX: 19000, leftY: 20000)], repeatDelay), [GamepadCommand.RIGHT]);
    });

    test('the D-pad wins over the stick', () {
      expect(mapper.update([pad(buttons: GamepadButtons.dpadUp, leftY: -32768)], ms(0)), [GamepadCommand.UP]);
    });

    test('a D-pad diagonal keeps the held direction', () {
      expect(mapper.update([pad(buttons: GamepadButtons.dpadRight)], ms(0)), [GamepadCommand.RIGHT]);
      expect(mapper.update([pad(buttons: GamepadButtons.dpadRight | GamepadButtons.dpadDown)], ms(16)), isEmpty);
      expect(mapper.update([pad(buttons: GamepadButtons.dpadRight)], ms(32)), isEmpty);
      expect(mapper.update([pad(buttons: GamepadButtons.dpadRight)], repeatDelay), [GamepadCommand.RIGHT]);
    });

    test('the stick doesn\'t keep a direction started with the D-pad', () {
      expect(mapper.update([pad(buttons: GamepadButtons.dpadRight)], ms(0)), [GamepadCommand.RIGHT]);
      expect(mapper.update([pad(leftX: 12000)], ms(16)), isEmpty);
      expect(mapper.update([pad(leftX: 17000)], ms(32)), [GamepadCommand.RIGHT]);
    });
  });

  group('Right stick', () {
    test('scrolls and repeats every 80 ms', () {
      expect(mapper.update([pad(rightY: -20000)], ms(0)), [GamepadCommand.SCROLL_DOWN]);
      expect(mapper.update([pad(rightY: -20000)], ms(79)), isEmpty);
      expect(mapper.update([pad(rightY: -20000)], ms(80)), [GamepadCommand.SCROLL_DOWN]);
      expect(mapper.update([pad(rightY: 20000)], ms(96)), [GamepadCommand.SCROLL_UP]);
    });

    test('a trigger makes the scroll go further, at the same pace', () {
      expect(mapper.update([pad(rightY: -20000, trigger: 255)], ms(0)), [GamepadCommand.SCROLL_DOWN]);
      expect(mapper.fastScroll, isTrue);
      expect(mapper.update([pad(rightY: -20000, trigger: 255)], ms(79)), isEmpty);
      expect(mapper.update([pad(rightY: -20000, trigger: 255)], ms(80)), [GamepadCommand.SCROLL_DOWN]);
      // A trigger pressed less than half way doesn't count
      expect(mapper.update([pad(rightY: -20000, trigger: 100)], ms(96)), isEmpty);
      expect(mapper.fastScroll, isFalse);
    });

    test('keeps scrolling until the stick goes under 30%', () {
      expect(mapper.update([pad(rightY: -20000)], ms(0)), [GamepadCommand.SCROLL_DOWN]);
      expect(mapper.update([pad(rightY: -12000)], ms(80)), [GamepadCommand.SCROLL_DOWN]);
      expect(mapper.update([pad(rightY: -9000)], ms(160)), isEmpty);
      expect(mapper.update([pad(rightY: -12000)], ms(240)), isEmpty);
    });
  });

  group('Rebase', () {
    test('X held when rebasing isn\'t released either', () {
      expect(mapper.update([pad(buttons: GamepadButtons.x)], ms(0)), [GamepadCommand.QUICK_LAUNCH_PRESS]);
      mapper.rebase();
      expect(mapper.update([pad(buttons: GamepadButtons.x)], ms(16)), isEmpty);
      expect(mapper.update([pad()], ms(32)), isEmpty);
      expect(mapper.update([pad(buttons: GamepadButtons.x)], ms(48)), [GamepadCommand.QUICK_LAUNCH_PRESS]);
    });

    test('a button held when rebasing only counts once released', () {
      expect(mapper.update([pad(buttons: GamepadButtons.b)], ms(0)), [GamepadCommand.BACK]);
      mapper.rebase();
      expect(mapper.update([pad(buttons: GamepadButtons.b)], ms(16)), isEmpty);
      expect(mapper.update([pad(buttons: GamepadButtons.b)], ms(32)), isEmpty);
      expect(mapper.update([pad()], ms(48)), isEmpty);
      expect(mapper.update([pad(buttons: GamepadButtons.b)], ms(64)), [GamepadCommand.BACK]);
    });

    test('a direction held when rebasing doesn\'t repeat', () {
      mapper.rebase();
      expect(mapper.update([pad(buttons: GamepadButtons.dpadLeft)], ms(0)), isEmpty);
      expect(mapper.update([pad(buttons: GamepadButtons.dpadLeft)], ms(1000)), isEmpty);
      expect(mapper.update([pad()], ms(1016)), isEmpty);
      expect(mapper.update([pad(buttons: GamepadButtons.dpadLeft)], ms(1032)), [GamepadCommand.LEFT]);
    });

    test('sticks held when rebasing only count once released', () {
      mapper.rebase();
      expect(mapper.update([pad(leftY: -20000, rightY: -20000)], ms(0)), isEmpty);
      expect(mapper.update([pad(leftY: -12000, rightY: -12000)], ms(1000)), isEmpty);
      expect(mapper.update([pad(leftY: -9000)], ms(1016)), isEmpty);
      expect(mapper.update([pad(leftY: -17000)], ms(1032)), [GamepadCommand.DOWN]);
    });
  });

  group('Controllers', () {
    test('a disconnection forgets the held inputs', () {
      expect(mapper.update([pad(buttons: GamepadButtons.a | GamepadButtons.dpadUp)], ms(0)),
          [GamepadCommand.ACTIVATE, GamepadCommand.UP]);
      expect(mapper.update([], ms(100)), isEmpty);
      expect(mapper.update([], ms(500)), isEmpty);
      // The service rebases when a controller is connected, the mapper itself starts over
      expect(mapper.update([pad(buttons: GamepadButtons.a | GamepadButtons.dpadUp)], ms(600)),
          [GamepadCommand.ACTIVATE, GamepadCommand.UP]);
    });

    test('every connected controller can be used', () {
      expect(mapper.update([pad(buttons: GamepadButtons.dpadRight), pad(buttons: GamepadButtons.a)], ms(0)),
          [GamepadCommand.ACTIVATE, GamepadCommand.RIGHT]);
      expect(mapper.update([pad(), pad(leftY: 30000)], ms(16)), [GamepadCommand.UP]);
    });
  });
}
