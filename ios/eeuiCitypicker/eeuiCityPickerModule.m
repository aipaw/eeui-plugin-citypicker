#import "eeuiCityPickerModule.h"
#import "DeviceUtil.h"
#import <WeexPluginLoader/WeexPluginLoader.h>

@interface eeuiCityPickerModule () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSString *provience;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *area;

@property (nonatomic, strong) NSMutableArray *provienceList;
@property (nonatomic, strong) NSMutableArray *cityList;
@property (nonatomic, strong) NSMutableArray *areaList;

@property (nonatomic, strong) UIControl *cityView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, assign) BOOL areaOther;

@property (nonatomic, copy) WXModuleKeepAliveCallback callback;

@end

@implementation eeuiCityPickerModule

WX_PlUGIN_EXPORT_MODULE(eeuiCitypicker, eeuiCityPickerModule)
WX_EXPORT_METHOD(@selector(select:callback:))

- (void)select:(NSDictionary*)params callback:(WXModuleKeepAliveCallback)callback
{
    UIViewController *vc = [DeviceUtil getTopviewControler];
    [vc.view endEditing:YES];

    self.callback = callback;

    if (params && [params isKindOfClass:[NSDictionary class]]) {
        _areaOther = [params[@"areaOther"] boolValue];
    }

    [self loadData];

    [self loadUI];

    [self loadText:params];
}


- (void)loadData
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"city" ofType:@"json"];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableLeaves error:nil];

    _provienceList = [NSMutableArray arrayWithArray:array];

    if (_areaOther == YES) {
        [self addAreaOther];
    }

    _cityList = [NSMutableArray arrayWithArray:_provienceList.firstObject[@"cityList"]];
    _areaList = [NSMutableArray arrayWithArray:_cityList.firstObject[@"cityList"]];

    if (_provience.length == 0) {
        _provience = _provienceList.firstObject[@"name"];
    }

    if (_city.length == 0) {
        _city = _cityList.firstObject[@"name"];
    }

    if (_area.length == 0) {
        _area = _areaList.firstObject[@"name"];
    }
}

- (void)addAreaOther
{
    for (int i = 0; i < _provienceList.count; i++)
    {
        NSMutableDictionary *cityObject = [NSMutableDictionary dictionaryWithDictionary:_provienceList[i]];
        NSMutableArray *cityList = [NSMutableArray arrayWithArray:cityObject[@"cityList"]];
        for (int j = 0; j < cityList.count; j++)
        {
            NSMutableDictionary *areaObject = [NSMutableDictionary dictionaryWithDictionary:cityList[j]];
            NSMutableArray *areaList = [NSMutableArray arrayWithArray:areaObject[@"cityList"]];
            [areaList addObject:@{@"id":@(-1), @"lat":@(-1), @"lng":@(-1), @"name":@"其它区"}];
            [areaObject setValue:areaList forKey:@"cityList"];
            [cityList replaceObjectAtIndex:j withObject:areaObject];
        }
        [cityObject setValue:cityList forKey:@"cityList"];
        [_provienceList replaceObjectAtIndex:i withObject:cityObject];
    }
}

- (void)reloadCityData
{
    if (_provience.length == 0) {
        _cityList = _provienceList.firstObject;
    } else {
        for (NSDictionary* dic in _provienceList) {
            if ([dic[@"name"] isEqualToString:_provience]) {
                _cityList = dic[@"cityList"];
                break;
            }
        }
    }
}

- (void)reloadAreaData
{
    if (_city.length == 0) {
        _areaList = _cityList.firstObject;
    } else {
        for (NSDictionary* dic in _cityList) {
            if ([dic[@"name"] isEqualToString:_city]) {
                _areaList = dic[@"cityList"];
                break;
            }
        }
    }
}

