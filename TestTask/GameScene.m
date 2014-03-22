//
// Created by Oleg Tyshchenko on 3/20/14.
// Copyright (c) 2014 olegtyshchenko. All rights reserved.
//

#import "GameScene.h"
#import "CCSprite.h"
#import "CCDirector.h"
#import "CCButton.h"
#import "CCTextField.h"
#import "Bubble.h"

static CGPoint const WASHER_POS = {512, 92};
static CGPoint const MIRROR_BACK_POS = {512, 450};
static CGPoint const SHELVES_POS = {512, 457};
static CGPoint const MIRROR_POS = {512, 452};
static CGPoint const LEFT_BOARD_POS = {112, 448};
static CGPoint const RIGHT_BOARD_POS = {916, 448};
static CGPoint const BACK_TO_BED_POS = {900, 719};
static CGPoint const LEFT_STRINGS_POS = {80, 743};
static CGPoint const SOUND_BUTTON_POS = {115, 695};
static CGPoint const HOME_POS = {45, 695};
static CGPoint const SHAMPOO_POS = {145, 523};
static CGPoint const MEDKIT_POS = {892, 518};
static CGPoint const LEFT_DOOR_POS = {143, 448};
static CGPoint const RIGHT_DOOR_POS = {886, 448};
static CGPoint const SOAP_POS = {320, 100};

static int const SWIPE_TRESHOLD = 3;

@interface GameScene () {

}
@end

@implementation GameScene {
    int soapSwipeCounter;
    CCSprite *soap;

    CCSprite *soundButtonOn;
    CCSprite *soundButtonOff;

    CCSprite *medKit;
    CCSprite *shampoo;

    CCSprite *leftDoor;
    CCSprite *rightDoor;
    //NSArray *bubbles;
}
+ (GameScene *)scene {
    return [[self alloc] init];
}

+ (NSDictionary *)getZPosDict {
    return @{@"mirror" : [NSNumber numberWithInt:2],
            @"mirrorBack" : [NSNumber numberWithInt:1],
            @"washer" : [NSNumber numberWithInt:2],
            @"soap" : [NSNumber numberWithInt:3],
            @"shelves" : [NSNumber numberWithInt:3],
            @"rightBoard" : [NSNumber numberWithInt:3],
            @"leftBoard" : [NSNumber numberWithInt:3],
            @"menuItem" : [NSNumber numberWithInt:6],
            @"shampoo" : [NSNumber numberWithInt:4],
            @"medKit" : [NSNumber numberWithInt:4],
            @"doors" : [NSNumber numberWithInt:5],
            @"bubble" : [NSNumber numberWithInt:6]
    };
}

- (id)init {
    self = [super init];
    if (!self) return (nil);
    self.userInteractionEnabled = YES;

    [self initImages];

    return self;
}

- (void)initImages {
    soundButtonOn = [CCSprite spriteWithImageNamed:@"sound_button_on.png"];
    soundButtonOff = [CCSprite spriteWithImageNamed:@"sound_button_off.png"];

    [self initStaticImages];
    [self initMenu];
    [self initDynamicElements];
}

- (void)initStaticImages {
    NSDictionary *posDict = [GameScene getZPosDict];

    // background:
    CGSize surfaceSize = [[CCDirector sharedDirector] viewSize];
    CCSprite *background = [CCSprite spriteWithImageNamed:@"background.png"];
    background.position = ccp(surfaceSize.width / 2, surfaceSize.height / 2);
    [self addChild:background];
    //---//

    // images:
    CCSprite *washer = [CCSprite spriteWithImageNamed:@"washer.png"];
    washer.position = WASHER_POS;

    CCSprite *mirrorBack = [CCSprite spriteWithImageNamed:@"mirror_back.png"];
    mirrorBack.position = MIRROR_BACK_POS;

    CCSprite *shelves = [CCSprite spriteWithImageNamed:@"shelves.png"];
    shelves.position = SHELVES_POS;

    CCSprite *mirror = [CCSprite spriteWithImageNamed:@"mirror.png"];
    mirror.position = MIRROR_POS;

    CCSprite *leftBoard = [CCSprite spriteWithImageNamed:@"left_board.png"];
    leftBoard.position = LEFT_BOARD_POS;

    CCSprite *rightBoard = [CCSprite spriteWithImageNamed:@"rigth_board.png"];
    rightBoard.position = RIGHT_BOARD_POS;
    //---//

    [self addChild:mirrorBack z:[posDict[@"mirrorBack"] integerValue]];
    [self addChild:mirror z:[posDict[@"mirror"] integerValue]];
    [self addChild:shelves z:[posDict[@"shelves"] integerValue]];
    [self addChild:leftBoard z:[posDict[@"leftBoard"] integerValue]];
    [self addChild:rightBoard z:[posDict[@"rightBoard"] integerValue]];
    [self addChild:washer z:[posDict[@"washer"] integerValue]];
}

