CNSCript.detectionTrack(for:) returns a track with an invalid detection ID.

https://developer.apple.com/documentation/cinematic/playing-and-editing-cinematic-mode-video

Add this code into SampleObjectTracking.swift::line170

```swift
        do {
            assert(detectionTrack.detectionID == detectionID)
            assert(__CNDetection.isValidDetectionID(detectionID))
            let newTrack = cinematicAssetData.script.detectionTrack(for: detectionID)!
            assert(__CNDetection.isValidDetectionID(newTrack.detectionID)) // Fails
        }
```

---

It seems that this issue occurs because `-[PTCinematographyCustomTrack _initWithCustomTrack:] `does not copy the `-[PTCinematographyTrack trackIdentifier`].

Swizzling `-[PTCinematographyCustomTrack _initWithCustomTrack:]` resolves this issue.

```objc
#import <Cinematic/Cinematic.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNDetection (CP_Category)

@end

NS_ASSUME_NONNULL_END

#import <objc/message.h>
#import <objc/runtime.h>

namespace cp_PTCinematographyCustomTrack {
    namespace _initWithCustomTrack_ {
        id (*original)(id self, SEL _cmd, id customTrack);
        id custom(id self, SEL _cmd, id customTrack) {
            self = original(self, _cmd, customTrack);
            
            if (self) {
                CNDetectionID trackIdentifier = reinterpret_cast<CNDetectionID (*)(id, SEL)>(objc_msgSend)(customTrack, sel_registerName("trackIdentifier"));
                reinterpret_cast<void (*)(id, SEL, CNDetectionID)>(objc_msgSend)(self, sel_registerName("setTrackIdentifier:"), trackIdentifier);
            }
            
            return self;
        }
        void swizzle() {
            Method method = class_getInstanceMethod(objc_lookUpClass("PTCinematographyCustomTrack"), sel_registerName("_initWithCustomTrack:"));
            original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
            method_setImplementation(method, reinterpret_cast<IMP>(custom));
        }
    }
}

@implementation CNDetection (CP_Category)

+ (void)load {
    cp_PTCinematographyCustomTrack::_initWithCustomTrack_::swizzle();
}

@end
```
