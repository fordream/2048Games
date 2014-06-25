//
//  M2PianoEffect.h
//  m2048
//
//  Created by LinShan Jiang on 14-6-25.
//
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <SpriteKit/SpriteKit.h>
static     int paidEffectKind = 3;

@interface M2PianoEffect : NSObject
{
    SKNode* player;
    int soundID;
    NSArray* curArr;
    BOOL isPaid;
}
@property(readonly) NSMutableArray* effectArr;
-(NSArray*)getCurEffectRandom;
-(void)playEffect;
- (void)playSound:(NSString*)soundKey;
@end
