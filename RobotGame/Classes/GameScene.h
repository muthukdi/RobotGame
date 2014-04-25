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

@interface GameScene : CCScene <RobotDelegate>
{
    Robot *_robot;
    CCButton *leftButton, *rightButton;
}

+ (GameScene *)scene;

- (id)init;
- (CGFloat)getScreenWidth;
- (CGFloat)getScreenHeight;

@end