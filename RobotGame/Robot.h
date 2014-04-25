//
//  Robot.h
//  RobotGame
//
//  Created by Dilip Muthukrishnan on 2014-04-23.
//  Copyright (c) 2014 Dilip Muthukrishnan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Renderable.h"

@class CCNode;

typedef enum RobotStateTypes
{
    ROBOT_IDLE, ROBOT_RUN
    
} RobotState;

@protocol RobotDelegate

- (void)addChild:(CCNode*)child;
- (CGFloat)getScreenWidth;
- (CGFloat)getScreenHeight;
- (BOOL)leftEnabled;
- (BOOL)rightEnabled;
- (BOOL)leftRightDisabled;

@end

@interface Robot : NSObject
{
    id<RobotDelegate> _view;
    Renderable *_renderableIdle;
    Renderable *_renderableRun;
}

@property (nonatomic, assign) Renderable *renderable;
@property (nonatomic, assign) RobotState state;
@property (nonatomic, assign) BOOL direction;  // YES for left and NO for right

- (id)initWithPosition:(CGPoint)position view:(id)scene;
- (void)update:(CCTime)dt;

@end
