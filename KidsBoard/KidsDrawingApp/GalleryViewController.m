

#import "GalleryViewController.h"
#import "GalleryCell.h"
#import "MainDrawingViewController.h"
#import "Utility.h"

@interface GalleryViewController (){
    NSMutableArray *arrImages;
    NSMutableArray *arrImagesName;
    NSInteger selectedindex;
}

@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrImages=[[NSMutableArray alloc] init];
    arrImagesName=[[NSMutableArray alloc] init];
    [clnGalleryList registerNib:[UINib nibWithNibName:NSStringFromClass([GalleryCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([GalleryCell class])];
    [self getSavedImages];
    
    if(IS_IPAD){
        imageBG.image = [UIImage imageNamed:@"homeBg_iPad.png"];
        lblTotalRecord.font = [UIFont systemFontOfSize:30.0f];
    }
    else{
        imageBG.image = [UIImage imageNamed:@"homebg.png"];
        lblTotalRecord.font = [UIFont systemFontOfSize:20.0f];
    }
    
    [viewFooter setAlpha:1];
    viewFooter.layer.masksToBounds = NO;
    viewFooter.layer.cornerRadius = 5;
    viewFooter.layer.shadowOffset = CGSizeMake(-0.2f, 0.2f);
    viewFooter.layer.shadowRadius = 1.0;
    viewFooter.layer.shadowOpacity = 0.8;
    viewFooter.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    
}
-(IBAction)btnBack:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:true];
}
-(IBAction)btnBackFullView:(UIButton *)sender{
    viewFullImage.hidden=true;
}

