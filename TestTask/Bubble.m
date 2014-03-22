//
// Created by Oleg Tyshchenko on 3/22/14.
// Copyright (c) 2014 olegtyshchenko. All rights reserved.
//

#import "Bubble.h"
#import "UITouch+CC.h"

static NSString *const imageName = @"bubble.png";

int nextFromTo(int from, int to) {
    return (arc4random() % (to - from + 1)) + from;
}

@implementation Bubble {

}

+ (Bubble *)initBubble {
    Bubble *bubble = [[self alloc] initWithImageNamed:imageName];
    bubble.userInteractionEnabled = YES;

    return bubble;
}

+ (Bubble *)initBubbleWithPosition:(CGPoint)pos {
    Bubble *bubble = [self initBubble];
    bubble.position = pos;

    return bubble;
}


- (void)update:(CCTime)delta {
    [self naiveFloatAnim];
}

- (void)naiveFloatAnim {
    if(self.numberOfRunningActions == 0) {
        CGPoint moveByPos = ccp(nextFromTo(-40, 40), nextFromTo(-40, 40));
        CCActionEase *moveByEase = [CCActionEaseElastic actionWithAction: [CCActionMoveBy actionWithDuration:2 position:moveByPos]];

        [self runAction:moveByEase];
    }
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    id parent = [self parent];
    [parent removeChild:self cleanup:YES];
}

@end