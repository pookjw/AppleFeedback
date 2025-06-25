//
//  main.m
//  MyScript
//
//  Created by Jinwoo Kim on 6/25/25.
//

#import <Cocoa/Cocoa.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSSplitViewItem *item = [NSSplitViewItem contentListWithViewController:[NSViewController new]];
        
        // Works fine
        [item addTopAlignedAccessoryViewController:[NSSplitViewItemAccessoryViewController new]];
        // Works fine
        [item addTopAlignedAccessoryViewController:[NSSplitViewItemAccessoryViewController new]];
        // Works fine
        [item addTopAlignedAccessoryViewController:[NSSplitViewItemAccessoryViewController new]];
        
        // Works fine
        item.topAlignedAccessoryViewControllers = [NSMutableArray new];
        
        // -[__NSArray0 addObject:]: unrecognized selector sent to instance 0x204aee150
        [item addTopAlignedAccessoryViewController:[NSSplitViewItemAccessoryViewController new]];
    }
    return EXIT_SUCCESS;
}
