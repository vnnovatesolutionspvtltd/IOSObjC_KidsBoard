

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController
{
    IBOutlet UIButton *btnNew,*btnGallery;
    IBOutlet UIImageView *imageBG;
}

-(IBAction)btnNewClicked:(id)sender;
-(IBAction)btnGalleryClicked:(id)sender;

@end
