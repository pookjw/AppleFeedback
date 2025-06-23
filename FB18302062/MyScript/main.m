//
//  main.m
//  MyScript
//
//  Created by Jinwoo Kim on 6/23/25.
//

#import <AppKit/AppKit.h>
#include <objc/message.h>
#include <objc/runtime.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSImageSymbolConfiguration *symbol_1 = [NSImageSymbolConfiguration configurationWithVariableValueMode:NSImageSymbolVariableValueModeAutomatic];
        NSLog(@"%@", symbol_1); // value mode: Automatic ✅
        NSImageSymbolConfiguration *symbol_2 = [NSImageSymbolConfiguration configurationWithVariableValueMode:NSImageSymbolVariableValueModeColor];
        NSLog(@"%@", symbol_2); // variable value mode: Color ✅
        NSImageSymbolConfiguration *symbol_3 = [NSImageSymbolConfiguration configurationWithVariableValueMode:NSImageSymbolVariableValueModeDraw];
        NSLog(@"%@", symbol_3); // variable value mode: Draw ✅
        
        NSImageSymbolConfiguration *symbol_4 = [symbol_1 configurationByApplyingConfiguration:symbol_3];
        NSLog(@"%@", symbol_4); // variable value mode: Draw ✅
        NSImageSymbolConfiguration *symbol_5 = [symbol_2 configurationByApplyingConfiguration:symbol_3];
        NSLog(@"%@", symbol_5); // variable value mode: Automatic 😞 (Expected: variable value mode: Draw)
        
        NSImageSymbolVariableValueMode variableValueMode = ((NSImageSymbolVariableValueMode (*)(id, SEL))objc_msgSend)(symbol_5, sel_registerName("variableValueMode"));
        NSLog(@"%ld", variableValueMode); // 3 😞 (Expected: 2 (NSImageSymbolVariableValueModeDraw))
        
        /*
         0x38 = offset of _variableValueMode
         
         0x194c8e0b8 <+80>:  ldp    x10, x9, [x0, #0x38]
         0x194c8e0bc <+84>:  orr    x8, x9, x8
         0x194c8e0c0 <+88>:  str    x8, [x0, #0x40]
         0x194c8e0c4 <+92>:  ldr    x8, [x19, #0x38]
         0x194c8e0c8 <+96>:  orr    x8, x10, x8             # (other->_variableValueMode) | (self->_variableValueMode) -> it should be (other->_variableValueMode)
         */
    }
    
    return EXIT_SUCCESS;
}