-(void)getSavedImages{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myPath = [paths objectAtIndex:0];
    // if you save fies in a folder
    //myPath = [myPath stringByAppendingPathComponent:@"folder_name"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:myPath error:nil];
    
    // filter image files
    NSMutableArray *subpredicates = [NSMutableArray array];
    [subpredicates addObject:[NSPredicate predicateWithFormat:@"SELF ENDSWITH '.png'"]];
    [subpredicates addObject:[NSPredicate predicateWithFormat:@"SELF ENDSWITH '.jpg'"]];
    NSPredicate *filter = [NSCompoundPredicate orPredicateWithSubpredicates:subpredicates];
    
    NSArray *onlyImages = [directoryContents filteredArrayUsingPredicate:filter];
    
    for (int i = 0; i < onlyImages.count; i++) {
        NSString *imagePath = [myPath stringByAppendingPathComponent:[onlyImages objectAtIndex:i]];
        [arrImages addObject:imagePath];
        [arrImagesName addObject:[onlyImages objectAtIndex:i]];
    }
    lblTotalRecord.text=[NSString stringWithFormat:@"%ld paintings",arrImages.count];
    [clnGalleryList reloadData];
}
-(IBAction)btnPaintClick:(UIButton *)sender{
    MainDrawingViewController *objMain = [[MainDrawingViewController alloc]init];
    objMain.imageGallery=[UIImage imageWithContentsOfFile:[arrImages objectAtIndex:carosal_index]];
    objMain.isGallery=true;
    [self.navigationController pushViewController:objMain animated:YES];
    
}
-(IBAction)btnDeleteClick:(UIButton *)sender{
    UIAlertController * alertPinSuccess = [UIAlertController
                                           alertControllerWithTitle:@""
                                           message:@"Are you sure want to Delete this image?"
                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    viewFullImage.hidden=true;
                                    [self removeImageFromDirectory:[arrImagesName objectAtIndex:selectedindex]];
                                    [arrImages removeObjectAtIndex:selectedindex];
                                    [clnGalleryList reloadData];
                                    lblTotalRecord.text=[NSString stringWithFormat:@"%ld paintings",arrImages.count];
                                    
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   
                               }];
    
    
    [alertPinSuccess addAction:noButton];
    [alertPinSuccess addAction:yesButton];
    [self presentViewController:alertPinSuccess animated:YES completion:nil];
}
-(IBAction)btnShareClick:(UIButton *)sender{
//    NSString *textToShare = @"Look at this awesome website for aspiring iOS Developers!";
    UIImage *img=[UIImage imageWithContentsOfFile:[arrImages objectAtIndex:selectedindex]];
    
//    NSURL *myWebsite = [NSURL URLWithString:@"http://www.codingexplorer.com/"];
    
    NSArray *objectsToShare = @[img];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
//    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
//                                   UIActivityTypePrint,
//                                   UIActivityTypeAssignToContact,
//                                   UIActivityTypeSaveToCameraRoll,
//                                   UIActivityTypeAddToReadingList,
//                                   UIActivityTypePostToFlickr,
//                                   UIActivityTypePostToVimeo];
//    
//    activityVC.excludedActivityTypes = excludeActivities;
    
    if ( [activityVC respondsToSelector:@selector(popoverPresentationController)] )
    {
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityVC];
        [popup presentPopoverFromRect:CGRectMake(btnShare.frame.origin.x, btnShare.frame.origin.y, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    else
    [self presentViewController:activityVC animated:YES completion:nil];
}
- (void)removeImageFromDirectory:(NSString *)filename
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:filename];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        [arrImagesName removeObjectAtIndex:selectedindex];
        UIAlertController * alertPinSuccess = [UIAlertController
                                               alertControllerWithTitle:@"Alert"
                                               message:@"Successfully removed"
                                               preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                    }];
        [alertPinSuccess addAction:yesButton];
        [self presentViewController:alertPinSuccess animated:YES completion:nil];
    }
    else
    {
        //        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}
#pragma mark ----------------
#pragma mark UICollectionView Delegate And DataSource Method
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if ([arrImages count]>0)
    {
        clnGalleryList.backgroundView = nil;
        return 1;
    }
    else
    {
        //        [Utility addCollectionBackGroundView:ClnProfileList withMessage:AMLocalizedString(NoRecord_found, nil)];
        return 0;
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrImages.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GalleryCell *cell = (GalleryCell*)[clnGalleryList dequeueReusableCellWithReuseIdentifier:@"GalleryCell" forIndexPath:indexPath];
    
    
    cell.imgSketch.image=nil;
    cell.imgSketch.image=[UIImage imageWithContentsOfFile:[arrImages objectAtIndex:indexPath.row]];
    
    
    //    [cell.imgRecipe sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",strRecipesImagePath,[obj.arrRecipesImage objectAtIndex:0]]] placeholderImage:[UIImage imageNamed:@"recipeIcon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //        if (image) {
    //            cell.imgRecipe.contentMode=UIViewContentModeScaleAspectFill;
    //        }
    //        else{
    //            cell.imgRecipe.contentMode=UIViewContentModeScaleAspectFit;
    //        }
    //    }];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectedindex=indexPath.row;
//    viewFullImage.hidden=false;
    
    if (arrImages.count>0) {
        [_carousel reloadData];
        _carousel.pagingEnabled=true;
        _carousel.currentItemIndex=selectedindex;
        viewFullImage.hidden=false;
        viewFullImage.transform = CGAffineTransformMakeScale(0.2, 0.2);
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionFlipFromTop|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveLinear animations:^{
            viewFullImage.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, (5 * [UIScreen mainScreen].bounds.size.width)/320, 0, (5 * [UIScreen mainScreen].bounds.size.width)/320); // top, left, bottom, right
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((100 * [UIScreen mainScreen].bounds.size.width)/320,(100 * [UIScreen mainScreen].bounds.size.width)/320);
}

#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return arrImagesName.count;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)indexs reusingView:(UIView *)view
{
    if (view == nil)
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    
    ((UIImageView *)view).clipsToBounds = YES;
    ((UIImageView *)view).image = [UIImage imageWithContentsOfFile:[arrImages objectAtIndex:indexs]];
   
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1;
    }
    else if (option == iCarouselOptionWrap)
    {
        return NO;
    }
    return value;
}

-(void)carouselDidScroll:(iCarousel *)carousel
{
    carosal_index=carousel.currentItemIndex;
//    selectedindex=carosal_index;
}
- (void)carousel:(iCarousel *)caro didSelectItemAtIndex:(NSInteger)index{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
