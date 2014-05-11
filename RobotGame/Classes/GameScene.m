//
//  GameScene.m
//  RobotGame
//
//  Created by Dilip Muthukrishnan on 2014-04-21.
//  Copyright Dilip Muthukrishnan 2014. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

@synthesize screenWidth = _screenWidth;
@synthesize screenHeight = _screenHeight;

+ (GameScene *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    
    _screenWidth = self.contentSize.width;
    _screenHeight = self.contentSize.height;
    // Initialize the time
    _time = 0.0;
    // Play the background music
    [[OALSimpleAudio sharedInstance] playBg:@"music.mp3" volume:0.3f pan:0.0f loop:YES];
    CCSprite *background = [CCSprite spriteWithImageNamed:@"Layer1.png"];
    background.position = ccp(_screenWidth/2, _screenHeight/2);
    background.scale = iPhone ? 0.56f : 1.0f;
    [self addChild:background];
    // Initialize the crawlers with random configurations
    _crawlers = [NSMutableArray arrayWithCapacity:4];
    float randomX, y;
    BOOL randomDirection;
    float randomScale;
    for (int i = 0; i < 4; i++)
    {
        randomX = (float)(arc4random() % ((int)_screenWidth - 128) + 64);
        y = iPhone ? 64.0f : 128.0f;
        randomDirection = (BOOL)(arc4random() % 2);
        randomScale = (float)(arc4random() % 16 + 5)/10.0f;
        Crawler *crawler = [[Crawler alloc] initWithPosition:ccp(randomX, y)
                                                        view:self
                                                   direction:randomDirection
                                                  speedScale:randomScale];
        crawler.scale = iPhone ? 1.0f : 2.0f;
        [_crawlers addObject:crawler];
    }
    // Initialize the robot
    _robot = [[Robot alloc] initWithPosition:ccp(_screenWidth/8, y) view:self];
    _robot.scale = iPhone ? 1.0f : 2.0f;
    // Create the left and right motion controls
    leftButton = [CCButton buttonWithTitle:@""
                               spriteFrame:[CCSpriteFrame frameWithImageNamed:@"leftarrow.png"]];
    leftButton.scale = iPhone ? 1.0f : 2.0f;
    leftButton.exclusiveTouch = NO;
    leftButton.claimsUserInteraction = NO;
    leftButton.position = ccp(leftButton.boundingBox.size.width/2,
                              _screenHeight - leftButton.boundingBox.size.height/2);
    [self addChild:leftButton];
    rightButton = [CCButton buttonWithTitle:@""
                                spriteFrame:[CCSpriteFrame frameWithImageNamed:@"rightarrow.png"]];
    rightButton.scale = iPhone ? 1.0f : 2.0f;
    rightButton.exclusiveTouch = NO;
    rightButton.claimsUserInteraction = NO;
    rightButton.position = ccp(_screenWidth - rightButton.boundingBox.size.width/2,
                               _screenHeight - rightButton.boundingBox.size.height/2);
    [self addChild:rightButton];
    // Create the jump buttons
    jumpButton1 = [CCButton buttonWithTitle:@""
                               spriteFrame:[CCSpriteFrame frameWithImageNamed:@"jump.png"]];
    jumpButton1.scale = iPhone ? 1.0f : 2.0f;
    jumpButton1.exclusiveTouch = NO;
    jumpButton1.claimsUserInteraction = NO;
    jumpButton1.position = ccp(jumpButton1.boundingBox.size.width/2,
                              _screenHeight - 3*jumpButton1.boundingBox.size.height/2);
    [self addChild:jumpButton1];
    jumpButton2 = [CCButton buttonWithTitle:@""
                                spriteFrame:[CCSpriteFrame frameWithImageNamed:@"jump.png"]];
    jumpButton2.scale = iPhone ? 1.0f : 2.0f;
    jumpButton2.exclusiveTouch = NO;
    jumpButton2.claimsUserInteraction = NO;
    jumpButton2.position = ccp(_screenWidth - jumpButton2.boundingBox.size.width/2,
                               _screenHeight - 3*jumpButton2.boundingBox.size.height/2);
    [self addChild:jumpButton2];
    collisionButton = [CCButton buttonWithTitle:@""
                                    spriteFrame:[CCSpriteFrame frameWithImageNamed:@"collision.png"]];
    collisionButton.scale = iPhone ? 1.0f : 2.0f;
    collisionButton.position =  ccp(_screenWidth/2, rightButton.position.y);
    [collisionButton setTarget:self selector:@selector(toggleCollisionRectangles:)];
    [self addChild:collisionButton];
    
    crawlerButton = [CCButton buttonWithTitle:@""
                                    spriteFrame:[CCSpriteFrame frameWithImageNamed:@"crawler.png"]];
    crawlerButton.scale = iPhone ? 1.0f : 2.0f;
    crawlerButton.position =  ccp(_screenWidth/4, rightButton.position.y);
    [crawlerButton setTarget:self selector:@selector(createCrawler:)];
    [self addChild:crawlerButton];
    
	return self;
}

