
#import <UIKit/UIKit.h>
#import "RNExpandingButtonBar.h"
@interface MainDrawingViewController : UIViewController<RNExpandingButtonBarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIView *viewBG,*viewPopUps;
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
    NSMutableArray *arrColor;
    IBOutlet UIButton *btnSavePopUps,*btnDeletePopUps;
    
    
    
    IBOutlet UIView *viewEraser;
    IBOutlet UIImageView *imgEraser;
    IBOutlet UISlider *slider;
    
    
    IBOutlet UIButton *btnUndo;
    IBOutlet UIButton *btnRedo;
    IBOutlet UIButton *btnShare;
    IBOutlet UIView *viewButton;
    
    UIImagePickerController *imagePickerController;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIButton *btnHome;
@property(assign,nonatomic)BOOL isGallery;
@property(strong,nonatomic)UIImage *imageGallery;
@property (nonatomic, strong) RNExpandingButtonBar *bar;

- (IBAction)btnHomeClicked:(id)sender;
- (IBAction)btnCloseClicked:(id)sender;
-(IBAction)btnEraseClicked:(id)sender;
-(IBAction)btnViewEraserClicked:(id)sender;
-(IBAction)btnDrawClicked:(id)sender;
-(IBAction)btnUndoClicked:(id)sender;
-(IBAction)btnReduClicked:(id)sender;
-(IBAction)btnShareClicked:(id)sender;
-(IBAction)btnGalleryClicked:(id)sender;
-(IBAction)btnDeletePopUpClicked:(id)sender;
-(IBAction)btnSavePopUpClicked:(id)sender;



@end
