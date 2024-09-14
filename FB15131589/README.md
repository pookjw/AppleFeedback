Calling -setSharedObservers: multiple times throws an exception.

In the documentation for `-[NSObject<NSKeyValueSharedObserverRegistration> setSharedObservers:]`, located in `NSKeyValueSharedObservers.h`, it explains the following:

```
/// An observable may only have one set of shared observations. Subsequent calls
/// to this method will replace existing shared observations.
```

However, when I make subsequent calls to -setSharedObservers: as shown below, an exception is thrown:

```objc
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        FooObject *fooObject = [FooObject new];
        MyObject *myObject = [MyObject new];
        
        NSKeyValueSharedObservers *obs_1 = [[NSKeyValueSharedObservers alloc] initWithObservableClass:FooObject.class];
        [obs_1 addSharedObserver:myObject forKey:@"number" options:NSKeyValueObservingOptionNew context:NULL];
        [fooObject setSharedObservers:obs_1.snapshot];
        
        [fooObject setSharedObservers:nil];
        
        NSKeyValueSharedObservers *obs_2 = [[NSKeyValueSharedObservers alloc] initWithObservableClass:FooObject.class];
        [obs_2 addSharedObserver:myObject forKey:@"number" options:NSKeyValueObservingOptionNew context:NULL];
        
        // Thread 1: "<FooObject: 0x6000038600a0>: Attempted to set shared observers from snapshot <NSKeyValueSharedObserversSnapshot: 0x600003a66a00>, which is outdated"
        [fooObject setSharedObservers:obs_2.snapshot];
    }
    
    return 0;
}
```

It seems that `-[NSKeyValueSharedObserversSnapshot _assignToObject:]` throws an exception when `object_getClass($x2) == $x0->_observableClass` evaluates to `0x0`.

```asm
Foundation`-[NSKeyValueSharedObserversSnapshot _assignToObject:]:
    0x19f8ffe04 <+20>:  mov    x19, x2
    0x19f8ffe08 <+24>:  mov    x20, x0
    0x19f8ffe0c <+28>:  mov    x0, x2
    0x19f8ffe10 <+32>:  bl     0x19fa8238c               ; symbol stub for: object_getClass
    0x19f8ffe14 <+36>:  ldr    x8, [x20, #0x10]
    0x19f8ffe18 <+40>:  cmp    x0, x8
    0x19f8ffe1c <+44>:  b.ne   0x19f8ffe68               ; <+120>
    
    ...
    
    0x19f8ffe54 <+100>: b      0x19fa823ec               ; symbol stub for: object_setClass
```

In the first call, the result is 0x1, but in the second call, it results in 0x0. This is because, during the second call, `object_getClass($x2)` returns `NSKVONotifying_FooObject` instead of `FooObject`. At `<+100>`, `object_setClass` replaces the isa of `$x2`, which causes the exception during the second call.

(`NSKVONotifying_FooObject` is allocated (`objc_allocateClassPair`) and registered (`objc_registerClassPair`) when `-addSharedObserver:forKey:options:` is called. Internally, it invokes `_NSKVONotifyingCreateInfoWithOriginalClass`, which handles the allocation and registration.)

This behavior differs from the documentation, and I believe it is a bug.
