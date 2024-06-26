//
//  MyViewController.mm
//  MyApp
//
//  Created by Jinwoo Kim on 6/26/24.
//

#import "MyViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface MyView : NSView
@end
@implementation MyView

- (void)rulerView:(NSRulerView *)ruler handleMouseDown:(NSEvent *)event {
    NSRulerMarker *marker = [[NSRulerMarker alloc] initWithRulerView:ruler markerLocation:0. image:[NSImage imageWithSystemSymbolName:@"apple.logo" accessibilityDescription:nil] imageOrigin:NSZeroPoint];
    marker.movable = YES;
    
    [ruler trackMarker:marker withMouseEvent:event];
}

- (void)rulerView:(NSRulerView *)ruler handleMouseDown:(NSEvent *)event forMarker:(NSRulerMarker *)marker {
    NSLog(@"%s", sel_getName(_cmd));
}

@end

@interface MyViewController ()
@property (strong, nonatomic) NSScrollView *scrollView;
@property (strong, nonatomic) MyView *myView;
@end

@implementation MyViewController

- (void)loadView {
    self.view = self.scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSScrollView *)scrollView {
    if (auto scrollView = _scrollView) return scrollView;
    
    NSScrollView *scrollView = [NSScrollView new];
    
    scrollView.documentView = self.myView;
    scrollView.hasHorizontalRuler = YES;
    scrollView.hasVerticalRuler = YES;
    scrollView.rulersVisible = YES;
    scrollView.horizontalRulerView.clientView = self.myView;
    scrollView.verticalRulerView.clientView = self.myView;
    
    _scrollView = scrollView;
    return scrollView;
}

- (MyView *)myView {
    if (auto myView = _myView) return myView;
    
    MyView *myView = [MyView new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(myView, sel_registerName("setBackgroundColor:"), NSColor.systemOrangeColor);
    
    myView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    
    _myView = myView;
    return myView;
}

@end
