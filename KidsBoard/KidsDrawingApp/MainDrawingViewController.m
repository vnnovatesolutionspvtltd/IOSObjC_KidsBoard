

#import "MainDrawingViewController.h"
#import "Utility.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <Photos/PHAsset.h>


@interface MainDrawingViewController ()
{
    int tempCount,tempCount2,intRandomColor;
    CGPoint previousPoint1;
    CGPoint previousPoint2;
    CGPoint currentPoint;
    CGPoint mid1;
    CGPoint mid2;
    UIColor *bgColor;
    BOOL isErasing;
    NSMutableArray *arrUndo;
    NSMutableArray *arrRedo;
    
    BOOL isSave;
    
    BOOL isBack;
    
}

@end

@implementation MainDrawingViewController

@synthesize mainImage;
@synthesize tempDrawImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.bgImage.backgroundColor = [UIColor blackColor];
    
    bgColor = self.bgImage.backgroundColor;
    tempCount = 0;
    tempCount2 = 0;
    isBack=false;
    
    
    
    arrUndo = [[NSMutableArray alloc]init];
    arrRedo = [[NSMutableArray alloc]init];
    arrColor = [[NSMutableArray alloc]initWithObjects:[UIColor colorWithRed:(255.0f/255.0) green:(255.0f/255.0) blue:(0/255.0) alpha:1.0],
                [UIColor colorWithRed:(51/255.0) green:(204/255.0) blue:(51/255.0) alpha:1.0],
                [UIColor colorWithRed:(102/255.0) green:(153/255.0) blue:(255/255.0) alpha:1.0],
                [UIColor colorWithRed:(102/255.0) green:0 blue:(204/255.0) alpha:1.0],
                [UIColor colorWithRed:(255/255.0) green:0 blue:(255/255.0) alpha:1.0],
                [UIColor colorWithRed:(204/255.0) green:(102/255.0) blue:(255/255.0) alpha:1.0],
                [UIColor colorWithRed:(255/255.0) green:0 blue:0 alpha:1.0],
                [UIColor colorWithRed:(255/255.0) green:(102/255.0) blue:0 alpha:1.0], nil];
    
    
    intRandomColor=arc4random() % arrColor.count;
    const CGFloat *components = CGColorGetComponents([self getRandomStrokeColor].CGColor);
    red     = components[0];
    green = components[1];
    blue   = components[2];
    brush = 10.0;
    opacity = 1.0;
    
    viewPopUps.backgroundColor = [UIColor colorWithRed:253.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    viewPopUps.layer.cornerRadius = 5.0f;
    viewPopUps.layer.masksToBounds = NO;
    viewPopUps.layer.shadowOffset = CGSizeMake(-0.4f, 0.4f);
    viewPopUps.layer.shadowRadius = 4.0;
    viewPopUps.layer.shadowOpacity = 0.8;
    viewPopUps.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    viewPopUps.hidden = YES;
    viewPopUps.tag=0;
    
    
    
    viewEraser.layer.cornerRadius = 5.0f;
    viewEraser.layer.masksToBounds = NO;
    viewEraser.layer.shadowOffset = CGSizeMake(-0.4f, 0.4f);
    viewEraser.layer.shadowRadius = 4.0;
    viewEraser.layer.shadowOpacity = 0.8;
    viewEraser.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    viewEraser.hidden = YES;
    
    
    [slider addTarget:self action:@selector(onSliderValChanged:forEvent:) forControlEvents:UIControlEventValueChanged];
    
    
    [self addToggleButtons];
    
    if (_isGallery) {
        self.bgImage.image=_imageGallery;
    }
}
#pragma mark  - ToggleButton Delegate Method
-(void)addToggleButtons{
    CGRect buttonFrame = CGRectMake(0, 0, IS_IPAD?70.0f:40.0f, IS_IPAD?70.0f:40.0f);
    UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b1 setFrame:buttonFrame];
    [b1 setImage:[UIImage imageNamed:IS_IPAD?@"camera_icon_iPad":@"camera_icon"] forState:UIControlStateNormal];
    [b1 addTarget:self action:@selector(saveNew:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *b2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b2 setImage:[UIImage imageNamed:IS_IPAD?@"picture_icon_iPad":@"picture_icon"] forState:UIControlStateNormal];
    [b2 setFrame:buttonFrame];
    [b2 addTarget:self action:@selector(btnGalleryClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *b3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b3 setImage:[UIImage imageNamed:IS_IPAD?@"share_icon_iPad":@"share_icon"] forState:UIControlStateNormal];
    [b3 setFrame:buttonFrame];
    [b3 addTarget:self action:@selector(btnShareClicked:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *buttons = [NSArray arrayWithObjects:b1, b2, b3, nil];
    CGPoint center;
    if(IS_IPAD)
        center = CGPointMake(btnShare.frame.origin.x+(btnShare.frame.size.height/2), (viewButton.frame.origin.y+(btnShare.frame.size.height/2)));
    else
        center = CGPointMake((((btnShare.frame.origin.x+25) * [UIScreen mainScreen].bounds.size.width)/320), (((viewButton.frame.origin.y+25) * [UIScreen mainScreen].bounds.size.width)/320));

    RNExpandingButtonBar *bar = [[RNExpandingButtonBar alloc] initWithImage:[UIImage imageNamed:IS_IPAD?@"send_icon_iPad":@"send_icon"] selectedImage:[UIImage imageNamed:IS_IPAD?@"send_icon_iPad":@"send_icon"] toggledImage:[UIImage imageNamed:IS_IPAD?@"send_icon_iPad":@"send_icon"] toggledSelectedImage:[UIImage imageNamed:IS_IPAD?@"send_icon_iPad":@"send_icon"] buttons:buttons center:center];
    [bar setDelegate:self];
    [bar setSpin:YES];
    [self setBar:bar];
    [[self view] addSubview:[self bar]];
}
- (void) expandingBarDidAppear:(RNExpandingButtonBar *)bar
{
    //    NSLog(@"did appear");
}

- (void) expandingBarWillAppear:(RNExpandingButtonBar *)bar
{
    //    NSLog(@"will appear");
    [self ViewAnimation:viewEraser flag:true];
    [self ViewAnimationWithTag:viewPopUps flag:YES tag:0];
}

- (void) expandingBarDidDisappear:(RNExpandingButtonBar *)bar
{
    //    NSLog(@"did disappear");
}

- (void) expandingBarWillDisappear:(RNExpandingButtonBar *)bar
{
    //    NSLog(@"will disappear");
}

-(IBAction)btnDeletePopUpClicked:(id)sender;
{
    
    [arrRedo removeAllObjects];
    [arrUndo removeAllObjects];
    
    [self ViewAnimationWithTag:viewPopUps flag:YES tag:0];
    //    [UIView transitionWithView:viewPopUps
    //                      duration:0.5
    //                       options:UIViewAnimationOptionTransitionCrossDissolve
    //                    animations:^{
    //                        viewPopUps.hidden = YES;
    //                        viewPopUps.tag=0;
    //                    }
    //                    completion:NULL];
    
    self.mainImage.image = nil;
    [self btnCloseClicked:nil];
}

-(IBAction)btnSavePopUpClicked:(id)sender;
{
    
    [self ViewAnimationWithTag:viewPopUps flag:YES tag:0];
    //    [UIView transitionWithView:viewPopUps
    //                      duration:0.5
    //                       options:UIViewAnimationOptionTransitionCrossDissolve
    //                    animations:^{
    //                        viewPopUps.hidden = YES;
    //                        viewPopUps.tag=0;
    //                    }
    //                    completion:NULL];
    [self save:nil];
    self.mainImage.image = nil;
    [self btnCloseClicked:nil];
}

-(UIColor *)getRandomStrokeColor
{
    if(intRandomColor==arrColor.count-1)
        intRandomColor=0;
    else
        intRandomColor+=1;
    UIColor *color = [arrColor objectAtIndex:intRandomColor];
    return color;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidUnload
{
    [self setMainImage:nil];
    [self setTempDrawImage:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)reset:(id)sender
{
    self.mainImage.image = nil;
}

-(UIImage *)getMainImageFromContext
{
    //    UIGraphicsBeginImageContextWithOptions(self.mainImage.bounds.size, NO, 0.0);
    //    [self.bgImage.image drawInRect:CGRectMake(0, 0, self.bgImage.frame.size.width, self.bgImage.frame.size.height) blendMode:kCGBlendModeNormal alpha:1];
    //
    //    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.mainImage.frame.size.width, self.mainImage.frame.size.height) blendMode:kCGBlendModeNormal alpha:0.4];
    //    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    //    return SaveImage;
    
    UIGraphicsBeginImageContextWithOptions(viewBG.bounds.size, viewBG.opaque, 0.0);
    
    [viewBG.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

//NSBundle *bundle = [NSBundle mainBundle];
//NSDictionary *info = [bundle infoDictionary];
//NSString *prodName = [info objectForKey:@"CFBundleDisplayName"];
//
//ALAssetsLibrary *libraryFolder = [[ALAssetsLibrary alloc] init];
//__weak ALAssetsLibrary *lib = libraryFolder;
//
//[libraryFolder addAssetsGroupAlbumWithName:prodName resultBlock:^(ALAssetsGroup *group)
// {
//     NSLog(@"Adding Folder:'My Album', success: %s", group.editable ? "Success" : "Already created: Not Success");
// } failureBlock:^(NSError *error)
// {
//     NSLog(@"Error: Adding on Folder");
// }];
//
//
//
//[lib addAssetsGroupAlbumWithName:prodName resultBlock:^(ALAssetsGroup *group)
// {
//     if(group == nil)
//     {
//         //enumerate albums
//         [lib enumerateGroupsWithTypes:ALAssetsGroupAlbum
//                            usingBlock:^(ALAssetsGroup *g, BOOL *stop)
//          {
//              //if the album is equal to our album
//              if ([[g valueForProperty:ALAssetsGroupPropertyName] isEqualToString:prodName])
//              {
//                  //save image
//                  [lib writeImageDataToSavedPhotosAlbum:UIImagePNGRepresentation(saveImage) metadata:nil completionBlock:^(NSURL *assetURL, NSError *error)
//                   {
//                       //then get the image asseturl
//                       [lib assetForURL:assetURL resultBlock:^(ALAsset *asset)
//                        {
//                            //put it into our album
//                            [g addAsset:asset];
//                        } failureBlock:^(NSError *error)
//                        {
//                            
//                        }];
//                   }];
//              }
//          }failureBlock:^(NSError *error){}];
//     }
//     else
//     {
//         // save image directly to library
//         [lib writeImageDataToSavedPhotosAlbum:UIImagePNGRepresentation(saveImage) metadata:nil completionBlock:^(NSURL *assetURL, NSError *error)
//          {
//              [lib assetForURL:assetURL resultBlock:^(ALAsset *asset)
//               {
//                   [group addAsset:asset];
//               } failureBlock:^(NSError *error)
//               { }];
//          }];
//     }
// } failureBlock:^(NSError *error) {
//     
// }];


- (IBAction)save:(id)sender

{

    if (isSave && arrUndo.count>1) {
        
        [[self bar] hideButtonsAnimated:YES];
        
        [Utility showProgressViewInView:self.view withMessage:@""];
        
        
        
        UIGraphicsEndImageContext();
        
        UIImage *saveImage = [self getMainImageFromContext];
        
        UIImageWriteToSavedPhotosAlbum(saveImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
        
        
        
//                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        
//                        NSString *documentsDirectory = [paths objectAtIndex:0];
//        
//                        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[[NSProcessInfo processInfo] globallyUniqueString]]];
//        
//                        NSData *imageData = UIImagePNGRepresentation(saveImage);
//        
//                        [imageData writeToFile:savedImagePath atomically:NO];
        
        
        
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSDictionary *info = [bundle infoDictionary];
        NSString *prodName = [info objectForKey:@"CFBundleDisplayName"];
        
        ALAssetsLibrary *libraryFolder = [[ALAssetsLibrary alloc] init];
        ALAssetsLibrary *lib = libraryFolder;
        
        [libraryFolder addAssetsGroupAlbumWithName:prodName resultBlock:^(ALAssetsGroup *group)
         {
             NSLog(@"Adding Folder:'My Album', success: %s", group.editable ? "Success" : "Already created: Not Success");
         } failureBlock:^(NSError *error)
         {
             NSLog(@"Error: Adding on Folder");
         }];
        
        [lib addAssetsGroupAlbumWithName:prodName resultBlock:^(ALAssetsGroup *group)
         {
             if(group == nil)
             {
                 //enumerate albums
                 [lib enumerateGroupsWithTypes:ALAssetsGroupAlbum
                                    usingBlock:^(ALAssetsGroup *g, BOOL *stop)
                  {
                      //if the album is equal to our album
                      if ([[g valueForProperty:ALAssetsGroupPropertyName] isEqualToString:prodName])
                      {
                          //save image
                          [lib writeImageDataToSavedPhotosAlbum:UIImagePNGRepresentation(saveImage) metadata:nil completionBlock:^(NSURL *assetURL, NSError *error)
                           {
                               //then get the image asseturl
                               [lib assetForURL:assetURL resultBlock:^(ALAsset *asset)
                                {
                                    //put it into our album
                                    [g addAsset:asset];
                                } failureBlock:^(NSError *error)
                                {
        
                                }];
                           }];
                      }
                  }failureBlock:^(NSError *error){}];
             }
             else
             {
                 // save image directly to library
                 [lib writeImageDataToSavedPhotosAlbum:UIImagePNGRepresentation(saveImage) metadata:nil completionBlock:^(NSURL *assetURL, NSError *error)
                  {
                      [lib assetForURL:assetURL resultBlock:^(ALAsset *asset)
                       {
                           [group addAsset:asset];
                       } failureBlock:^(NSError *error)
                       { }];
                  }];
             }
         } failureBlock:^(NSError *error) {
             
         }];

        
        
        
        
        
        

        
        isSave=false;
        
        
        
        
        
        
        
        if (isBack) {
            
            if (_isGallery) {
                
                [self.navigationController popToRootViewControllerAnimated:true];
                
            }
            
            else{
                
                [self.navigationController popViewControllerAnimated:true];
                
            }
            
            
            
            isBack=false;
            
        }
        
        
        
        
        
    }
    
}
- (IBAction)saveNew:(id)sender

{
    
    if (isSave) {
        
        [[self bar] hideButtonsAnimated:YES];
        
        [Utility showProgressViewInView:self.view withMessage:@""];
        
        
        
        UIGraphicsEndImageContext();
        
        UIImage *saveImage = [self getMainImageFromContext];
        
        UIImageWriteToSavedPhotosAlbum(saveImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        
//        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[[NSProcessInfo processInfo] globallyUniqueString]]];
//        
//        NSData *imageData = UIImagePNGRepresentation(saveImage);
//        
//        [imageData writeToFile:savedImagePath atomically:NO];
        
        
        
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSDictionary *info = [bundle infoDictionary];
        NSString *prodName = [info objectForKey:@"CFBundleDisplayName"];
        
        ALAssetsLibrary *libraryFolder = [[ALAssetsLibrary alloc] init];
        ALAssetsLibrary *lib = libraryFolder;
        
        [libraryFolder addAssetsGroupAlbumWithName:prodName resultBlock:^(ALAssetsGroup *group)
         {
             NSLog(@"Adding Folder:'My Album', success: %s", group.editable ? "Success" : "Already created: Not Success");
         } failureBlock:^(NSError *error)
         {
             NSLog(@"Error: Adding on Folder");
         }];
        
        [lib addAssetsGroupAlbumWithName:prodName resultBlock:^(ALAssetsGroup *group)
         {
             if(group == nil)
             {
                 //enumerate albums
                 [lib enumerateGroupsWithTypes:ALAssetsGroupAlbum
                                    usingBlock:^(ALAssetsGroup *g, BOOL *stop)
                  {
                      //if the album is equal to our album
                      if ([[g valueForProperty:ALAssetsGroupPropertyName] isEqualToString:prodName])
                      {
                          //save image
                          [lib writeImageDataToSavedPhotosAlbum:UIImagePNGRepresentation(saveImage) metadata:nil completionBlock:^(NSURL *assetURL, NSError *error)
                           {
                               //then get the image asseturl
                               [lib assetForURL:assetURL resultBlock:^(ALAsset *asset)
                                {
                                    //put it into our album
                                    [g addAsset:asset];
                                } failureBlock:^(NSError *error)
                                {
                                    
                                }];
                           }];
                      }
                  }failureBlock:^(NSError *error){}];
             }
             else
             {
                 // save image directly to library
                 [lib writeImageDataToSavedPhotosAlbum:UIImagePNGRepresentation(saveImage) metadata:nil completionBlock:^(NSURL *assetURL, NSError *error)
                  {
                      [lib assetForURL:assetURL resultBlock:^(ALAsset *asset)
                       {
                           [group addAsset:asset];
                       } failureBlock:^(NSError *error)
                       { }];
                  }];
             }
         } failureBlock:^(NSError *error) {
             
         }];
        
        
        
        
        
        
        
        
        
        isSave=false;
        
        
        
        
        
        
        
        if (isBack) {
            
            if (_isGallery) {
                
                [self.navigationController popToRootViewControllerAnimated:true];
                
            }
            
            else{
                
                [self.navigationController popViewControllerAnimated:true];
                
            }
            
            
            
            isBack=false;
            
        }
        
        
        
        
        
    }
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [Utility hideProgress:self.view];
    
    if (error != NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Image could not be saved.Please try again"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    } else {
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Image was successfully saved in album"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        //        [alert show];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    isSave=true;
    [[self bar] hideButtonsAnimated:YES];
    [self ViewAnimation:viewEraser flag:true];
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    previousPoint1 = [touch previousLocationInView:self.view];
    previousPoint2 = [touch previousLocationInView:self.view];
    currentPoint = [touch locationInView:self.view];
    
    if (isErasing) {
        self.tempDrawImage.image = self.mainImage.image;
        self.mainImage.image = nil;
    }
    
}

-(void)callForDrawLineWithCurrentPoint:(CGPoint)currentPoint LineWidth:(CGFloat)lWidth
{
    if(![viewPopUps isHidden])
        return;
    UIGraphicsBeginImageContext(self.mainImage.frame.size);
    
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), mid1.x, mid1.y);
    CGContextAddQuadCurveToPoint(UIGraphicsGetCurrentContext(), previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineJoin(UIGraphicsGetCurrentContext(), kCGLineJoinRound);
    
    if(isErasing)
    {
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), slider.value*(IS_IPAD?100:50));
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    }
    else
    {
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lWidth );
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 255, 255, 255, 1.0);
        CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(0, 0), 20.0, [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeScreen);
    }
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempDrawImage setAlpha:opacity];
    UIGraphicsEndImageContext();
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    
    previousPoint2 = previousPoint1;
    previousPoint1 = [touch previousLocationInView:self.view];
    currentPoint = [touch locationInView:self.view];
    mid1 = midPoint(previousPoint1, previousPoint2);
    mid2 = midPoint(currentPoint, previousPoint1);
    
    [arrRedo removeAllObjects];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self callForDrawLineWithCurrentPoint:currentPoint LineWidth:5.0f];
        [self callForDrawLineWithCurrentPoint:currentPoint LineWidth:4.0f];
        [self callForDrawLineWithCurrentPoint:currentPoint LineWidth:3.0f];
        [self callForDrawLineWithCurrentPoint:currentPoint LineWidth:2.0f];
    });
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    const CGFloat *components = CGColorGetComponents([self getRandomStrokeColor].CGColor);
    red     = components[0];
    green = components[1];
    blue   = components[2];
    if(!mouseSwiped && !isErasing && [viewPopUps isHidden]) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousPoint1.x, previousPoint1.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), previousPoint1.x, previousPoint1.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    }
    
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.0f);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [arrUndo addObject:UIGraphicsGetImageFromCurrentImageContext()];
    //    if(arrUndo.count>5)
    //    {
    //        [arrUndo removeObjectAtIndex:0];
    //    }
    //[self.mainImage addSubview:[[UIImageView alloc] initWithImage:UIGraphicsGetImageFromCurrentImageContext()]];
    self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
}

CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

- (IBAction)btnHomeClicked:(id)sender
{
    
    isBack=true;
    [self btnCloseClicked:nil];
    
}

- (IBAction)btnCloseClicked:(UIButton *)sender
{
    
    [[self bar] hideButtonsAnimated:YES];
    [self ViewAnimation:viewEraser flag:true];
    isErasing=false;
    NSData *imageData = UIImagePNGRepresentation(self.mainImage.image);
    //    NSLog(@"%lu",(unsigned long)imageData.length);
    
    
    if(imageData.length==0 || arrUndo.count==1 || !isSave)
    {
        mainImage.image=nil;
        tempDrawImage.image=nil;
        
        if(tempCount%4 == 0)
        {
            if(tempCount2==0)
            {
                self.bgImage.backgroundColor = [UIColor whiteColor];
                tempCount2=1;
                [arrUndo removeAllObjects];
                [arrRedo removeAllObjects];
            }
            else
            {
                self.bgImage.backgroundColor = [UIColor blackColor];
                tempCount2 = 0;
                [arrUndo removeAllObjects];
                [arrRedo removeAllObjects];
            }
        }
        else{
            [arrUndo removeAllObjects];
            [arrRedo removeAllObjects];
            self.bgImage.backgroundColor = [self getRandomColorForBackGround];
        }
        
        
        self.bgImage.image = nil;
        bgColor = self.bgImage.backgroundColor;
        tempCount +=1;
        self.mainImage.image = nil;
        if (isBack) {
            if (_isGallery) {
                [self.navigationController popToRootViewControllerAnimated:true];
            }
            else{
                [self.navigationController popViewControllerAnimated:true];
            }
        }
        
    }
    else
    {
        if(viewPopUps.tag==1)
        {
            [self ViewAnimationWithTag:viewPopUps flag:YES tag:0];
            //
            //            [UIView transitionWithView:viewPopUps
            //                              duration:0.5
            //                               options:UIViewAnimationOptionTransitionCrossDissolve
            //                            animations:^{
            //                                viewPopUps.hidden = YES;
            //                                viewPopUps.tag=0;
            //                            }
            //                            completion:NULL];
        }
        else
        {
            
            [self ViewAnimationWithTag:viewPopUps flag:FALSE tag:1];
            //            [UIView transitionWithView:viewPopUps
            //                              duration:0.5
            //                               options:UIViewAnimationOptionTransitionCrossDissolve
            //                            animations:^{
            //                                viewPopUps.hidden = FALSE;
            //                                viewPopUps.tag=1;
            //                            }
            //                            completion:NULL];
        }
        
    }
}

