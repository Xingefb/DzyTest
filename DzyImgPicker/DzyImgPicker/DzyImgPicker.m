//
//  DzyImgPicker.m
//  CustomImagePicker
//
//  Created by XG on 16/8/3.
//  Copyright © 2016年 com.lhs. All rights reserved.
//

#import "DzyImgPicker.h"

#import "LGPhoto.h"
#import "MLPhotoBrowserViewController.h"
#import "imageCell.h"

@interface DzyImgPicker ()<UIActionSheetDelegate,LGPhotoPickerViewControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MLPhotoBrowserViewControllerDataSource,MLPhotoBrowserViewControllerDelegate>

{
    //存储图片
    NSMutableArray *imageArray;

}
//最大的图片张数
@property (nonatomic ) NSInteger maxNum;
//父类的view
@property (nonatomic ) UIViewController *parentV;

@property (nonatomic, assign) LGShowImageType showType;

@end

@implementation DzyImgPicker

#pragma mark - <MLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger) numberOfSectionInPhotosInPhotoBrowser:(MLPhotoBrowserViewController *)photoBrowser{
    return 1;
}
- (NSInteger) photoBrowser:(MLPhotoBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    
    return imageArray.count;
}

#pragma mark - 每个组展示什么图片,需要包装下ZLPhotoPickerBrowserPhoto
- (MLPhotoBrowserPhoto *)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser photoAtIndexPath:(NSIndexPath *)indexPath
{
    MLPhotoBrowserPhoto *photo = [MLPhotoBrowserPhoto photoAnyImageObjWith:imageArray[indexPath.row]];
    imageCell *cell = (imageCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    photo.toView = cell.imgView;
    photo.thumbImage = cell.imgView.image;
    return photo;
}
#pragma mark - <MLPhotoPickerBrowserViewControllerDelegate>
#pragma mark 删除照片调用
- (void)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser removePhotoAtIndexPath:(NSIndexPath *)indexPat
{
    if (imageArray.count == 1) {
        [imageArray removeAllObjects];
        
    }else{
        [imageArray removeObjectAtIndex:indexPat.row];
        [self.collectionView reloadData];
    }
    
}

#pragma mark - setupCell click ZLPhotoPickerBrowserViewController
- (void) setupPhotoBrowser:(imageCell *) cell{
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    // 图片游览器
    MLPhotoBrowserViewController *photoBrowser = [[MLPhotoBrowserViewController alloc] init];
    // 缩放动画
    photoBrowser.status = UIViewAnimationAnimationStatusZoom;
    // 可以删除
    photoBrowser.editing = YES;
    // delegate
    photoBrowser.delegate = self;
    // 数据源
    photoBrowser.dataSource = self;
    // 当前选中的值
    photoBrowser.currentIndexPath = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
    // 展示控制器
    [photoBrowser show];
    
}
/**
 *  初始化自定义相机（连拍）
 */
#pragma mark - *初始化自定义相机（连拍）
- (void)presentCameraContinuous {
    ZLCameraViewController *cameraVC = [[ZLCameraViewController alloc] init];
    // 拍照最多个数
    cameraVC.maxCount = self.maxNum-imageArray.count;
    // 连拍
    cameraVC.cameraType = ZLCameraContinuous;
    cameraVC.callback = ^(NSArray *cameras){
        //在这里得到拍照结果
        //数组元素是ZLCamera对象
        
        for (ZLCamera *canamer in cameras) {
            
            [imageArray addObject:canamer.photoImage];
        }
                
    };
    //展示在父类的View上
    [cameraVC showPickerVc:self.parentV];
    
}

#pragma mark - *LGPhotoPickerViewControllerDelegate
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original{

    //thumbImage (缩略图)  fullResolutionImage(全屏图)  原图(originImage)
    NSMutableArray *originImage = [NSMutableArray array];
    
    for (LGPhotoAssets *photo in assets) {
        //原图
        [originImage addObject:photo.originImage];
        [imageArray addObject:photo.originImage];
    }
    
    [self.collectionView reloadData];

}

#pragma mark -  *  初始化相册选择器
- (void)presentPhotoPickerViewControllerWithStyle:(LGShowImageType)style {
    LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:style];
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = self.maxNum-imageArray.count;//设置选择张数上线
    pickerVc.delegate = self;
    self.showType = style;
    //展示在父类的view上
    [pickerVc showPickerVc:self.parentV];
}
#pragma mark *UIActionsheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    NSString *msg = [NSString stringWithFormat:@"%ld",(long)self.maxNum];

    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"相机");
            if (self.maxNum-imageArray.count == 0) {
                UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                
                [al show];
            }else{
                [self presentCameraContinuous];
            }
            
        }
            break;
        case 1:
        {
            NSLog(@"相册");
            if (self.maxNum-imageArray.count == 0) {
                UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                
                [al show];
            }else{
                [self presentPhotoPickerViewControllerWithStyle:LGShowImageTypeImagePicker];
                
            }
        }
            break;
        case 2:
        {
            NSLog(@"取消");
            
        }
            break;
        default:
            break;
    }
    
    
}
#pragma mark *UIActionSheet
- (void)toChoose{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"相机", @"相册",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.parentV.view];
    
}


