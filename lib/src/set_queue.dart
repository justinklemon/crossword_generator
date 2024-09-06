import 'dart:collection';

/// A class that represents a set queue.
///
/// A set queue is a queue that does not allow duplicate elements.
class SetQueue<T> {
  final Queue<T> _queue = Queue<T>();
  final Set<T> _set = {};

  /// Adds the given [element] to the end of the queue.
  /// 
  /// If the element is already in the queue, does nothing and returns false.
  /// Otherwise, adds the element to the queue and returns true.
  bool addLast(T element) {
    if (_set.contains(element)) {
      return false;
    }
    _queue.addLast(element);
    _set.add(element);
    return true;
  }

  /// Removes and returns the first element in the queue.
  ///
  /// If the queue is empty, returns null.
  T? removeFirst() {
    if (_queue.isEmpty) {
      return null;
    }
    T element = _queue.removeFirst();
    _set.remove(element);
    return element;
  }

  /// Returns true if the queue is empty.
  /// 
  /// Otherwise, returns false.
  bool get isEmpty => _queue.isEmpty;

  /// Returns true if the queue is not empty.
  /// 
  /// Otherwise, returns false.
  bool get isNotEmpty => _queue.isNotEmpty;

  /// Returns the number of elements in the queue.
  int get length => _queue.length;
}
