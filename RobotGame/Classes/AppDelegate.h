//
//  AppDelegate.h
//  RobotGame
//
//  Created by Dilip Muthukrishnan on 2014-04-21.
//  Copyright Dilip Muthukrishnan 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "cocos2d.h"

@class Crawler;

@protocol GameDelegate

- (void)addChild:(CCNode*)child;
- (CGFloat)screenWidth;
- (CGFloat)screenHeight;
- (BOOL)leftPressed;
- (BOOL)rightPressed;
- (BOOL)leftRightNotPressed;
- (BOOL)jumpPressed;
- (CCTime)getTimeElapsed;
- (void)removeChild:(CCNode *)child cleanup:(BOOL)cleanup;
- (BOOL)doesTileExistUnderCrawler:(Crawler *)crawler;
- (void)addChild:(CCNode*) child z:(NSInteger)z;

@end

BOOL iPhone;

@interface AppDelegate : CCAppDelegate

@end
