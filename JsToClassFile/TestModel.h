//  Created by li qiao robot 
#import <Foundation/Foundation.h>
@interface TestModelDataGoodsDiscountPriceVoList : NSObject
@property (nonatomic,strong) NSNumber *goodsid;
@property (nonatomic,strong) NSNumber *discountedPrice;
@property (nonatomic,strong) NSString *segmentBD;
@end

@interface TestModelDataGiftssGoodsSegmentList : NSObject
@end

@interface TestModelDataGiftssGoodsSegmentMap : NSObject
@property (nonatomic,copy)   NSString *batchCode;
@property (nonatomic,copy)   NSString *locationName;
@property (nonatomic,strong) NSNumber *qty;
@property (nonatomic,strong) NSNumber *stockPrice;
@end

@interface TestModelDataGiftssGoods : NSObject
@property (nonatomic,copy)   NSString *prescription;
@property (nonatomic,copy)   NSString *code;
@property (nonatomic,strong) NSNumber *storeId;
@property (nonatomic,strong) NSString *englishName;
@property (nonatomic,strong) NSString *goodsLimit;
@property (nonatomic,strong) NSNumber *id;
@property (nonatomic,strong) NSString *minunit;
@property (nonatomic,strong) NSString *imagePath;
@property (nonatomic,copy)   NSString *storeName;
@property (nonatomic,strong) NSString *largeQty;
@property (nonatomic,strong) NSString *buyer;
@property (nonatomic,strong) NSNumber *isDeptDeliveryRequest;
@property (nonatomic,copy)   NSString *originPlace;
@property (nonatomic,strong) NSString *tradeName;
@property (nonatomic,strong) NSString *mantainCyc;
@property (nonatomic,copy)   NSString *modifyDate;
@property (nonatomic,copy)   NSString *notes;
@property (nonatomic,strong) NSString *directorAuditDate;
@property (nonatomic,strong) NSString *segmentLong;
@property (nonatomic,copy)   NSString *deptName;
@property (nonatomic,strong) NSString *mediumQty;
@property (nonatomic,copy)   NSString *mantainType;
@property (nonatomic,strong) NSNumber *limitQty;
@property (nonatomic,copy)   NSString *segment;
@property (nonatomic,strong) NSString *convertRatio;
@property (nonatomic,strong) NSString *buyerAuditDate;
@property (nonatomic,copy)   NSString *mantainTypeName;
@property (nonatomic,strong) NSString *createName;
@property (nonatomic,strong) NSNumber *isNotStock;
@property (nonatomic,copy)   NSString *segmentString;
@property (nonatomic,copy)   NSString *storageType;
@property (nonatomic,strong) NSString *qualityDirector;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSNumber *saleConvertRatio;
@property (nonatomic,strong) NSString *fileNo;
@property (nonatomic,strong) NSString *createUser;
@property (nonatomic,strong) NSNumber *segmentBD;
@property (nonatomic,strong) NSString *qualityDirectorAuditDate;
@property (nonatomic,strong) NSString *productCode;
@property (nonatomic,copy)   NSString *authorizeNo;
@property (nonatomic,strong) NSNumber *isNetLimitSale;
@property (nonatomic,copy)   NSString *name;
@property (nonatomic,copy)   NSString *mantainCycName;
@property (nonatomic,copy)   NSString *dosageFormCode;
@property (nonatomic,strong) NSString *qualityType;
@property (nonatomic,strong) NSNumber *isInsurance;
@property (nonatomic,strong) NSString *authorizeBeginDate;
@property (nonatomic,strong) NSString *director;
@property (nonatomic,strong) NSNumber *isPrescriptSale;
@property (nonatomic,strong) NSNumber *isDisabled;
@property (nonatomic,strong) NSNumber *isEphedrine;
@property (nonatomic,copy)   NSString *packDesc;
@property (nonatomic,strong) NSString *authorizeOutDate;
@property (nonatomic,strong) NSString *dose;
@property (nonatomic,strong) NSString *producerId;
@property (nonatomic,strong) NSString *projectCode;
@property (nonatomic,copy)   NSString *dosageFormName;
@property (nonatomic,copy)   NSString *barCode;
@property (nonatomic,copy)   NSString *createDate;
@property (nonatomic,strong) NSString *saleUnit;
@property (nonatomic,strong) TestModelDataGiftssGoodsSegmentMap *segmentMap;
@property (nonatomic,strong) NSString *useage;
@property (nonatomic,strong) NSString *qualityManager;
@property (nonatomic,strong) NSString *valiMonth;
@property (nonatomic,strong) NSString *qualityManagerAuditDate;
@property (nonatomic,copy)   NSString *standardCode;
@property (nonatomic,copy) NSArray *segmentList;
@property (nonatomic,strong) NSString *thirdPartyDate;
@property (nonatomic,strong) NSNumber *valiWarnDay;
@property (nonatomic,copy)   NSString *pinyin;
@property (nonatomic,copy)   NSString *modifyName;
@property (nonatomic,strong) NSNumber *isDeptNotSale;
@property (nonatomic,strong) NSString *doseUnitName;
@property (nonatomic,strong) NSNumber *splitRatio;
@property (nonatomic,copy)   NSString *unit;
@property (nonatomic,copy)   NSString *model;
@property (nonatomic,strong) NSNumber *deptId;
@property (nonatomic,copy)   NSString *modifyUser;
@property (nonatomic,copy)   NSString *producerName;
@property (nonatomic,copy)   NSString *genericName;
@property (nonatomic,strong) NSNumber *isLimitSale;
@property (nonatomic,strong) NSString *dosage;
@property (nonatomic,strong) NSNumber *isImport;
@end

