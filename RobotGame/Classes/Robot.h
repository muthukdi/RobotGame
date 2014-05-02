//
//  Robot.h
//  RobotGame
//
//  Created by Dilip Muthukrishnan on 2014-04-23.
//  Copyright (c) 2014 Dilip Muthukrishnan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Renderable.h"
#import "AppDelegate.h"

#define GRAVITY 3000.0f

typedef enum RobotStateTypes
{
    ROBOT_IDLE, ROBOT_RUN, ROBOT_JUMP
    
} RobotState;

@interface Robot : NSObject
{
    id<GameDelegate> _view;        // the scene that owns this robot
    Renderable *_renderableIdle;
    Renderable *_renderableRun;
    Renderable *_renderableJump;
    BOOL _jumpEnabled;              // a flag to prevent repeated jumps
}

@property (nonatomic, strong) Renderable *renderable;
@property (nonatomic, assign) RobotState state;
@property (nonatomic, assign) BOOL direction;  // YES for left and NO for right
@property (nonatomic, assign) float velocityY;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) CCSprite *collider;

- (id)initWithPosition:(CGPoint)position view:(id)scene;
- (void)bounce:(float)velocity;
- (void)update:(CCTime)dt;

@end
