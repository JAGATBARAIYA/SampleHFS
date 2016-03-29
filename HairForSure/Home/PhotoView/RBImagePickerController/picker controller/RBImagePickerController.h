//
//  RBImagePickerController.h
//  RBImagePicker
//
//  Created by Roshan Balaji on 1/31/14.
//  Copyright (c) 2014 Uniq Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBImagePickerDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "RBImageCollectionCell.h"

#import "ALAsset+RBAsset.h"
#define CELLIDENTIFIER @"assetcell"
#define ASSET_WIDTH_HEIGHT 75
#define LINE_SPACING 1

typedef enum {
    
    RBSingleImageSelectionType,
    RBMultipleImageSelectionType
    
} RBSelectionType;

@interface RBImagePickerController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
}

@property (nonatomic, retain) IBOutlet UICollectionView *collectionView;

@property(nonatomic, retain) id<RBImagePickerDelegate, UINavigationControllerDelegate>delegate;
@property(nonatomic) RBSelectionType selectionType;
@property(nonatomic, strong)NSArray *assets;
@property(nonatomic)NSInteger maxSelectionCount;
@property(nonatomic)NSInteger minSelectionCount;
@property(nonatomic, retain) ALAssetsLibrary* assetslibrary;

@property(nonatomic, strong) NSMutableDictionary *selected_images;
@property(nonatomic, strong) NSMutableArray *selected_images_index;
@property (nonatomic, retain) UIImagePickerController *imagePickerController;


-(void)finishPickingImages;
@end

