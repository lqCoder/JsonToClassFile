//
//  AppDelegate.m
//  JsToClassFile
//  Created by li qiao  on 16/1/5.
//  Copyright © 2016年 apple. All rights reserved.
//注意: 转成的类文件的建立格式与MJExtension第三方框架数据生成的格式相同，最好与MJExtension配套使用。我把转换的大体思路写出来了，我用的是MJExtension旧版本，MJExtension新版本的一些数据转换的地方变了，现在这个就不适用了。我就需要使用着看懂我的代码自己修改了。

#import "AppDelegate.h"
#import "CreateFileModel.h"
#import "JSONKit.h"
#import "MJExtension.h"
#import "TestModel.h"

@interface AppDelegate ()<NSTextViewDelegate>
@property (weak) IBOutlet NSTextField* classText;
@property (weak) IBOutlet NSWindow* window;

@property (weak) IBOutlet NSScrollView *textScrollView;
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (nonatomic,strong) NSProgressIndicator *indicator;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification*)aNotification
{
    self.textView.delegate = self;
//    NSTextView解决不管是在中文还是英文输入状态下，输入的引号怎么都是中文的问题
    self.textView.automaticQuoteSubstitutionEnabled = NO;
    self.textView.textColor = [NSColor blackColor];
    self.classText.font = [NSFont systemFontOfSize:18 weight:NSFontWeightBold];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.json" ofType:nil];
//    NSString *jsonStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    TestModel *model = [TestModel mj_objectWithKeyValues:jsonStr.mj_JSONObject];
//    NSLog(@"%@",model);
    self.indicator = [[NSProgressIndicator alloc] initWithFrame:CGRectMake(self.textScrollView.bounds.size.width/2.0 - 25, self.textScrollView.bounds.size.height/2.0 - 25, 50, 50)];
    self.indicator.style = NSProgressIndicatorStyleSpinning;
    self.indicator.displayedWhenStopped = NO;
    [self.textScrollView addSubview:self.indicator];
}

//解决command+w关闭应用程序窗口之后 再次点击图标无法唤起应用的bug
- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    if(flag) return NO;
    [self.window makeKeyAndOrderFront:self];
    return YES;
}

#pragma mark - NSTextViewDelegate
- (void)textDidChange:(NSNotification *)notification {
//    self.textView.textColor = [NSColor blackColor];
}

- (IBAction)createClassFile:(id)sender
{
    //开启菊花
    [self startProgress];
//    NSTextView* jsonTextView=(NSTextView*)self.textScrollView.contentView.documentView;
    NSTextView* jsonTextView = self.textView;
    __block NSString* jsonStr=jsonTextView.textStorage.string;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        jsonStr = [self removeAnnotationString:jsonStr];
        
        NSDictionary* dic = [self GetDictionaryWithJson:jsonStr];
        if (dic == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopProgress];
                NSAlert *alert = [[NSAlert alloc] init];
                alert.messageText = @"JSON格式错误";
                alert.informativeText = @"请检查之后再试!";
                [alert beginSheetModalForWindow:self.window completionHandler:nil];
            });
            return;
        }
        if ([dic isKindOfClass:[NSArray class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopProgress];
                NSAlert *alert = [[NSAlert alloc] init];
                alert.messageText = @"不是字典型的JSON";
                alert.informativeText = @"请不要在最外层使用Array!";
                [alert beginSheetModalForWindow:self.window completionHandler:nil];
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *className = self.classText.stringValue;
            if (className==nil||className.length<1) {
                className=@"lqClass";
            }
            className=[self stringToClassName:className];
            NSArray* keyArray = [dic allKeys];

            NSMutableArray* createFileModelArray = [[NSMutableArray alloc] init];
            [self ergodicMethod:keyArray dataSourceDic:dic className:className createFileModelArray:createFileModelArray];
            [self createJsonModelFily:createFileModelArray classFileName:className];
            [self stopProgress];
        });
    });
}

- (void)startProgress {
    self.textView.editable = NO;
    self.textView.selectable = NO;
    self.classText.editable = NO;
    [self.indicator startAnimation:nil];
}

- (void)stopProgress {
    self.textView.editable = YES;
    self.textView.selectable = YES;
    self.classText.editable = YES;
    [self.indicator stopAnimation:nil];
}

