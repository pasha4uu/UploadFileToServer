//
//  ViewController.m
//  PickDocumentExample
//
//  Created by PASHA on 16/10/18.
//  Copyright © 2018 Pasha. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.documentData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"file" ofType:@"docx"]];
//  [self documentUploadAction];
  // Do any additional setup after loading the view, typically from a nib.
}
-(void)documentUploadAction
{
  NSLog(@"document ssss");
  NSString *boundary = @"SportuondoFormBoundary";
  NSMutableData *body = [NSMutableData data];
  NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
  [params setValue:@"pppppp"forKey:@"name"];
  for (NSString *param in params) {
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
  }
  [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"file.docx\"\r\n", @"file"] dataUsingEncoding:NSUTF8StringEncoding]];
  [body appendData:[@"Content-Type: docx/pdf\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  [body appendData:self.documentData];
  [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
  [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
  sessionConfiguration.HTTPAdditionalHeaders =
@{
  //   @"api-key"       : @"55e76dc4bbae25b066cb",
 @"Accept"        : @"application/json",
 @"Content-Type"  : [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
 };
  
  NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:nil];
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.6:2300/admin/for-pasha-files"]];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  request.HTTPMethod = @"POST";
  request.HTTPBody = body;
  NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"my data is :  %@ ",dic);
    dispatch_async(dispatch_get_main_queue(), ^{
      if ([[dic objectForKey:@"success"] boolValue]) {
      }
      else
      {
        
      }
      
    });
  }];
  
  
  
  [task resume];
  
}



- (IBAction)pickDocumentTap:(id)sender {
    UIDocumentMenuViewController *picker =  [[UIDocumentMenuViewController alloc] initWithDocumentTypes:@[@"com.adobe.pdf"] inMode:UIDocumentPickerModeImport];
    
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
  }
  
  
  -(void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker
  {
    documentPicker.delegate = self;
    [self presentViewController:documentPicker animated:YES completion:nil];
  }
  
  - (void)documentPicker:(UIDocumentPickerViewController *)controller
didPickDocumentAtURL:(NSURL *)url
  {
    self.dataURL= url;
    self.dataStr=@"PDF";
    self.documentData = [NSData dataWithContentsOfURL:self.dataURL];
    NSLog(@"docu data is------ :%@",self.dataURL);
    [self documentUploadAction];
  }

@end
