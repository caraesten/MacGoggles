//
//  BarView.h
//  MacGoggles
//
//  Created by Esten C Hurtle on 4/26/12.
//

#import <Cocoa/Cocoa.h>

@interface BarView : NSView
{
    NSColor *backgroundColor;
}
- (void) setAlcoholForBackground:(int) alcoholLevel;

@end
