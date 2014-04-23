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
    
    texture = [CCTexture textureWithFile:@"robot_idle.png"];
    CCNodeColor *node = [CCNodeColor nodeWithColor:[CCColor colorWithUIColor:[UIColor redColor]]
                                             width:texture.contentSize.width/8
                                            height:texture.contentSize.height];
    node.scale = 2.0;
    node.position = ccp(self.contentSize.width/2, node.boundingBox.size.height/2);
    [self addChild:node];
    robotIdle = [CCSprite spriteWithTexture:texture
                                       rect:CGRectMake(0, 0, texture.contentSize.width/8, texture.contentSize.height)];
    robotIdle.scale = 2.0;
    robotIdle.position = ccp(self.contentSize.width/2, robotIdle.boundingBox.size.height/2);
    [self addChild:robotIdle];
    frameIndex = 0;
    [self schedule:@selector(tick:) interval:0.1];
    
	return self;
}

- (void)tick:(CCTime)dt
{
    [robotIdle setTextureRect:CGRectMake(frameIndex*texture.contentSize.width/8, 0,
                                         texture.contentSize.width/8, texture.contentSize.height)];
    if (frameIndex < 7)
    {
        frameIndex++;
    }
    else
    {
        frameIndex = 0;
    }
}

@end
