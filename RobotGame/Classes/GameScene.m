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
    
    // Initialize the time
    _time = 0.0;
    // Play the background music
    //[[OALSimpleAudio sharedInstance] playBg:@"music.mp3" volume:0.3f pan:0.0f loop:YES];
    CCSprite *background = [CCSprite spriteWithImageNamed:@"Layer1.png"];
    background.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    [self addChild:background];
    // Initialize the robot
    _robot = [[Robot alloc] initWithPosition:ccp(self.contentSize.width/2, 128.0) view:self];
    // Initialize the crawlers with random configurations
    _crawlers = [NSMutableArray arrayWithCapacity:4];
    float randomX;
    BOOL randomDirection;
    float randomScale;
    for (int i = 0; i < 4; i++)
    {
        randomX = (float)(arc4random() % ((int)(self.contentSize.width) - 128) + 64);
        randomDirection = (BOOL)(arc4random() % 2);
        randomScale = (float)(arc4random() % 16 + 5)/10.0f;
        [_crawlers addObject:[[Crawler alloc] initWithPosition:ccp(randomX, 128.0)
                                                          view:self
                                                     direction:randomDirection
                                                    speedScale:randomScale]];
    }
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
    // Create the jump buttons
    jumpButton1 = [CCButton buttonWithTitle:@""
                               spriteFrame:[CCSpriteFrame frameWithImageNamed:@"jump.png"]];
    jumpButton1.scale = 0.5f;
    jumpButton1.exclusiveTouch = NO;
    jumpButton1.claimsUserInteraction = NO;
    jumpButton1.position = ccp(jumpButton1.boundingBox.size.width/2,
                              self.contentSize.height - 3*jumpButton1.boundingBox.size.height/2);
    [self addChild:jumpButton1];
    jumpButton2 = [CCButton buttonWithTitle:@""
                                spriteFrame:[CCSpriteFrame frameWithImageNamed:@"jump.png"]];
    jumpButton2.scale = 0.5f;
    jumpButton2.exclusiveTouch = NO;
    jumpButton2.claimsUserInteraction = NO;
    jumpButton2.position = ccp(self.contentSize.width - jumpButton2.boundingBox.size.width/2,
                               self.contentSize.height - 3*jumpButton2.boundingBox.size.height/2);
    [self addChild:jumpButton2];
    
	return self;
}

- (void)update:(CCTime)dt
{
    // Increment the time elapsed
    _time += dt;
    // Update the robot
    [_robot update:dt];
    
    // Update the crawlers
    for (Crawler *crawler in _crawlers)
    {
        [crawler update:dt];
    }
}


#pragma mark - GameDelegate protocol methods

- (CGFloat)getScreenWidth
{
    return self.contentSize.width;
}

- (CGFloat)getScreenHeight
{
    return self.contentSize.height;
}

- (BOOL)leftPressed
{
    return leftButton.tracking;
}

- (BOOL)rightPressed
{
    return rightButton.tracking;
}

- (BOOL)leftRightNotPressed
{
    return !(leftButton.tracking || rightButton.tracking);
}

- (BOOL)jumpPressed
{
    return jumpButton1.tracking || jumpButton2.tracking;
}

- (CCTime)getTimeElapsed
{
    return _time;
}

@end
