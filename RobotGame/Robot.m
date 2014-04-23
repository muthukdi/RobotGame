//
//  Robot.m
//  RobotGame
//
//  Created by Dilip Muthukrishnan on 2014-04-23.
//  Copyright (c) 2014 Dilip Muthukrishnan. All rights reserved.
//

#import "Robot.h"

@implementation Robot

@synthesize renderable = _renderable;
@synthesize state = _state;

- (id)initWithPosition:(CGPoint)position view:(id)scene
{
    self = [super init];
    if (!self) return(nil);
    
    _view = scene;
    _state = ROBOT_IDLE;
    _renderableIdle = [[Renderable alloc] initWithImageFile:@"robot_idle.png" numberOfCells:8];
    [_view addChild:_renderableIdle.sprite];
    _renderableRun = [[Renderable alloc] initWithImageFile:@"robot_run.png" numberOfCells:6];
    [_view addChild:_renderableRun.sprite];
    _renderableIdle.sprite.position = position;
    _renderableRun.sprite.visible = NO;
    _renderable = _renderableIdle;
    
    return self;
}

- (void)setRenderable:(Renderable *)renderable
{
    // Update the new renderable's sprite position
    renderable.sprite.position = _renderable.sprite.position;
    // Make sure that only the new renderable's sprite is visible
    _renderable.sprite.visible = NO;
    renderable.sprite.visible = YES;
    // Switch the renderable
	_renderable = renderable;
}

- (void)setState:(RobotState)newState
{
	if (newState == _state)
    {
		return;
	}
	switch (newState)
    {
        case ROBOT_IDLE:
        {
            [_renderableIdle rewind];
            self.renderable = _renderableIdle;
            break;
        }
        case ROBOT_RUN:
        {
            [_renderableRun rewind];
            self.renderable = _renderableRun;
            break;
        }
        default:
            // shouldn't happen
            return;
	}
	_state = newState;
}

- (void)update:(CCTime)dt
{
    [_renderable animate:dt];
}

@end
