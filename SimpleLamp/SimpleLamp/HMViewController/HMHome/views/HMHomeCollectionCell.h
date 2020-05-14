//
//  HMHomeCollectionCell.h
//  SimpleLamp
//
//  Created by chen on 2020/5/14.
//  Copyright © 2020 chen. All rights reserved.
//

#import <UIKit/UIKit.h>



#define HomeCollectionCell_space   10.0f
#define HomeCollectionCell_width   (SCREEN_WIDTH-30)/2.0f


NS_ASSUME_NONNULL_BEGIN

@interface HMHomeCollectionCell : UICollectionViewCell

@end




@interface HMHomeCollectionAdCell : UICollectionViewCell{
    
}
@property (nonatomic,strong) UIImageView *bigImage;


- (void)reloadWithInformation:(NSDictionary*)information;

@end




NS_ASSUME_NONNULL_END
