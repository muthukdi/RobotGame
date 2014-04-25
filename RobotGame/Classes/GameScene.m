//
//  GameScene.m
//  RobotGame
//
//  Created by Dilip Muthukrishnan on 2014-04-21.
//  Copyright Dilip Muthukrishnan 2014. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

+ (GameScene *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    
    CCSprite *background = [CCSprite spriteWithImageNamed:@"Layer1.png"];
    background.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    [self addChild:background];
    
    _robot = [[Robot alloc] initWithPosition:ccp(self.contentSize.width/2, 128.0) view:self];

    // Create the left and right motion controls
    leftButton = [CCButton buttonWithTitle:@""
                                         spriteFrame:[CCSpriteFrame frameWithImageNamed:@"leftarrow.png"]];
    leftButton.scale = 0.5f;
    leftButton.exclusiveTouch = NO;
    leftButton.claimsUserInteraction = NO;
    leftButton.position = ccp(leftButton.boundingBox.size.width/2,
                              self.contentSize.height - leftButton.boundingBox.size.height/2);
    [self addChild:leftButton];
    rightButton = [CCButton buttonWithTitle:@""
                               spriteFrame:[CCSpriteFrame frameWithImageNamed:@"rightarrow.png"]];
    rightButton.scale = 0.5f;
    rightButton.exclusiveTouch = NO;
    rightButton.claimsUserInteraction = NO;
    rightButton.position = ccp(self.contentSize.width - rightButton.boundingBox.size.width/2,
                              self.contentSize.height - rightButton.boundingBox.size.height/2);
    [self addChild:rightButton];
    
	return self;
}

- (void)update:(CCTime)dt
{
    [_robot update:dt];
}


#pragma mark - RobotDelegate protocol methods

- (CGFloat)getScreenWidth
{
    return self.contentSize.width;
}

- (CGFloat)getScreenHeight
{
    return self.contentSize.height;
}

- (BOOL)leftEnabled
{
    return leftButton.tracking;
}

- (BOOL)rightEnabled
{
    return rightButton.tracking;
}

- (BOOL)leftRightDisabled
{
    return !(leftButton.tracking || rightButton.tracking);
}

@end
