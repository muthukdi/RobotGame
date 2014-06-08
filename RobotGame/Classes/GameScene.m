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
    // Initialize the grid array (12 rows, 15 columns)
    for (int i = 0; i < 12; i++)
    {
        for (int j = 0; j < 15; j++)
        {
            _grid[j][i] = 0;
        }
    }
    // Play the background music
    [[OALSimpleAudio sharedInstance] playBg:@"music.mp3" volume:0.3f pan:0.0f loop:YES];
    CCSprite *background = [CCSprite spriteWithImageNamed:@"Layer1.png"];
    background.position = ccp(_screenWidth/2, _screenHeight/2);
    background.scale = iPhone ? 0.56f : 1.0f;
    [self addChild:background];
    // Initialize the crawler array
    _crawlers = [NSMutableArray arrayWithCapacity:4];
    // Load the level
    [self loadLevel];
    [self outputGrid];
    float y = iPhone ? 96.0f : 192.0f;
    // Initialize the robot
    _robot = [[Robot alloc] initWithPosition:ccp(_screenWidth/8, y) view:self];
    _robot.scale = iPhone ? 1.0f : 2.0f;
    // Bottom tile node
    feetNode = [CCNodeColor nodeWithColor:[CCColor colorWithRed:1.0f
                                                      green:0.0f
                                                       blue:0.0f]
                                width:iPhone ? 40.0f : 80.0f
                               height:iPhone ? 32.0f : 64.0f];
    //[self addChild:feetNode];
    [self doesTileExistUnderRobot];
    // Add all the buttons
    [self addButtons];
    
	return self;
}

- (void)addButtons
{
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
}

// Load a level from a layout file
- (void)loadLevel
{
    CCTexture *tex;
    CCSprite *sprite;
    // We need to distinguish between the two iPhone dimensions and the iPad
    //int width = iPhone ? (self.contentSize.width > 500.0f ? 15 : 12) : 13;
    //int height = iPhone ? 10 : 12;
    float scale = iPhone ? 1.0f : 2.0f;
    float tileWidth = iPhone ? 40.0f : 80.0f;
    float tileHeight = iPhone ? 32.0f : 64.0f;
    tex = [CCTexture textureWithFile:@"tiles.tga"];
    // Extract the content of the layout text file
    NSString *path = [[NSBundle mainBundle] pathForResource:@"0"
                                                     ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];
    NSArray *rows = [content componentsSeparatedByString:@"\n"];
    NSAssert(rows.count == 12, @"The specified layout is not valid!");
    NSString *row;
    // Crawler variables
    Crawler *crawler;
    BOOL randomDirection;
    float randomSpeedScale;
    // Initialize a dummy crawler to save its height
    crawler = [[Crawler alloc] initWithPosition:ccp(0.0f, 0.0f)
                                           view:self
                                      direction:NO
                                     speedScale:0.0f];
    crawler.scale = scale;
    float crawlerHeight = crawler.collider.boundingBox.size.height;
    for (int i = 0; i < 12; i++)
    {
        row = (NSString *)[rows objectAtIndex:11-i]; // Read the text upwards!
        NSAssert(row.length == 15, @"The specified layout is not valid!");
        for (int j = 0; j < 15; j++)
        {
            if ([row characterAtIndex:j] == '#')
            {
                sprite = [CCSprite spriteWithTexture:tex
                                                rect:CGRectMake(40.0f*(j%7), 0.0f, 40.0f, 32.0f)];
                sprite.scale = scale;
                sprite.position = ccp(tileWidth/2*(2*j+1), tileHeight/2*(2*i+1));
                [self addChild:sprite];
                _grid[j][i] = 1;
            }
            else if ([row characterAtIndex:j] == 'w')
            {
                randomDirection = (BOOL)(arc4random() % 2);
                randomSpeedScale = (float)(arc4random() % 16 + 5)/10.0f;
                // Don't forget to adjust the value here to compensate for the fact
                // that we are not modifying the collider's position directly!
                CGPoint position = ccp(tileWidth/2*(2*j+1),
                                       tileHeight/2*(2*i+1) + 1.33*crawlerHeight);
                crawler = [[Crawler alloc] initWithPosition:position
                                                       view:self
                                                  direction:randomDirection
                                                 speedScale:randomSpeedScale];
                crawler.scale = scale;
                [_crawlers addObject:crawler];
            }
        }
    }
}

