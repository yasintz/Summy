import 'package:flutter/material.dart';

enum TimerControllerCallbackType {
  START,
  STOP,
  RESTART,
  PAUSE,
  RESUME,
  COLOR_CHANGE,
  VALUE_CHANGE,
  VALUE_CHANGE_IN_ANIMATION,
}

class CallbackListItem {
  final VoidCallback callback;
  final TimerControllerCallbackType type;
  final String id;
  bool removed = false;

  CallbackListItem(this.callback, this.type, this.id);

  void remove() {
    this.removed = true;
  }

  @override
  String toString() =>
      "type:${type.toString()} id:$id cb: ${callback.toString()}";
}

class TimerController {
  Duration animationDuration;
  Color color;

  Duration _value;

  Duration get value => _value;

  List<CallbackListItem> _list = List();
  bool _isStarted = false;
  bool _isPaused = false;

  bool get isStarted => _isStarted;

  TimerController({
    @required this.animationDuration,
    @required this.color,
  }) : _value = animationDuration;

  void setColor(Color c) {
    if (c == color) {
      return;
    }

    color = c;
    _runCallback(TimerControllerCallbackType.COLOR_CHANGE);
  }

  void setValueFromAnimation(double percent) {
    double microsecond = percent * animationDuration.inMicroseconds / 100;
    _setValue(
      Duration(microseconds: microsecond.round()),
      TimerControllerCallbackType.VALUE_CHANGE,
    );
  }

  void setValue(Duration newValue) {
    _setValue(
      newValue,
      TimerControllerCallbackType.VALUE_CHANGE_IN_ANIMATION,
    );
  }

  void _setValue(Duration newValue, TimerControllerCallbackType type) {
    if (newValue == value) {
      return;
    }
    _value = newValue;
    _runCallback(type);
  }

  void start() {
    if (_isStarted) {
      return;
    }

    _isStarted = true;
    _isPaused = false;
    _runCallback(TimerControllerCallbackType.START);
  }

  void stop() {
    if (!_isStarted) {
      return;
    }

    _isStarted = false;
    _isPaused = false;
    _runCallback(TimerControllerCallbackType.STOP);
  }

  void pause() {
    if (!_isStarted || _isPaused) {
      return;
    }

    _isPaused = true;
    _runCallback(TimerControllerCallbackType.PAUSE);
  }

  void restart() {
    if (!_isStarted) {
      return;
    }

    _isPaused = false;
    _runCallback(TimerControllerCallbackType.RESTART);
  }

  void resume() {
    if (!_isStarted || !_isPaused) {
      return;
    }

    _isPaused = false;
    _runCallback(TimerControllerCallbackType.RESUME);
  }

  void addEventListener(
    TimerControllerCallbackType type,
    VoidCallback cb, {
    String id,
  }) {
    _list.add(CallbackListItem(cb, type, "${id ?? cb.hashCode}"));
  }

  void removeEventListener({
    String id,
    TimerControllerCallbackType type,
    VoidCallback callback,
  }) {
    if (id != null) {
      _list
          .where((element) => element.id == id)
          .forEach((element) => element.remove());
    }

    if (type != null) {
      _list
          .where((element) => element.type == type)
          .forEach((element) => element.remove());
    }

    if (callback != null) {
      _list
          .where((element) => element.callback == callback)
          .forEach((element) => element.remove());
    }
  }

  void _runCallback(TimerControllerCallbackType type) {
    _list.where((element) => element.type == type).forEach((element) {
      if (!element.removed) {
        element.callback();
      }
    });
  }
}
