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
    _velocityY = 1200.0f;
    _jumpEnabled = YES;
    _renderableIdle = [[Renderable alloc] initWithImageFile:@"robot_idle.png"
                                                   duration:1.0f
                                              numberOfCells:8];
    [_view addChild:_renderableIdle.sprite];
    _renderableRun = [[Renderable alloc] initWithImageFile:@"robot_run.png"
                                                  duration:0.5f
                                             numberOfCells:6];
    _renderableJump = [[Renderable alloc] initWithImageFile:@"robot_jump.png"
                                                  duration:1.0f
                                             numberOfCells:8];
    [_view addChild:_renderableJump.sprite];
    [_view addChild:_renderableRun.sprite];
    _renderableIdle.sprite.position = position;
    _renderableRun.sprite.visible = NO;
    _renderable = _renderableIdle;
    _width = _renderable.sprite.boundingBox.size.width;
    
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
        case ROBOT_JUMP:
        {
            [_renderableJump rewind];
            self.renderable = _renderableJump;
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
    _renderableJump.sprite.flipX = direction;
}

- (void)update:(CCTime)dt
{
    float runningSpeed = 500;
    switch (_state)
    {
        case ROBOT_IDLE:
        {
            if ([_view leftPressed] || [_view rightPressed])
            {
                self.state = ROBOT_RUN;
                if ([_view leftPressed])
                {
                    self.direction = YES;
                }
                if ([_view rightPressed])
                {
                    self.direction = NO;
                }
            }
            // Don't allow repeated jumps (disable it until
            // the button is released)
            if ([_view jumpPressed] && _jumpEnabled)
            {
                self.state = ROBOT_JUMP;
                [[OALSimpleAudio sharedInstance] playEffect:@"jump_sound.wav"];
                _jumpEnabled = NO;
            }
            else if (![_view jumpPressed])
            {
                _jumpEnabled = YES;
            }
            break;
        }
        case ROBOT_RUN:
        {
            CGFloat x = _renderable.sprite.position.x;
            CGFloat y = _renderable.sprite.position.y;
            if ([_view leftRightNotPressed])
            {
                self.state = ROBOT_IDLE;
                break;
            }
            // Don't allow repeated jumps (disable it until
            // the button is released)
            if ([_view jumpPressed] && _jumpEnabled)
            {
                self.state = ROBOT_JUMP;
                [[OALSimpleAudio sharedInstance] playEffect:@"jump_sound.wav"];
                _jumpEnabled = NO;
                break;
            }
            else if (![_view jumpPressed])
            {
                _jumpEnabled = YES;
            }
            // Determine direction of motion
            if ([_view leftPressed])
            {
                self.direction = YES;
                _renderable.sprite.position = ccp(x - (dt * runningSpeed), y);
                x = _renderable.sprite.position.x;
            }
            if ([_view rightPressed])
            {
                self.direction = NO;
                _renderable.sprite.position = ccp(x + (dt * runningSpeed), y);
                x = _renderable.sprite.position.x;
            }
            // Collisions with the edge of the screen
            if (x < _width/2)
            {
                _renderable.sprite.position =  ccp(_width/2, y);
                x = _renderable.sprite.position.x;
            }
            if (x > [_view getScreenWidth] - _width/2)
            {
                _renderable.sprite.position =  ccp([_view getScreenWidth] - _width/2, y);
                x = _renderable.sprite.position.x;
            }
            break;
        }
        case ROBOT_JUMP:
        {
            CGFloat x = _renderable.sprite.position.x;
            CGFloat y = _renderable.sprite.position.y;
            _velocityY -= GRAVITY * dt;
            _renderable.sprite.position = ccp(x, y + (dt * _velocityY));
            y = _renderable.sprite.position.y;
            if (y < 128.0f)
            {
                _renderable.sprite.position = ccp(x, 128.0f);
                self.state = ROBOT_IDLE;
                _velocityY = 1200.0f;
                break;
            }
            // Determine direction of motion
            if ([_view leftPressed])
            {
                self.direction = YES;
                _renderable.sprite.position = ccp(x - (dt * runningSpeed), y);
                x = _renderable.sprite.position.x;
            }
            if ([_view rightPressed])
            {
                self.direction = NO;
                _renderable.sprite.position = ccp(x + (dt * runningSpeed), y);
                x = _renderable.sprite.position.x;
            }
            // Collisions with the edge of the screen
            if (x < _width/2)
            {
                _renderable.sprite.position =  ccp(_width/2, y);
                x = _renderable.sprite.position.x;
            }
            if (x > [_view getScreenWidth] - _width/2)
            {
                _renderable.sprite.position =  ccp([_view getScreenWidth] - _width/2, y);
                x = _renderable.sprite.position.x;
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