- (void)update:(CCTime)dt
{
    // Increment the time elapsed
    _time += dt;
    // Update the robot
    [_robot update:dt];
    
    // Update the crawlers
    NSMutableArray *deadCrawlers = [NSMutableArray arrayWithCapacity:_crawlers.count];
    for (Crawler *crawler in _crawlers)
    {
        // Identify any crawlers that are already dead
        if (crawler.state == CRAWLER_DEAD)
        {
            [deadCrawlers addObject:crawler];
        }
        // Check if the robot has stomped on this crawler
        if (_robot.velocityY < 0.0f)
        {
            if (_robot.position.x + _robot.width/2 > crawler.position.x - crawler.width/2 &&
                _robot.position.x - _robot.width/2 < crawler.position.x + crawler.width/2 &&
                _robot.position.y - _robot.height/2 < crawler.position.y + crawler.height/2 &&
                _robot.position.y + _robot.height/2 > crawler.position.y - crawler.height/2)
            {
                // Make sure that the crawler is not already dying or dead
                if (crawler.state != CRAWLER_DYING && crawler.state != CRAWLER_DEAD)
                {
                    // Give the robot a little bounce
                    [_robot bounce:iPhone ? 300.0f : 600.0f];
                    // Start this crawler's death animation
                    crawler.state = CRAWLER_DYING;
                }
            }
        }
        [crawler update:dt];
    }
    // Remove the dead crawlers
    [_crawlers removeObjectsInArray:deadCrawlers];
}

- (void)toggleCollisionRectangles:(id)sender
{
    _robot.collider.visible = _robot.collider.visible ? NO : YES;
    for (Crawler *crawler in _crawlers)
    {
        crawler.collider.visible = crawler.collider.visible ? NO : YES;
    }
}

- (void)createCrawler:(id)sender
{
    float randomX = (float)(arc4random() % ((int)_screenWidth - 128) + 64);
    float y = iPhone ? 64.0f : 128.0f;
    bool randomDirection = (BOOL)(arc4random() % 2);
    float randomScale = (float)(arc4random() % 16 + 5)/10.0f;
    Crawler *crawler = [[Crawler alloc] initWithPosition:ccp(randomX, y)
                                                    view:self
                                               direction:randomDirection
                                              speedScale:randomScale];
    crawler.scale = iPhone ? 1.0f : 2.0f;
    crawler.collider.visible = _robot.collider.visible;
    [_crawlers addObject:crawler];
}


#pragma mark - GameDelegate protocol methods

- (BOOL)leftPressed
{
    return leftButton.tracking;
}

- (BOOL)rightPressed
{
    return rightButton.tracking;
}

- (BOOL)leftRightNotPressed
{
    return !(leftButton.tracking || rightButton.tracking);
}

- (BOOL)jumpPressed
{
    return jumpButton1.tracking || jumpButton2.tracking;
}

- (CCTime)getTimeElapsed
{
    return _time;
}

@end
