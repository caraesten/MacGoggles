//
//  BarView.m
//  MacGoggles
//
//  Created by Esten C Hurtle on 4/26/12.
//

#import "BarView.h"

@implementation BarView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        backgroundColor = [NSColor blueColor];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [backgroundColor setFill];
    NSRectFill(dirtyRect);
}
- (void)setAlcoholForBackground:(int)alcoholLevel
{
    // Set the color based on drunk-ness
    if (alcoholLevel < 400){ 
        backgroundColor = [NSColor colorWithDeviceRed: 0 green: 1 blue: 0 alpha:1];
    }
    else if (alcoholLevel >= 400 && alcoholLevel < 600){
        backgroundColor = [NSColor colorWithDeviceRed: 1 green: 1 blue: 0 alpha:1];
    }
    else {
        backgroundColor = [NSColor colorWithDeviceRed: 1 green: 0 blue: 0 alpha:1];
    }
}

@end