//移除注释字符串
- (NSString *)removeAnnotationString:(NSString *)originalStr {
//    有问题不能这样操作 比如json字符串中含有https://有不行了
    NSRange range = [originalStr rangeOfString:@"//"];
    if(range.location != NSNotFound){
        NSRange lineEndRange = [originalStr rangeOfString:@"\n" options:0 range:NSMakeRange(range.location, originalStr.length - range.location)];
        originalStr = [originalStr stringByReplacingCharactersInRange:NSMakeRange(range.location, lineEndRange.location - range.location) withString:@""];
        return [self removeAnnotationString:originalStr];
    }else{
        return originalStr;
    }
}

- (void)ergodicMethod:(NSArray*)keyArray dataSourceDic:(NSDictionary*)dic className:(NSString*)className createFileModelArray:(NSMutableArray*)createFileModelArray
{
    ClassModel* createFileModel = [[ClassModel alloc] init];
    createFileModel.myClassName = className;
    createFileModel.fieldsArray = [[NSMutableArray alloc] init];
    [createFileModelArray addObject:createFileModel];

    for (int i = 0; i < keyArray.count; i++) {
        id key = [keyArray objectAtIndex:i];
        id value = [dic objectForKey:key];
        
        PropertyModel* fieldsModel = [[PropertyModel alloc] init];
        fieldsModel.keyObject = key;
        fieldsModel.valueObject = value;
        
        key=[self stringToClassName:key];

        if ([value isKindOfClass:[NSDictionary class]]) {
            NSDictionary* dicChild = (NSDictionary*)value;
            NSArray* dicChildKeyArray = [dicChild allKeys];
//            NSString* tempClassName = [NSString stringWithFormat:@"%@Child", key];
            NSString* tempClassName=[NSString stringWithFormat:@"%@%@",className,key];

            fieldsModel.convertString=tempClassName;
            [self ergodicMethod:dicChildKeyArray dataSourceDic:dicChild className:tempClassName createFileModelArray:createFileModelArray];
        }
        else if ([value isKindOfClass:[NSArray class]]) {
            NSArray* tempArray = (NSArray*)value;

            if (tempArray.count > 0) {
                id arrayValue = tempArray[0];
                if ([arrayValue isKindOfClass:[NSDictionary class]]) {
                    
                    NSDictionary* dicChild = (NSDictionary*)arrayValue;
                    NSArray* dicChildKeyArray = [dicChild allKeys];
//                    NSString* tempClassName = [NSString stringWithFormat:@"%@Child", key];
                    NSString* tempClassName = [NSString stringWithFormat:@"%@%@",className,key];

                    fieldsModel.convertString = tempClassName;
                    
                    [self ergodicMethod:dicChildKeyArray dataSourceDic:dicChild className:tempClassName createFileModelArray:createFileModelArray];
                }
            }else{
//                fieldsModel.convertString=[NSString stringWithFormat:@"%@Child", key];
                fieldsModel.convertString=[NSString stringWithFormat:@"%@%@",className,key];
                
                ClassModel* emptyArrayCreateFileModel = [[ClassModel alloc] init];
                emptyArrayCreateFileModel.myClassName = fieldsModel.convertString;
                emptyArrayCreateFileModel.fieldsArray = [[NSMutableArray alloc] init];
                [createFileModelArray addObject:emptyArrayCreateFileModel];
            }
        }

        [createFileModel.fieldsArray addObject:fieldsModel];
    }
}

