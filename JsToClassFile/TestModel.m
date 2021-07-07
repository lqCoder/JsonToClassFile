//  Created by li qiao robot 
#import "TestModel.h" 
@implementation TestModelDataGoodsDiscountPriceVoList
@end

@implementation TestModelDataGiftssGoodsSegmentList
@end

@implementation TestModelDataGiftssGoodsSegmentMap
@end

@implementation TestModelDataGiftssGoods
+(NSDictionary*)mj_objectClassInArray{  
       return @{ @"segmentList" : [TestModelDataGiftssGoodsSegmentList class] }; 
}
@end

@implementation TestModelDataGiftssSegmentMap
@end

@implementation TestModelDataGiftssSegmentList
@end

@implementation TestModelDataGiftss
+(NSDictionary*)mj_objectClassInArray{  
       return @{ @"segmentList" : [TestModelDataGiftssSegmentList class] }; 
}
@end

@implementation TestModelData
+(NSDictionary*)mj_objectClassInArray{  
       return @{ @"giftss" : [TestModelDataGiftss class] ,@"goodsDiscountPriceVoList" : [TestModelDataGoodsDiscountPriceVoList class]}; 
}
@end

@implementation TestModel
@end

