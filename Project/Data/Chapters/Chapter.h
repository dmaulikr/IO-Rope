//
//  Chapter.h  
//

#import <Foundation/Foundation.h>

@interface Chapter : NSObject {

    // Declare variables with an underscore in front
    NSString *_name;
    NSString *_text;
    int _number;
}

// Declare variable properties without an underscore
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) int number;

// Put your custom init method interface here:
-(id)initWithName:(NSString*)name number:(int)number text:(NSString*) text;

@end
