//
//  GoggleViewController.h
//  MacGoggles
//
//  Created by Esten C Hurtle on 4/28/12.
//

#import <Cocoa/Cocoa.h>
#import "BarView.h"
#import "BarLegendView.h"

@interface GoggleViewController : NSViewController
{
    int rectPercent;
    BarLegendView *legend;
}

-(void) doCleanup;

@property (retain) IBOutlet NSTextField *systemStatus;

@property (retain) IBOutlet NSTextField *tryAgain;

@property (retain) IBOutlet BarView *barView;

@end
