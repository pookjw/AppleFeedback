//
//  ViewController.m
//  MyApp
//
//  Created by Jinwoo Kim on 6/24/24.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong) IBOutlet NSTextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Why are you reading this?" attributes:@{
        NSTextHighlightStyleAttributeName: NSTextHighlightStyleDefault
    }];
    
    NSTextView *textView = self.textView;
    
    [textView.textStorage setAttributedString:attributedString];
    textView.textHighlightAttributes = @{
        NSBackgroundColorAttributeName: NSColor.orangeColor,
        NSForegroundColorAttributeName: NSColor.blueColor
    };
}

@end
