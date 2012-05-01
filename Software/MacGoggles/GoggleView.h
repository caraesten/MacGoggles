//
//  GoggleView.h
//  MacGoggles
//
//  Created by Esten C Hurtle on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BarView.h"

@interface GoggleView : NSView
{
    int rectPercent;
}

-(void) doCleanup;

@property (retain) NSTextField *systemStatus;

@property (retain) NSTextField *tryAgain;

@property (retain) BarView *barView;


@end
