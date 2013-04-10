//
//  UIGestureRecognizer+Blocks.m
//  UIGestureRecognizers_Demo
//
//  Created by Ian Outterside on 10/04/2013.
//  Copyright (c) 2013 Duchy Software Ltd. All rights reserved.
//

/* 
 
 Discussion

 This catagory leverages the objective-c runtime to dynamically bind a block to a UIGestureRecognizer object.
 This means that all UIGestureRecognizer subclasses (eg UITapGestureRecognizer, UIPanGestureRecognizer etc) can
 now leverage the power of blocks simply by importing the catagory.
 
 To use the block based API, simply call:
 
 UI(Tap/Pan/etc)GestureRecognizer *gesture = [[UI(Tap/Pan/etc)GestureRecognizer alloc] initWithBlock:^(UIGestureRecognizer *recognizer){
    
    // Callback code
 
    // In the callback code, if you need specfic actions of the recognizer, simply cast it back to its original type - eg:
 
    // UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)recognizer;
 }];

 */

#import "UIGestureRecognizer+Blocks.h"
#import <objc/runtime.h> // Need the objective-c runtime for object associations

@implementation UIGestureRecognizer (Blocks)

// Create static reference pointer to access stored block operation
static char kUIGESTURERECOGNIZER_BLOCK_IDENTIFIER;

- (id)initWithBlock:(UIGestureRecognizerActionBlock)block {
    
    if (self = [self init]) {
        
        // Add a target/action to the recognizer, calling back to [self completionHandler]
        [self addTarget:self action:@selector(completionHandler)];
        
        // Wrap the passed in block inside an anonymous block, calling back with the UIGestureRecognizer
        // This allows the block to be stored in the NSBlockOperation object
        void (^callbackBlock)(void) = ^{
            if (block) {
                block(self);
            }
        };
        
        // Wrap the anonymous block in a block operation
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:callbackBlock];
        
        // Store the NSBlockOperation as an associated object of the UIGestureRecognizer
        // Associations are released automatically when the gestureregonizer is dealloced, so the block will be removed as well
        objc_setAssociatedObject(self, &kUIGESTURERECOGNIZER_BLOCK_IDENTIFIER, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return self;
}

// This fires when the normal target:action fires
- (void)completionHandler {
    
    // Fetch the block operation from the association
    NSBlockOperation *blockOperation = (NSBlockOperation *)objc_getAssociatedObject(self, &kUIGESTURERECOGNIZER_BLOCK_IDENTIFIER);
    
    // If the block operation exists, call start. This invokes the anonymous block, in turn invoking the passed in block
    if (blockOperation) {
        [blockOperation start];
    }
}

@end
