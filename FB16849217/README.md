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
