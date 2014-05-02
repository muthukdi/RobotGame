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
@synthesize velocityY = _velocityY;
@synthesize position = _position;
@synthesize width = _width;
@synthesize height = _height;
@synthesize collider = _collider;

- (id)initWithPosition:(CGPoint)position view:(id)scene
{
    self = [super init];
    if (!self) return(nil);
    
    _view = scene;
    _jumpEnabled = YES;
    _renderableIdle = [[Renderable alloc] initWithImageFile:@"robot_idle.png"
                                                   duration:1.0f
                                              numberOfCells:8];
    _renderableRun = [[Renderable alloc] initWithImageFile:@"robot_run.png"
                                                  duration:0.5f
                                             numberOfCells:6];
    _renderableJump = [[Renderable alloc] initWithImageFile:@"robot_jump.png"
                                                  duration:1.0f
                                             numberOfCells:8];
    // Initialize collider
    _collider = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"yellow.png"]
                                       rect:CGRectMake(0.0f, 0.0f, 90.0f, 150.0f)];
    _collider.opacity = 0.3f;
    _collider.visible = NO;
    [_view addChild:_collider];
    // Add the sprites to the game scene
    [_view addChild:_renderableIdle.sprite];
    [_view addChild:_renderableJump.sprite];
    [_view addChild:_renderableRun.sprite];
    
    // Configure the initial state
    _state = ROBOT_IDLE;
    _renderable = _renderableIdle;
    _width = _renderable.sprite.boundingBox.size.width;
    _height = _renderable.sprite.boundingBox.size.height;
    _position = position;
    _renderableIdle.sprite.position = position;
    _collider.position = ccp(position.x, position.y - 0.35*_collider.boundingBox.size.height);
    _renderableRun.sprite.visible = NO;
    _renderableJump.sprite.visible = NO;
    _velocityY = 1200.0f;
    
    return self;
}

- (void)setRenderable:(Renderable *)renderable
{
    // Update the new renderable's sprite
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

- (void)setPosition:(CGPoint)position
{
    _position = position;
    _renderable.sprite.position = position;
    _collider.position = ccp(position.x, position.y - 0.35*_collider.boundingBox.size.height);
}


// Return the position of the collider (for external use only)
- (CGPoint)position
{
    return _collider.position;
}

// Return the width of the collider (for external use only)
- (CGFloat)width
{
    return _collider.boundingBox.size.width;
}

// Return the height of the collider (for external use only)
- (CGFloat)height
{
    return _collider.boundingBox.size.height;
}

- (void)bounce:(float)velocity
{
    _velocityY = velocity;
    self.state = ROBOT_JUMP;
    [[OALSimpleAudio sharedInstance] playEffect:@"stomp_sound.wav"];
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
                self.position = ccp(_position.x - (dt * runningSpeed), _position.y);
            }
            if ([_view rightPressed])
            {
                self.direction = NO;
                self.position = ccp(_position.x + (dt * runningSpeed), _position.y);
            }
            // Collisions with the edge of the screen
            if (_position.x < _width/2)
            {
                self.position =  ccp(_width/2, _position.y);
            }
            if (_position.x > [_view getScreenWidth] - _width/2)
            {
                self.position =  ccp([_view getScreenWidth] - _width/2, _position.y);
            }
            break;
        }
        case ROBOT_JUMP:
        {
            _velocityY -= GRAVITY * dt;
            self.position = ccp(_position.x, _position.y + (dt * _velocityY));
            if (_position.y < 128.0f)
            {
                self.position = ccp(_position.x, 128.0f);
                self.state = ROBOT_IDLE;
                _velocityY = 1200.0f;
                break;
            }
            // Determine direction of motion
            if ([_view leftPressed])
            {
                self.direction = YES;
                self.position = ccp(_position.x - (dt * runningSpeed), _position.y);
            }
            if ([_view rightPressed])
            {
                self.direction = NO;
                self.position = ccp(_position.x + (dt * runningSpeed), _position.y);
            }
            // Collisions with the edge of the screen
            if (_position.x < _width/2)
            {
                self.position =  ccp(_width/2, _position.y);
            }
            if (_position.x > [_view getScreenWidth] - _width/2)
            {
                self.position =  ccp([_view getScreenWidth] - _width/2, _position.y);
            }
            break;
        }
        default:
            // Shouldn't happen
            break;
    }
    [_renderable animate:dt];
}

- (void)dealloc
{
    // Need to remove these explicitly since the scene still
    // has a reference to them
    [_view removeChild:_renderableIdle.sprite cleanup:YES];
    [_view removeChild:_renderableRun.sprite cleanup:YES];
    [_view removeChild:_renderableJump.sprite cleanup:YES];
    [_view removeChild:_collider cleanup:YES];
}

@end
