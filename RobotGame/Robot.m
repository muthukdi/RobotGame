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
@synthesize direction = _direction;

- (id)initWithPosition:(CGPoint)position view:(id)scene
{
    self = [super init];
    if (!self) return(nil);
    
    _view = scene;
    _state = ROBOT_IDLE;
    _renderableIdle = [[Renderable alloc] initWithImageFile:@"robot_idle.png"
                                                   duration:1.0f
                                              numberOfCells:8];
    [_view addChild:_renderableIdle.sprite];
    _renderableRun = [[Renderable alloc] initWithImageFile:@"robot_run.png"
                                                  duration:0.5f
                                             numberOfCells:6];
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

- (void)setDirection:(BOOL)direction
{
    _direction = direction;
    _renderableIdle.sprite.flipX = direction;
    _renderableRun.sprite.flipX = direction;
}

- (void)update:(CCTime)dt
{
    float runningSpeed = 500;
    switch (_state)
    {
        case ROBOT_IDLE:
        {
            if ([_view leftEnabled] || [_view rightEnabled])
            {
                self.state = ROBOT_RUN;
                if ([_view leftEnabled])
                {
                    self.direction = YES;
                }
                if ([_view rightEnabled])
                {
                    self.direction = NO;
                }
            }
            break;
        }
        case ROBOT_RUN:
        {
            if ([_view leftRightDisabled])
            {
                self.state = ROBOT_IDLE;
                break;
            }
            CGFloat x = _renderable.sprite.position.x;
            CGFloat y = _renderable.sprite.position.y;
            CGFloat width = _renderable.sprite.boundingBox.size.width;
            // Determine direction of motion
            if ([_view leftEnabled])
            {
                self.direction = YES;
                _renderable.sprite.position = ccp(x - (dt * runningSpeed), y);
                x = _renderable.sprite.position.x;
            }
            if ([_view rightEnabled])
            {
                self.direction = NO;
                _renderable.sprite.position = ccp(x + (dt * runningSpeed), y);
                x = _renderable.sprite.position.x;
            }
            // Collisions with the edge of the screen
            if (_renderable.sprite.position.x < width/2)
            {
                _renderable.sprite.position =  ccp(width/2, y);
            }
            if (_renderable.sprite.position.x > [_view getScreenWidth] - width/2)
            {
                _renderable.sprite.position =  ccp([_view getScreenWidth] - width/2, y);
            }
            break;
        }
        default:
            // Shouldn't happen
            break;
    }
    [_renderable animate:dt];
}

@end
