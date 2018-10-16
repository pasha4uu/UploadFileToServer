//
//  ViewController.h
//  PickDocumentExample
//
//  Created by PASHA on 16/10/18.
//  Copyright © 2018 Pasha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIDocumentPickerDelegate,UIDocumentMenuDelegate>

@property NSData * documentData;
@property NSURL * dataURL;
@property NSString * dataStr;
- (IBAction)pickDocumentTap:(id)sender;
@end

