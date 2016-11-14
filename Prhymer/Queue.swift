//
//  Queue.swift
//  NTBSwift
//
//  Created by Kåre Morstøl on 11/07/14.
//  Modified by Thomas Lisankie on 5/25/16.
//
//  Using the "Two-Lock Concurrent Queue Algorithm" from http://www.cs.rochester.edu/research/synchronization/pseudocode/queues.html#tlq, without the locks.


// should be an inner class of Queue, but inner classes and generics crash the compiler, SourceKit (repeatedly) and occasionally XCode.
class _QueueItem<T> {
    let value: T!
    var next: _QueueItem?
    
    init(_ newvalue: T?) {
        self.value = newvalue
    }
}

///
/// A standard queue (FIFO - First In First Out). Supports simultaneous adding and removing, but only one item can be added at a time, and only one item can be removed at a time.
///
open class Queue<T> {
    
    var _front: _QueueItem<T>
    var _back: _QueueItem<T>
    var count = 0;
    
    public init () {
        // Insert dummy item. Will disappear when the first item is added.
        _back = _QueueItem(nil)
        _front = _back
        
        count = count + 1;
    }
    
    /// Add a new item to the back of the queue.
    open func enqueue (_ value: T) {
        _back.next = _QueueItem(value)
        _back = _back.next!
        count = count + 1;
    }
    
    /// Return and remove the item at the front of the queue.
    //should have it throw a null pointer exception.
    open func dequeue () -> T? {
        
        count = count - 1;
        
        if let newhead = _front.next {
            _front = newhead
            return newhead.value
        }
        
        return nil;
        
    }
    
    open func isEmpty() -> Bool {
        return _front === _back
    }
}
