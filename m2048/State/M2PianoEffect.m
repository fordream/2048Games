//
//  M2PianoEffect.m
//  m2048
//
//  Created by LinShan Jiang on 14-6-25.
//
//

#import "M2PianoEffect.h"


@implementation M2PianoEffect
@synthesize effectArr;

-(id)init{
    player = [[SKNode alloc] init];
    soundID = 0;
    curArr = NULL;
    isPaid = false;
    
    NSString *path = [NSString stringWithFormat:@"%@/Effect.txt",[[NSBundle mainBundle] resourcePath]];
    NSError *error = [[NSError alloc]init];
    NSString *file = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
//    NSLog(@"error:%@",[error description]);
    NSArray* b = [file componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    effectArr = [[NSMutableArray alloc] init];
    for (int i =0; i < [b count]; i++) {
        NSString* c = [b objectAtIndex:i];
        NSArray* d = [c componentsSeparatedByString:@","];
        [effectArr addObject:d];
    }

//    for ( int i =0; i < [effectArr count]; i++ ){
//        NSArray* d =(NSArray*)[effectArr objectAtIndex:i];
//        for (int j = 0; j < [d count]; j++) {
//            NSLog(@"i:%d,j:%d,int:%d",i,j,[[d objectAtIndex:j] intValue]);
//        }
//    }
    curArr = [self getCurEffectRandom];
    return [super init];
}

-(NSArray*)getCurEffectRandom{
    NSArray* pRet = NULL;
    int count = (int)[effectArr count];
    if (count > 0) {
        int index = 0;
        if (!isPaid) {
            index = arc4random()%(MIN(paidEffectKind, count));
        }else{
            index = arc4random()%count;
        }
        
        pRet = (NSArray*)[effectArr objectAtIndex:(arc4random()%count)];
    }
    
    return pRet;
}

-(void)playEffect{
    [self playSound:[NSString stringWithFormat:@"/sound%d.mp3",[[curArr objectAtIndex:soundID] intValue]]];
    
    if (soundID < [curArr count] - 1) {
        soundID++;
    }else{
        curArr = [self getCurEffectRandom];
        soundID = 0;
    }
}

-(void)playSound:(NSString*)soundKey{
	
	NSString *path = [NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle] resourcePath],soundKey];
	
//	NSLog(@"%@\n", path);
	
	SystemSoundID SoundID;
	
	NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
	
	AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(filePath), &SoundID);
	
	AudioServicesPlaySystemSound(SoundID);
	
}

@end