- (UIColor *)getRandomColorForBackGround
{
    CGFloat red1 = arc4random() % 255 / 255.0;
    CGFloat green1 = arc4random() % 255 / 255.0;
    CGFloat blue1 = arc4random() % 255 / 255.0;
    UIColor *color = [UIColor colorWithRed:red1 green:green1 blue:blue1 alpha:1.0];
    return color;
}


-(IBAction)btnEraseClicked:(id)sender;
{
    isErasing = TRUE;
    
    [self ViewAnimationWithTag:viewPopUps flag:YES tag:0];
    [[self bar] hideButtonsAnimated:YES];
    if (![viewPopUps isHidden]) {
        viewPopUps.hidden=true;
        viewPopUps.tag=0;
    }
    
    
    
    if ([viewEraser isHidden]) {
        [self ViewAnimation:viewEraser flag:false];
        [imgEraser setTransform:CGAffineTransformMakeScale(slider.value, slider.value)];
    }
    else{
        [self ViewAnimation:viewEraser flag:true];
    }
}

-(void)ViewAnimation:(UIView *)viewname flag:(BOOL)flag{
    [UIView transitionWithView:viewname
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        viewname.hidden = flag;
                    }
                    completion:NULL];
}
-(void)ViewAnimationWithTag:(UIView *)viewname flag:(BOOL)flag tag:(NSInteger)tag{
    [UIView transitionWithView:viewname
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        viewname.hidden = flag;
                        viewname.tag=tag;
                    }
                    completion:NULL];
}
-(IBAction)btnViewEraserClicked:(id)sender{
    [self ViewAnimation:viewEraser flag:true];
    isErasing = TRUE;
}
- (void)onSliderValChanged:(UISlider*)sliders forEvent:(UIEvent*)event {
    [imgEraser setTransform:CGAffineTransformMakeScale(sliders.value, sliders.value)];
    isErasing = TRUE;
    
    
    
    UITouch *touchEvent = [[event allTouches] anyObject];
    switch (touchEvent.phase) {
        case UITouchPhaseBegan:
            // handle drag began
            break;
        case UITouchPhaseMoved:
            // handle drag moved
            break;
        case UITouchPhaseEnded:
            // handle drag ended
            [self ViewAnimation:viewEraser flag:true];
            break;
        default:
            break;
    }}

