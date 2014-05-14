//
//  AppDelegate.h
//  RobotGame
//
//  Created by Dilip Muthukrishnan on 2014-04-21.
//  Copyright Dilip Muthukrishnan 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "cocos2d.h"

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

@end

BOOL iPhone;

@interface AppDelegate : CCAppDelegate

@end
