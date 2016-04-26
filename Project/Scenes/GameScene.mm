//
//  GameScene.m
//  

#import "GameScene.h" 
#import "GameData.h"
#import "GameDataParser.h"
#import "LevelParser.h"
#import "Level.h"
#import "GameBackgroundLayer.h"
#import "GamePlayLayer.h"
#import "GameInterfaceLayer.h"


@implementation GameScene  
@synthesize iPad, device;

- (void)onBack: (id) sender {
    /* 
     This is where you choose where clicking 'back' sends you.
     */
    [SceneManager goLevelSelect];
}

- (void)addBackButton {
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    NSString *normal = [NSString stringWithFormat:@"Arrow-Normal-%@.png", self.device];
    NSString *selected = [NSString stringWithFormat:@"Arrow-Selected-%@.png", self.device];        
    CCMenuItemImage *goBack = [CCMenuItemImage itemWithNormalImage:normal
                                                     selectedImage:selected
                                                            target:self 
                                                          selector:@selector(onBack:)];
    CCMenu *back = [CCMenu menuWithItems: goBack, nil];
    
    if (self.iPad) {
        back.position = ccp(64, s.height - 64);
        
    }
    else {
        back.position = ccp(32, s.height - 32);
    }
    
    [self addChild:back];        
}

- (id)init {
    
    if( (self=[super init])) {

        // Determine Device
        self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        if (self.iPad) {
            self.device = @"iPad";
        }
        else {
            self.device = @"iPhone";
        }
        
        // Determine Screen Size
        //CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        // Add background to this scene
        GameBackgroundLayer *gameBackgroundLayer = [GameBackgroundLayer node];
        [self addChild:gameBackgroundLayer z:-10];
        
        GameInterfaceLayer* gameInterfaceLayer = [GameInterfaceLayer node];
        [self addChild:gameInterfaceLayer];
        
        // Add the gameplay layer to this scene
        
        // Calculate Large Font Size
        //int largeFont = screenSize.height / kFontScaleLarge;
        
        GameData *gameData = [GameDataParser loadData];
        
        int selectedChapter = gameData.selectedChapter;
        int selectedLevel = gameData.selectedLevel;
        
        NSMutableArray *levels = [LevelParser loadLevelsForChapter:selectedChapter];
        
        for (Level *level in levels) {
            if (level.number == selectedLevel) {
                
               // NSString *data = [NSString stringWithFormat:@"%@",level.data];
                
                /*CCLabelTTF *label = [CCLabelTTF labelWithString:data
                                                       fontName:@"Marker Felt" 
                                                       fontSize:largeFont]; */
               // label.position = ccp( screenSize.width/2, screenSize.height/2);
                
                // Add label to this scene
                //[self addChild:label z:0];
            }
        }
        
        GamePlayLayer *gamePlayLayer = [GamePlayLayer node];
        [self addChild:gamePlayLayer z:-9];

        //  Put a 'back' button in the scene
        [self addBackButton];   

    }
    return self;
}

@end
