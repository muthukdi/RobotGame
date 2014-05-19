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
    CCButton *leftButton, *rightButton, *jumpButton1, *jumpButton2, *collisionButton, *crawlerButton;
    NSMutableArray *_crawlers;
    CCTime _time;  // time (in seconds) since the game started
    int _grid[15][12];
    CCNodeColor *node;
}

@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

+ (GameScene *)scene;

- (id)init;
- (void)addButtons;
- (void)addTiles;
- (void)outputGrid;
- (void)toggleCollisionRectangles:(id)sender;
- (void)createCrawler:(id)sender;
- (BOOL)doesTileExistUnderRobot;

@end