- (void)createUI{
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flow];
    //设置代理
    _collectionView.backgroundColor = [UIColor whiteColor];
#warning mark 此处需要注意当正式使用的时候需要将边去掉   我这里是方便测试的时候显示范围
    _collectionView.layer.borderColor = [[UIColor redColor] CGColor];
    _collectionView.layer.borderWidth = 0.5;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //注册cell和ReusableView（相当于头部）
    [self.collectionView registerClass:[imageCell class] forCellWithReuseIdentifier:@"DzyImgCell"];
    
    [self addSubview:_collectionView];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    //------ block 方式漏出图片组供使用
    if (_DzyImgs) {
        _DzyImgs(imageArray);
    }
    
    //------- 代理方式
    if (self.dzyImgDelegate && [self.dzyImgDelegate respondsToSelector:@selector(getImages:)]) {
        [self.dzyImgDelegate getImages:imageArray];
    }
    
    //这里边设置 的是 点击添加图片按钮   如果没有到最上限 一直限制添加按钮  否则隐藏掉
    if (imageArray.count == self.maxNum) {
        return  self.maxNum;
    }else{
        return imageArray.count+1;
    }
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    imageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DzyImgCell" forIndexPath:indexPath];
    
    if (!cell) {
//        NSLog(@"不会进入");
    }
    
    if (indexPath.row == imageArray.count) {
//        NSLog(@"判断是最后一个 是添加按钮");
#warning mark 更改添加按钮背景图片 
        cell.imgView.image = [UIImage imageNamed:@"plus23.png"];
        cell.imgView.contentMode = UIViewContentModeScaleAspectFit;
        
    }else{
        //从相册或者相机选择的图片
        cell.imgView.image = imageArray[indexPath.row];
        cell.imgView.contentMode = UIViewContentModeScaleToFill;
        
    }
#warning mark 修改背景颜色
    cell.imgView.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath
{
    
    if (indexPath.row == imageArray.count && indexPath.row < self.maxNum) {
        NSLog(@"最后一个的话是添加按钮然后弹出选择键 选择图片的方式");
        [self toChoose];
    }else{
        imageCell * cell = (imageCell *)[collectionView cellForItemAtIndexPath :indexPath];
        //是图片的话配置浏览 和删除模式
        [self setupPhotoBrowser:cell];
        
    }
    
}

//返回这个UICollectionViewCell是否可以被选择  ***  设置之前的隐藏后 此方法可不设置
-( BOOL )collectionView:( UICollectionView *)collectionView shouldSelectItemAtIndexPath:( NSIndexPath *)indexPath

{

    if (indexPath.row == self.maxNum) {
        return NO;
    }else{
        return YES;
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}
//定义每个UICollectionView 的大小
- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath
{
    
    return CGSizeMake (60,60);
    
}
//定义每个UICollectionView 的边距
-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section

{
    
    return UIEdgeInsetsMake (10,10,10,10);
    
}

- (instancetype)initWithFrame:(CGRect)frame andParentV:(UIViewController *)parentV andMaxNum:(NSInteger )maxNum{

    if (self == [super initWithFrame:frame]) {
        
        imageArray = [NSMutableArray array];
        self.parentV = parentV;
        self.maxNum = maxNum;
        [self createUI];
        
    }
    return self;
}


@end
