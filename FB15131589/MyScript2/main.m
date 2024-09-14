//
//  main.m
//  MyScript2
//
//  Created by Jinwoo Kim on 9/15/24.
//

#import <Foundation/Foundation.h>

@interface FooObject : NSObject
@property NSUInteger number;
@end
@implementation FooObject
@end

@interface MyObject : NSObject
@end
@implementation MyObject
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"number"]) {
        NSLog(@"Foo!");
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end


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
        [fooObject setSharedObservers:obs_2.snapshot];
    }
    
    return 0;
}
