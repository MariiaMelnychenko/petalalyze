import 'dart:async';

enum DetectionEvent { added, deleted }

/// Broadcast stream that notifies listeners when the detection list changes.
class DetectionEventBus {
  final _controller = StreamController<DetectionEvent>.broadcast();

  Stream<DetectionEvent> get stream => _controller.stream;

  void fire(DetectionEvent event) => _controller.add(event);

  void dispose() => _controller.close();
}
