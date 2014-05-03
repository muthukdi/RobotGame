//
//  Crawler.m
//  RobotGame
//
//  Created by Dilip Muthukrishnan on 2014-04-26.
//  Copyright (c) 2014 Dilip Muthukrishnan. All rights reserved.
//

#import "Crawler.h"

@implementation Crawler

@synthesize renderable = _renderable;
@synthesize state = _state;
@synthesize direction = _direction;
@synthesize position = _position;
@synthesize width = _width;
@synthesize height = _height;
@synthesize collider = _collider;

- (id)initWithPosition:(CGPoint)position view:(id)scene direction:(BOOL)direction speedScale:(float)speedScale
{
    self = [super init];
    if (!self) return(nil);
    
    _view = scene;
    _renderableIdle = [[Renderable alloc] initWithImageFile:@"crawler_idle.png"
                                                   duration:0.5f
                                              numberOfCells:8];
    _renderableWalk = [[Renderable alloc] initWithImageFile:@"crawler_walk.png"
                                                  duration:0.5f
                                             numberOfCells:8];
    _renderableDie = [[Renderable alloc] initWithImageFile:@"crawler_die.png"
                                                   duration:0.7f
                                              numberOfCells:8];
    // Initialize collider
    _collider = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"yellow.png"]
                                       rect:CGRectMake(0.0f, 0.0f, 70.0f, 70.0f)];
    _collider.opacity = 0.3f;
    _collider.visible = NO;
    [_view addChild:_collider];
    // Add the sprites to the game scene
    [_view addChild:_renderableIdle.sprite];
    [_view addChild:_renderableWalk.sprite];
    [_view addChild:_renderableDie.sprite];
    
    // Configure the initial state (either idle or walking)
    if ((BOOL)(arc4random() % 2))
    {
        _state = CRAWLER_WALK;
        _renderableIdle.sprite.visible = NO;
        _renderableDie.sprite.visible = NO;
        _renderable = _renderableWalk;
    }
    else
    {
        _state = CRAWLER_IDLE;
        _renderableWalk.sprite.visible = NO;
        _renderableDie.sprite.visible = NO;
        _renderable = _renderableIdle;
    }
    _direction = direction;
    _renderableIdle.sprite.flipX = !direction;
    _renderableWalk.sprite.flipX = !direction;
    _renderableDie.sprite.flipX = !direction;
    _walkingSpeedScale = speedScale;
    _width = _renderable.sprite.boundingBox.size.width;
    _height = _renderable.sprite.boundingBox.size.height;
    _position = position;
    _renderable.sprite.position = position;
    _collider.position = ccp(position.x, position.y - 1.33*_collider.boundingBox.size.height);
    _timeToDeath = _renderableDie.duration;
    
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

- (void)setState:(CrawlerState)newState
{
	if (newState == _state)
    {
		return;
	}
	switch (newState)
    {
        case CRAWLER_IDLE:
        {
            [_renderableIdle rewind];
            self.renderable = _renderableIdle;
            int numCycles = arc4random() % 4 + 2;
            _nextThinkTime = [_view getTimeElapsed] + numCycles * _renderableIdle.duration;
            break;
        }
        case CRAWLER_WALK:
        {
            [_renderableWalk rewind];
            self.renderable = _renderableWalk;
            _walkingSpeedScale = (float)(arc4random() % 16 + 5)/10.0f;
            int numCycles = arc4random() % 6 + 5;
            _nextThinkTime = [_view getTimeElapsed] + numCycles * _renderableWalk.duration;
            break;
        }
        case CRAWLER_DYING:
        {
            [_renderableDie rewind];
            self.renderable = _renderableDie;
            break;
        }
        case CRAWLER_DEAD:
        {
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
    _renderableIdle.sprite.flipX = !direction;
    _renderableWalk.sprite.flipX = !direction;
    _renderableDie.sprite.flipX = !direction;
}

- (void)setPosition:(CGPoint)position
{
    _position = position;
    _renderable.sprite.position = position;
    _collider.position = ccp(position.x, position.y - 1.33*_collider.boundingBox.size.height);
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

- (void)update:(CCTime)dt
{
    switch (_state)
    {
        case CRAWLER_IDLE:
        {
            if ([_view getTimeElapsed] >= _nextThinkTime)
            {
                self.state = CRAWLER_WALK;
            }
            else
            {
                [_renderable animate:dt];
            }
            break;
        }
        case CRAWLER_WALK:
        {
            if ([_view getTimeElapsed] >= _nextThinkTime)
            {
                self.state = CRAWLER_IDLE;
            }
            else
            {
                // Move in the current direction
                if (self.direction)
                {
                    self.position = ccp(_position.x - (dt * _walkingSpeedScale * WALKING_SPEED), _position.y);
                }
                else
                {
                    self.position = ccp(_position.x + (dt * _walkingSpeedScale * WALKING_SPEED), _position.y);
                }
                // Collisions with the edge of the screen
                if (_position.x < _width/2)
                {
                    self.direction = NO;
                    self.position =  ccp(_width/2, _position.y);
                }
                if (_position.x > [_view getScreenWidth] - _width/2)
                {
                    self.direction = YES;
                    self.position =  ccp([_view getScreenWidth] - _width/2, _position.y);
                }
                [_renderable animate:dt * _walkingSpeedScale];
            }
            break;
        }
        case CRAWLER_DYING:
        {
            [_renderable animate:dt];
            _timeToDeath -= dt;
            // I should be adding a "loopable" property to the
            // renderable instead of having to hardcode this (0.2f)
            if (_timeToDeath <= 0.2f)
            {
                self.state = CRAWLER_DEAD;
            }
            break;
        }
        default:
            // Shouldn't happen
            break;
    }
}

- (void)dealloc
{
    // Need to remove these explicitly since the scene still
    // has a reference to them
    [_view removeChild:_renderableIdle.sprite cleanup:YES];
    [_view removeChild:_renderableWalk.sprite cleanup:YES];
    [_view removeChild:_renderableDie.sprite cleanup:YES];
    [_view removeChild:_collider cleanup:YES];
}

@end
