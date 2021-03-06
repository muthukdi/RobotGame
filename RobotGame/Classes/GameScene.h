//
//  GameScene.h
//  RobotGame
//
//  Created by Dilip Muthukrishnan on 2014-04-21.
//  Copyright Dilip Muthukrishnan 2014. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "Robot.h"
#import "Crawler.h"

@interface GameScene : CCScene <GameDelegate>
{
    Robot *_robot;
    CCButton *leftButton, *rightButton, *jumpButton;
    NSMutableArray *_crawlers;
    CCTime _time;  // time (in seconds) since the game started
}

+ (GameScene *)scene;

- (id)init;

@end