@interface TestModelDataGiftssSegmentMap : NSObject
@end

@interface TestModelDataGiftssSegmentList : NSObject
@end

@interface TestModelDataGiftss : NSObject
@property (nonatomic,copy)   NSString *modifyDate;
@property (nonatomic,copy)   NSString *modifyName;
@property (nonatomic,copy)   NSString *modifyUser;
@property (nonatomic,strong) NSNumber *isSpecialSale;
@property (nonatomic,strong) NSString *specialSaleEndDate;
@property (nonatomic,strong) NSNumber *specialSalePrice;
@property (nonatomic,strong) NSNumber *segmentLong;
@property (nonatomic,copy)   NSString *storeName;
@property (nonatomic,strong) NSNumber *segment;
@property (nonatomic,copy) NSArray *segmentList;
@property (nonatomic,strong) NSNumber *deptId;
@property (nonatomic,strong) NSNumber *segmentBD;
@property (nonatomic,strong) TestModelDataGiftssSegmentMap *segmentMap;
@property (nonatomic,strong) NSString *specialSaleBgnDate;
@property (nonatomic,strong) TestModelDataGiftssGoods *goods;
@property (nonatomic,strong) NSNumber *storeId;
@property (nonatomic,strong) NSNumber *id;
@property (nonatomic,strong) NSNumber *isMemberSale;
@property (nonatomic,copy)   NSString *deptName;
@property (nonatomic,strong) NSString *projectCode;
@property (nonatomic,strong) NSNumber *giftSalePrice;
@property (nonatomic,strong) NSNumber *salePrice;
@property (nonatomic,copy)   NSString *createDate;
@property (nonatomic,copy)   NSString *createName;
@property (nonatomic,copy)   NSString *createUser;
@property (nonatomic,strong) NSNumber *isGift;
@property (nonatomic,copy)   NSString *segmentString;
@end

@interface TestModelData : NSObject
@property (nonatomic,strong) NSNumber *discountAmt;
@property (nonatomic,copy) NSArray *giftss;
@property (nonatomic,strong) NSNumber *id;
@property (nonatomic,copy) NSArray *goodsDiscountPriceVoList;
@property (nonatomic,strong) NSNumber *originalAmt;
@property (nonatomic,strong) NSNumber *amt;
@end

@interface TestModel : NSObject
@property (nonatomic,strong) NSNumber *code;
@property (nonatomic,strong) TestModelData *data;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSString *authToken;
@end