- (void)initMenu {
    NSInteger menuZPos = [[GameScene getZPosDict][@"menuItem"] integerValue];

    CCSprite *leftStrings = [CCSprite spriteWithImageNamed:@"left_strings.png"];
    leftStrings.position = LEFT_STRINGS_POS;

    CCSprite *backToBed = [CCSprite spriteWithImageNamed:@"back_bed_button.png"];
    backToBed.position = BACK_TO_BED_POS;

    CCSprite *home = [CCSprite spriteWithImageNamed:@"home_button.png"];
    CCButton *homeButton = [CCButton buttonWithTitle:@"" spriteFrame:[home spriteFrame]];
    homeButton.position = HOME_POS;
    [homeButton setTarget:self selector:@selector(onHomeClicked:)];

    CCButton *soundButton = [CCButton buttonWithTitle:@""
                                          spriteFrame:[soundButtonOn spriteFrame]
                               highlightedSpriteFrame:[soundButtonOff spriteFrame]
                                  disabledSpriteFrame:nil];
    soundButton.togglesSelectedState = true;
    soundButton.name = @"on";
    soundButton.position = SOUND_BUTTON_POS;
    [soundButton setTarget:self selector:@selector(onSoundClicked:)];

    [self addChild:leftStrings z:menuZPos];
    [self addChild:backToBed z:menuZPos];
    [self addChild:homeButton z:menuZPos];
    [self addChild:soundButton z:menuZPos];
}

- (void)initDynamicElements {
    NSDictionary *posDict = [GameScene getZPosDict];

    shampoo = [CCSprite spriteWithImageNamed:@"shampoos.png"];
    shampoo.position = SHAMPOO_POS;

    medKit = [CCSprite spriteWithImageNamed:@"medkit.png"];
    medKit.position = MEDKIT_POS;

    leftDoor = [CCSprite spriteWithImageNamed:@"left_door.png"];
    leftDoor.position = LEFT_DOOR_POS;

    rightDoor = [CCSprite spriteWithImageNamed:@"right_door.png"];
    rightDoor.position = RIGHT_DOOR_POS;

    soap = [CCSprite spriteWithImageNamed:@"soap.png"];
    soap.position = SOAP_POS;

    [self addChild:shampoo z:[posDict[@"shampoo"] integerValue]];
    [self addChild:medKit z:[posDict[@"medKit"] integerValue]];
    [self addChild:leftDoor z:[posDict[@"doors"] integerValue]];
    [self addChild:rightDoor z:[posDict[@"doors"] integerValue]];
    [self addChild:soap z:[posDict[@"soap"] integerValue]];
}

- (void)onSoundClicked:(id)sender {
    //Soundoff logic
    if ([[(CCButton *) sender name] isEqualToString:@"on"]) {
        [(CCButton *) sender setName:@"off"];
        NSLog(@"Setting music off...");
    } else {
        [(CCButton *) sender setName:@"on"];
        NSLog(@"Setting music on...");
    }
}

- (void)onHomeClicked:(id)sender {
    leftDoor.visible = YES;
    rightDoor.visible = YES;
}

- (BOOL)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInWorld];

    soapSwipeCounter = 0;

    if (CGRectContainsPoint(leftDoor.boundingBox, touchLoc) && leftDoor.visible) {
        leftDoor.visible = NO;
        return YES;
    }
    if (CGRectContainsPoint(rightDoor.boundingBox, touchLoc) && rightDoor.visible) {
        rightDoor.visible = NO;
        return YES;
    }

    if (CGRectContainsPoint(shampoo.boundingBox, touchLoc)) {
        NSLog(@"Touched shampoo");

        if (shampoo.numberOfRunningActions == 0) {
            id fadeOut = [CCActionFadeOut actionWithDuration:1];
            id actionSequence = [CCActionSequence actions:fadeOut, [fadeOut reverse], nil];
            [shampoo runAction:actionSequence];
        }
    }
    if (CGRectContainsPoint(medKit.boundingBox, touchLoc)) {
        NSLog(@"Touched medkit");

        if (medKit.numberOfRunningActions == 0) {
            id scaleAction = [CCActionScaleBy actionWithDuration:0.5 scale:1.2f];
            id rotateAction = [CCActionRotateBy actionWithDuration:0.5 angle:10];
            id actionSequence =
                    [CCActionSequence actions:scaleAction, rotateAction, [rotateAction reverse], [scaleAction reverse], nil];
            [medKit runAction:actionSequence];
        }
    }

    return YES;
}

- (BOOL)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInWorld];

    if(CGRectContainsPoint(soap.boundingBox, touchLoc)) {
        soapSwipeCounter++;
        NSLog(@"%d", soapSwipeCounter);
    }

    return YES;
}

- (BOOL)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if(soapSwipeCounter >= SWIPE_TRESHOLD) {
        id bubble = [Bubble initBubbleWithPosition:soap.position];
        [self addChild:bubble z:[[GameScene getZPosDict][@"bubble"] integerValue]];
    }
    return YES;
}


@end