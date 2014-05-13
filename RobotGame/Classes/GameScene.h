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

// Easy trick to distinguish between iPhones and iPads
#define iPhone _screenWidth < 600.0f

@interface GameScene : CCScene <GameDelegate>
{
    Robot *_robot;
    CCButton *leftButton, *rightButton, *jumpButton1, *jumpButton2, *collisionButton, *crawlerButton;
    NSMutableArray *_crawlers;
    CCTime _time;  // time (in seconds) since the game started
}

@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

+ (GameScene *)scene;

- (id)init;
- (void)addButtons;
- (void)addTiles;
- (void)toggleCollisionRectangles:(id)sender;
- (void)createCrawler:(id)sender;

@end