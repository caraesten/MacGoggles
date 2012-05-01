//
//  BarLegendView.m
//  MacGoggles
//
//  Created by Esten C Hurtle on 4/30/12.
//

#import "BarLegendView.h"

@implementation BarLegendView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Ticks in graph are white
    NSColor *color = [NSColor whiteColor];
    
    // Get the current Quartz context
    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
    
    // Get the base rectangle and path
    NSRect base = NSMakeRect(dirtyRect.origin.x, dirtyRect.origin.y, 5, dirtyRect.size.height);
    NSBezierPath *basePath = [NSBezierPath bezierPathWithRect:base];
    
    // Get the second tick's rectangle and path
    NSRect tipsy = NSMakeRect(dirtyRect.size.width * 0.39, dirtyRect.origin.y, 5, dirtyRect.size.height);
    NSBezierPath *tipsyPath = [NSBezierPath bezierPathWithRect:tipsy];
   
    // Get the third tick's rectangle and path
    NSRect drunk = NSMakeRect(dirtyRect.size.width * 0.58, dirtyRect.origin.y, 5, dirtyRect.size.height);
    NSBezierPath *drunkPath = [NSBezierPath bezierPathWithRect:drunk];
    
    // Draw text in helvetica, with a fill, and blue with 95% opacity
    CGContextSelectFont(ctx, "Helvetica", 18, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(ctx, kCGTextFill);
    CGContextSetRGBFillColor(ctx, 0.2, 0.2, 1, 0.95);
    
    // Show tipsy text
    CGContextShowTextAtPoint(ctx, dirtyRect.size.width * 0.39 + 5, dirtyRect.origin.y + 5, "Tipsy", 5);
    
    // Show drunk text
    CGContextShowTextAtPoint(ctx, dirtyRect.size.width * 0.58 + 5, dirtyRect.origin.y + 5, "Drunk", 5);
    
    // Draw everything
    [color set];
    [basePath fill];
    [tipsyPath fill];
    [drunkPath fill];
}

@end
