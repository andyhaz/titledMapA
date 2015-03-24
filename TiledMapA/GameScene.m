//
//  GameScene.m
//  TiledMapA
//
//  Created by andrew hazlett on 3/24/15.
//  Copyright (c) 2015 andrew hazlett. All rights reserved.
//

#import "GameScene.h"
#import "JSTileMap.h"

//#import "game_utils.h"
//#import "levelMap.h"

@implementation GameScene {
    SKSpriteNode *map;
}

-(void)didMoveToView:(SKView *)view {
    NSLog(@"screen size:%f %f",self.frame.size.width,self.frame.size.height);
    /* Setup your scene here */
    
   //load map
     JSTileMap *tileMap = [JSTileMap mapNamed:@"map1.tmx"];
    [self addChild:tileMap];
    
    
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"Hello, World!";
    myLabel.fontSize = 65;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    [self addChild:myLabel];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.xScale = 0.5;
        sprite.yScale = 0.5;
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
