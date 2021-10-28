

#import <UIKit/UIKit.h>
#import "iCarousel.h"
@interface GalleryViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,iCarouselDataSource, iCarouselDelegate>{
    IBOutlet UICollectionView *clnGalleryList;
    
    IBOutlet UIView *viewFullImage;
    NSInteger carosal_index;
    IBOutlet UILabel *lblTotalRecord;
    IBOutlet UIView *viewFooter;
    IBOutlet UIImageView *imageBG;
    IBOutlet UIButton *btnShare;
}
@property (nonatomic, strong) IBOutlet iCarousel *carousel;
-(IBAction)btnBack:(UIButton *)sender;
-(IBAction)btnBackFullView:(UIButton *)sender;
-(IBAction)btnPaintClick:(UIButton *)sender;
-(IBAction)btnDeleteClick:(UIButton *)sender;
-(IBAction)btnShareClick:(UIButton *)sender;


@end