-(IBAction)btnDrawClicked:(id)sender;
{
    [self ViewAnimationWithTag:viewPopUps flag:YES tag:0];
    [[self bar] hideButtonsAnimated:YES];
    [self ViewAnimation:viewEraser flag:true];
    isErasing = FALSE;
    const CGFloat *components = CGColorGetComponents(bgColor.CGColor);
    red     = components[0];
    green = components[1];
    blue   = components[2];
}

-(IBAction)btnUndoClicked:(id)sender;
{
    [self ViewAnimationWithTag:viewPopUps flag:YES tag:0];
    [[self bar] hideButtonsAnimated:YES];
    [self ViewAnimation:viewEraser flag:true];
    if (arrUndo.count>0) {
        [arrRedo addObject:[arrUndo lastObject]];
        [arrUndo removeLastObject];
        self.mainImage.image = [arrUndo lastObject];
        
        if (arrUndo.count==0) {
            if (_isGallery) {
            self.bgImage.image=_imageGallery;
            }
        }
    }
}
-(IBAction)btnReduClicked:(id)sender;
{
    [self ViewAnimationWithTag:viewPopUps flag:YES tag:0];
    [[self bar] hideButtonsAnimated:YES];
    [self ViewAnimation:viewEraser flag:true];
    if (arrRedo.count>0) {
        self.mainImage.image = [arrRedo lastObject];
        [arrUndo addObject:[arrRedo lastObject]];
        [arrRedo removeLastObject];
    }
}
-(IBAction)btnShareClicked:(id)sender;
{
    [[self bar] hideButtonsAnimated:YES];
    [self ViewAnimation:viewEraser flag:true];
    NSArray *objectsToShare = @[[self getMainImageFromContext]];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    if ( [activityVC respondsToSelector:@selector(popoverPresentationController)] )
    {
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityVC];
        [popup presentPopoverFromRect:CGRectMake(btnShare.frame.origin.x, btnShare.frame.origin.y, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    else
        [self presentViewController:activityVC animated:YES completion:nil];
}
-(IBAction)btnGalleryClicked:(id)sender{
    
    if (isSave && arrUndo.count>1) {
        [self btnCloseClicked:nil];
    }
    else{
        [[self bar] hideButtonsAnimated:YES];
        if (!imagePickerController) {
            UIImagePickerController *imgPickerController = [[UIImagePickerController alloc] init];
            imgPickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
            imgPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imgPickerController.delegate = self;
            imgPickerController.allowsEditing = NO;
            imagePickerController = imgPickerController;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        else
        {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
}
#pragma mark ----------
#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    if(tempCount%4 == 0)
    {
        if(tempCount2==0)
        {
            self.bgImage.backgroundColor = [UIColor whiteColor];
            tempCount2=1;
        }
        else
        {
            self.bgImage.backgroundColor = [UIColor blackColor];
            tempCount2 = 0;
        }
    }
    else
        self.bgImage.backgroundColor = [self getRandomColorForBackGround];
    
    bgColor = self.bgImage.backgroundColor;
    tempCount +=1;
    self.mainImage.image = nil;
    self.bgImage.contentMode=UIViewContentModeScaleAspectFit;
    self.bgImage.image=image;
    self.bgImage.backgroundColor = [UIColor blackColor];
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