-(void)createJsonModelFily:(NSMutableArray*)createFileModelArray classFileName:(NSString*)className{
    NSString* pointHFileStr = [NSString stringWithFormat:@"//  Created by li qiao robot \r\n#import <Foundation/Foundation.h>\r\n"];
//    NSString* pointHFileStr = [NSString stringWithFormat:@"//  Created by li qiao robot \r\n#import \"BaseResponseData.h\"\r\n"];
    NSString* pointMFileStr = [NSString stringWithFormat:@"//  Created by li qiao robot \r\n#import \"%@.h\" \r\n",className];
    for (NSInteger i=createFileModelArray.count-1;i>=0;i--) {
        ClassModel* createFileModel =[createFileModelArray objectAtIndex:i];
        pointHFileStr = [pointHFileStr stringByAppendingString:[NSString stringWithFormat:@"@interface %@ : NSObject\r\n", createFileModel.myClassName]];
        pointMFileStr = [pointMFileStr stringByAppendingString:[NSString stringWithFormat:@"@implementation %@\r\n", createFileModel.myClassName]];
        
        NSString* convertString=nil;
        for (PropertyModel* fieldsModel in createFileModel.fieldsArray) {
            NSString* fileStr;
            if ([fieldsModel.valueObject isKindOfClass:[NSString class]]) {
                fileStr = [NSString stringWithFormat:@"@property (nonatomic,copy)   NSString *%@;\r\n", fieldsModel.keyObject];
            }
            else if ([fieldsModel.valueObject isKindOfClass:[NSNumber class]]) {
                fileStr = [NSString stringWithFormat:@"@property (nonatomic,strong) NSNumber *%@;\r\n", fieldsModel.keyObject];
            }
            else if ([fieldsModel.valueObject isKindOfClass:[NSArray class]]) {
                fileStr = [NSString stringWithFormat:@"@property (nonatomic,copy)   NSArray%@ *%@;\r\n", fieldsModel.convertString ? [NSString stringWithFormat:@"<%@ *>",fieldsModel.convertString]:@"<NSString *>",fieldsModel.keyObject];
                
                NSLog(@"fieldsModel.convertString:%@",fieldsModel.convertString);
                if (convertString) {
                    convertString=[NSString stringWithFormat:@"%@,@\"%@\" : [%@ class]",convertString,fieldsModel.keyObject,fieldsModel.convertString!=nil?fieldsModel.convertString:@"NSString"];
                }else{
                    convertString=[NSString stringWithFormat:@"+ (NSDictionary *)mj_objectClassInArray{  \r\n       return @{ @\"%@\" : [%@ class] ", fieldsModel.keyObject,fieldsModel.convertString!=nil?fieldsModel.convertString:@"NSString"];
                }
                //                NSString* convertStr = [NSString stringWithFormat:@"-(NSDictionary*)objectClassInArray{  \r\n       return @{ @\"%@\" : [%@ class] }; \r\n}\r\n", fieldsModel.keyObject, fieldsModel.convertString];
                //                pointMFileStr = [pointMFileStr stringByAppendingString:convertStr];
            }
            else {
                if (fieldsModel.convertString) {
                    fileStr = [NSString stringWithFormat:@"@property (nonatomic,strong) %@ *%@;\r\n",fieldsModel.convertString, fieldsModel.keyObject];
                }else{
                    fileStr = [NSString stringWithFormat:@"@property (nonatomic,copy)   NSString *%@;\r\n", fieldsModel.keyObject];
                }
            }
            
            pointHFileStr = [pointHFileStr stringByAppendingString:fileStr];
        }
        if (convertString) {
            convertString=[convertString stringByAppendingString:@"}; \r\n}\r\n"];
            pointMFileStr = [pointMFileStr stringByAppendingString:convertString];
        }
        
        NSLog(@"model.myClassName:%@", createFileModel.myClassName);
        pointHFileStr = [pointHFileStr stringByAppendingString:@"@end\r\n\r\n"];
        pointMFileStr = [pointMFileStr stringByAppendingString:@"@end\r\n\r\n"];
    }
    
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseDirectories = YES;
    panel.canChooseFiles = NO;
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if(result == 0) return ;
        NSString* path = [panel.URL path];
        [pointHFileStr writeToFile:[NSString stringWithFormat:@"%@/%@.h",path,className] atomically:NO encoding:NSUTF8StringEncoding error:nil];
        [pointMFileStr writeToFile:[NSString stringWithFormat:@"%@/%@.m",path,className] atomically:NO encoding:NSUTF8StringEncoding error:nil];
    }];
}

-(NSString*)stringToClassName:(NSString*)string{//字符串转换为类名，规则为第一个字母大写
    NSString* oneString=[[string substringWithRange:NSMakeRange(0, 1)] uppercaseString];
    NSString* fromOneString=[string substringFromIndex:1];
    string=[oneString stringByAppendingString:fromOneString];
    return string;
}

- (NSDictionary*)GetDictionaryWithJson:(NSString*)jsonStr
{
    return [jsonStr objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
}

- (void)applicationWillTerminate:(NSNotification*)aNotification
{
    // Insert code here to tear down your application
}

@end