// Print the grid values to the console
- (void)outputGrid
{
    for (int i = 11; i >= 0; i--)
    {
        printf("\n");
        for (int j = 0; j < 15; j++)
        {
            printf("%d  ", _grid[j][i]);
        }
    }
    printf("\n");
}

- (void)fixedUpdate:(CCTime)dt
{
    // Increment the time elapsed
    _time += dt;
    // Update the robot
    if (_robot.state != ROBOT_IDLE)
    {
        // Check if there is a tile under its feet
        BOOL tileExists = [self doesTileExistUnderRobot];
        // If the robot is falling and there's a tile
        if (_robot.velocityY < 0.0f && tileExists)
        {
            // Break its fall
            _robot.state = ROBOT_IDLE;
        }
        // If the robot is running and there's no tile
        if (_robot.state == ROBOT_RUN && !tileExists)
        {
            // It must start falling
            _robot.state = ROBOT_FALL;
        }
    }
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
        if (crawler.state != ROBOT_IDLE)
        {
            // If there is no tile under the crawler, flip its direction
            BOOL tileExists = [self doesTileExistUnderCrawler:crawler];
            if (!tileExists)
            {
                crawler.direction = !crawler.direction;
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

// Spawn a crawler when the button is pressed
- (void)createCrawler:(id)sender
{
    float randomX = (float)(arc4random() % ((int)_screenWidth - 128) + 64);
    float y = iPhone ? 96.0f : 192.0f;
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

- (BOOL)doesTileExistUnderRobot
{
    // A position on the tile/space (not necessarily the center) that's
    // within a few pixels under the robot's feet
    CGFloat tileX = _robot.position.x;
    CGFloat tileY = _robot.position.y - _robot.height/2 - (iPhone ? 6.0f : 12.0f);
    // Now check this position against the grid array
    int j = (int)tileX / (iPhone ? 40 : 80);
    int i = (int)tileY / (iPhone ? 32 : 64);
    // Set the actual position (bottom-left for nodes!) of the bottom tile node
    feetNode.position = ccp(j * (iPhone ? 40.0f : 80.0f), i * (iPhone ? 32.0f : 64.0f));
    BOOL tileExists;
    // Don't access the array out of its bounds!
    tileExists = (i < 12 && j < 15) ? _grid[j][i] : NO;
    // Before the robot's fall is broken, correct its y position and
    // don't forget to adjust the value here to compensate for the fact
    // that we are not modifying the collider's position directly!
    if (_robot.velocityY < 0.0f && tileExists)
    {
        CGFloat y = (i + 1) * (iPhone ? 32.0f : 64.0f) + _robot.height/2 + 0.35*_robot.collider.boundingBox.size.height;
        _robot.position = ccp(_robot.position.x, y);
    }
    return tileExists;
}

- (BOOL)doesTileExistUnderCrawler:(Crawler *)crawler
{
    // A position on the tile/space (not necessarily the center) that's
    // within a few pixels under the crawler
    CGFloat tileX = crawler.position.x;
    CGFloat tileY = crawler.position.y - crawler.height/2 - (iPhone ? 6.0f : 12.0f);
    // Now check this position against the grid array
    int j = (int)tileX / (iPhone ? 40 : 80);
    int i = (int)tileY / (iPhone ? 32 : 64);
    // Don't access the array out of its bounds!
    return (i < 12 && j < 15) ? _grid[j][i] : NO;
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
