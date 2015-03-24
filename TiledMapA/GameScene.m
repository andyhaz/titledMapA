//
//  GameScene.m
//  TiledMapA
//
//  Created by andrew hazlett on 3/24/15.
//  Copyright (c) 2015 andrew hazlett. All rights reserved.
//

#import "GameScene.h"
#import "JSTileMap.h"
#import "game_utils.h"
#import "levelMap.h"

@implementation GameScene {
    SKSpriteNode *sprite,*circleTraget;
    levelMap *mapLevelNode;
}

typedef enum : uint8_t {
    playerCategory     = 1,
    wallCategory       = 2,
    circleCategory     = 3,
} APAColliderType;

-(void)didMoveToView:(SKView *)view {
    NSLog(@"screen size:%f %f",self.frame.size.width,self.frame.size.height);
    /* Setup your scene here */
    self.physicsWorld.gravity = CGVectorMake(0,0);
    self.physicsWorld.contactDelegate = self;
   //load map
  /*   JSTileMap *tileMap = [JSTileMap mapNamed:@"map1.tmx"];
    [self addChild:tileMap];
    tileMap.xScale = 1.0;
    tileMap.yScale = 1,0;*/
    mapLevelNode = [[levelMap alloc]init];
    [mapLevelNode loadMap:@"map1.tmx"];
    mapLevelNode.name = @"levelMap";
    mapLevelNode.xScale = 1.0;
    mapLevelNode.yScale = 1.0;
   [self addChild:mapLevelNode];
    
    //add target
    circleTraget = [SKSpriteNode spriteNodeWithImageNamed:@"cirImage.png"];
    circleTraget.xScale = 0.5;
    circleTraget.yScale = 0.5;
    circleTraget.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
    [self addChild:circleTraget];
    
    sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    
    sprite.xScale = 0.2;
    sprite.yScale = 0.2;
    sprite.position = CGPointMake(CGRectGetMidX(self.frame),
                                  CGRectGetMidY(self.frame));
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.frame.size.width / 3.0f];
    sprite.physicsBody.dynamic = YES;
    sprite.physicsBody.categoryBitMask = playerCategory;
    sprite.physicsBody.contactTestBitMask = wallCategory | circleCategory;
    
    [self addChild:sprite];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        circleTraget.position = location;
        [sprite runAction:[self rotImage]];
        [sprite runAction:[self moveAction:location.x :location.y :@"target" :0.0020]];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(SKAction*)rotImage{
    game_utils *gu  = [[game_utils alloc]init];
    CGPoint p1 = CGPointMake(sprite.position.x,sprite.position.y);
    CGPoint p2 = CGPointMake(circleTraget.position.x,circleTraget.position.y);
    
    float angle = [gu pointPairToBearingDegrees:p1 secondPoint:p2];
    SKAction *rotPuffer = [SKAction rotateToAngle:-angle duration:0.2];
    return rotPuffer;
}//end rotimage

-(SKAction*)moveAction :(float)x :(float)y :(NSString*)sprintName :(float)speed{
    //the node you want to move
    SKNode *node = [self childNodeWithName:sprintName];
    //   NSLog(@"moveAction:%@",node);
    
    //get the distance between the destination position and the node's position
    double distance = sqrt(pow((x - node.position.x), 2.0) + pow((y - node.position.y), 2.0));
    
    //calculate your new duration based on the distance
    float moveDuration = speed*distance;
    
    //move the node
    SKAction *move = [SKAction moveTo:CGPointMake(x,y) duration: moveDuration];
    
    return move;
}//end move action
//
- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    //  NSString *bodyStr = contact.bodyB.node.name;
    //  NSString *bodyStrA = contact.bodyA.node.name;
    // NSLog(@" bodyStr:%@ boodStrA:%@",bodyStr,bodyStrA);
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    //walls
    if (firstBody.categoryBitMask == playerCategory  && secondBody.categoryBitMask == wallCategory) {
        //NSLog(@"wall ");
        [sprite removeAllActions];
    }
    
    if (firstBody.categoryBitMask == playerCategory  && secondBody.categoryBitMask == circleCategory) {
        // NSLog(@"target bodyStr:%@ boodStrA:%@",bodyStr,bodyStrA);
        //  [tileMap removeAllActions];
      //  circleTraget.alpha = 0.0;
    }
}
@end
