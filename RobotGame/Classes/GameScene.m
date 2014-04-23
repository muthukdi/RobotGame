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

    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Toggle State ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f);
    [backButton setTarget:self selector:@selector(toggleRobotState)];
    [self addChild:backButton];
    
    [self schedule:@selector(tick:) interval:0.1];
    
	return self;
}

- (void)tick:(CCTime)dt
{
    [_robot update:dt];
}

- (void)toggleRobotState
{
    _robot.state = (_robot.state == ROBOT_IDLE) ? ROBOT_RUN : ROBOT_IDLE;
}

@end
