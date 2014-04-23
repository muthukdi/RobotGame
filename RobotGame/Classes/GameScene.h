//
//  GameScene.h
//  RobotGame
//
//  Created by Dilip Muthukrishnan on 2014-04-21.
//  Copyright Dilip Muthukrishnan 2014. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface GameScene : CCScene
{
    CCSprite *robotIdle;
    CCTexture *texture;
    int frameIndex;
}

+ (GameScene *)scene;
- (id)init;


@end