- (void)loadUI
{
    _cityView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _cityView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [_cityView addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:_cityView];

    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 240)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_cityView addSubview:_bgView];

    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bgView.frame.size.width, 40)];
    toolView.backgroundColor = [UIColor whiteColor];
    toolView.layer.borderWidth = 0.5f;
    toolView.layer.borderColor = [UIColor lightTextColor].CGColor;
    [_bgView addSubview:toolView];

    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 60, 40);
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:cancelBtn];

    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(_bgView.frame.size.width - 60, 0, 60, 40);
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    confirmBtn.backgroundColor = [UIColor clearColor];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:confirmBtn];

    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, _bgView.frame.size.width, 200)];
    _pickerView.backgroundColor = [UIColor clearColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_bgView addSubview:_pickerView];

    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = ws.bgView.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - 240;
        ws.bgView.frame = frame;
    }];
}

- (void)loadText:(NSDictionary*)parmars
{
    if (parmars && [parmars isKindOfClass:[NSDictionary class]]) {
        _provience = parmars[@"province"];
        _city = parmars[@"city"];
        _area = parmars[@"area"];

        if (_provience == nil) _provience = _provienceList.firstObject[@"name"];
        if (_city == nil) _city = _cityList.firstObject[@"name"];
        if (_area == nil) _area = _areaList.firstObject[@"name"];

        for (int i = 0; i < _provienceList.count; i++) {
            NSDictionary *dic = _provienceList[i];
            if ([dic[@"name"] isEqualToString:_provience]) {
                _cityList = dic[@"cityList"];
                [_pickerView reloadComponent:1];
                [_pickerView selectRow:i inComponent:0 animated:NO];
                break;
            }
        }

        for (int i = 0; i < _cityList.count; i++) {
            NSDictionary *dic = _cityList[i];
            if ([dic[@"name"] isEqualToString:_city]) {
                _areaList = dic[@"cityList"];
                [_pickerView reloadComponent:2];
                [_pickerView selectRow:i inComponent:1 animated:NO];
                break;
            }
        }

        for (int i = 0; i < _areaList.count; i++) {
            NSDictionary *dic = _areaList[i];
            if ([dic[@"name"] isEqualToString:_area]) {
                [_pickerView selectRow:i inComponent:2 animated:NO];
                break;
            }
        }
    }
}

#pragma mark action
- (void)cancelClick
{
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = ws.bgView.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        ws.bgView.frame = frame;
    } completion:^(BOOL finished) {
        [ws.cityView removeFromSuperview];
    }];
}

- (void)confirmClick
{
    if (self.callback) {
        self.callback(@{@"province":_provience, @"city":_city, @"area":_area}, YES);
    }

    [self cancelClick];
}

#pragma mark pickView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _provienceList.count;
    } else if (component == 1) {
        return _cityList.count;
    } else {
        return _areaList.count;
    }
}

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;

    if (component == 0) {
        if (row < _provienceList.count) {
            label.text = _provienceList[row][@"name"];
        }
    } else if (component == 1) {
        if (row < _cityList.count) {
            label.text = _cityList[row][@"name"];
        }
    } else {
        if (row < _areaList.count) {
            label.text = _areaList[row][@"name"];
        }
    }

    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        if (row < _provienceList.count) {
            _cityList = [NSMutableArray arrayWithArray:_provienceList[row][@"cityList"]];
            _provience = _provienceList[row][@"name"];
        }

        [self reloadCityData];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];

        [self reloadAreaData];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];

        [self pickerView:pickerView didSelectRow:0 inComponent:1];
    } else if (component == 1) {
        if (row < _cityList.count) {
            _areaList = [NSMutableArray arrayWithArray:_cityList[row][@"cityList"]];
            _city = _cityList[row][@"name"];
        }
        [self reloadAreaData];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];

        [self pickerView:pickerView didSelectRow:0 inComponent:2];
    } else if (component == 2) {
        if (row < _areaList.count) {
            _area = _areaList[row][@"name"];
        }
    }
}

@end
