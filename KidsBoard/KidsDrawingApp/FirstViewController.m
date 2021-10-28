

#import "FirstViewController.h"
#import "MainDrawingViewController.h"
#import "GalleryViewController.h"
#import "Utility.h"

@interface FirstViewController ()

@end

@implementation FirstViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    NSLog(@"TEst");
    NSLog(@"test");
    
    if(IS_IPAD)
        imageBG.image = [UIImage imageNamed:@"homeBg_iPad.png"];
    else
        imageBG.image = [UIImage imageNamed:@"homebg.png"];
}

-(IBAction)btnNewClicked:(id)sender;
{
    MainDrawingViewController *objMain = [[MainDrawingViewController alloc]init];
    [self.navigationController pushViewController:objMain animated:YES];
}

-(IBAction)btnGalleryClicked:(id)sender;
{
    GalleryViewController *objGallery = [[GalleryViewController alloc]init];
    [self.navigationController pushViewController:objGallery animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
