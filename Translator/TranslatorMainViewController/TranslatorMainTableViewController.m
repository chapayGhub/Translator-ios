//
//  TranslatorMainTableViewController.m
//  Translator
//
//  Created by Kevin Mun Kuang Tzer on 7/7/15.
//  Copyright (c) 2015 Kevin Mun Kuang Tzer. All rights reserved.
//

#import "TranslatorMainTableViewController.h"
#import "UIViewController+AppController.h"
#import "TranslatorHeaderTableViewCell.h"
static NSString *const TRANSLATOR_HEADER_FIELD = @"TranslatorHeaderField";
@interface TranslatorMainTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet PickerTextField *fromPicker;
@property (weak, nonatomic) IBOutlet PickerTextField *toPicker;
@property (weak, nonatomic) IBOutlet UIButton *inverseButton;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL allLoaded;
@property (nonatomic, assign) BOOL sentLoad;
@property (nonatomic, strong) NSString *currentPhrase;
@property (nonatomic, strong) Language *fromLanguage;
@property (nonatomic, strong) Language *toLanguage;
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) NSArray *languages;
@end

@implementation TranslatorMainTableViewController
static int PER_PAGE = 30;
static NSString* templateWikiLink = @"http://%@.wikipedia.org/wiki/%@";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"MainTableViewController_title", nil);
    [self.tableView registerNib:[UINib nibWithNibName:@"TranslatorHeaderTableViewCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:TRANSLATOR_HEADER_FIELD];
    [self.appController getLanguageData:^(NSArray *array, NSError *error) {
        self.languages = array;
    }];
    self.page = 0;
    self.results = [[NSMutableArray alloc]init];
    self.isLoading = FALSE;
    self.allLoaded = FALSE;
    self.sentLoad = FALSE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(instancetype)initWithAppController:(id<AppController>)appController{
    self = [super init];
    if(self){
        [self setAppController:appController];
    }
    return self;
}

-(void) loadTranslations:(NSString*)phrase from:(Language*)fromLanguage to:(Language*)toLanguage page:(int)page{
    self.page = page;
    self.isLoading = TRUE;
    __weak typeof(self)weakSelf = self;
    [self.appController getTranslationResult:self.currentPhrase from:fromLanguage to:toLanguage
                                        page:self.page pageSize:PER_PAGE completion:^(TranslationResultList * resultList, NSError *error) {
                                            if(error == nil){
                                                if([resultList.results count]>0){
                                                    [weakSelf.results addObjectsFromArray:resultList.results];
                                                } else {
                                                    weakSelf.allLoaded = TRUE;
                                                }
                                                [weakSelf.tableView reloadData];
                                            } else {
                                                NSLog(@"%@",error);
                                            }
                                            weakSelf.isLoading = FALSE;
                                        }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    } else {
        if(self.allLoaded || !self.sentLoad)
            return [self.results count];
        else
            return [self.results count]+1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        if(indexPath.row ==0){
            TranslatorHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TRANSLATOR_HEADER_FIELD forIndexPath:indexPath];
            [cell.searchButton addTarget:self action:@selector(startSearch) forControlEvents:UIControlEventTouchUpInside];
            self.searchTextField = cell.searchTextField;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if(self.fromPicker==nil){
                cell.fromPicker.pickerDataSource = self;
                cell.fromPicker.pickerDelegate = self;
                cell.fromPicker.tag = 0;
                self.fromPicker = cell.fromPicker;
                [self setDefaultChoice:self.fromPicker];
            }
            
            if(self.toPicker == nil){
                cell.toPicker.pickerDataSource = self;
                cell.toPicker.pickerDelegate = self;
                cell.toPicker.tag = 1;
                self.toPicker = cell.toPicker;
                [self setDefaultChoice:self.toPicker];
            }
            
            if(self.inverseButton == nil){
                self.inverseButton = cell.inverseButton;
                [self.inverseButton addTarget:self action:@selector(inverseSelection) forControlEvents:UIControlEventTouchUpInside];
            }
            
            return cell;
        }
        return nil;
    } else {
        if([self.results count] == indexPath.row && self.sentLoad){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell"];
            if(cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MoreCell"];
            }
            UIActivityIndicatorView *activityView =
            [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [activityView startAnimating];
            [cell setAccessoryView:activityView];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = NSLocalizedString(@"TranslationTableView_loading", nil);
            if (!self.allLoaded && !self.isLoading) {
                self.page += 1;
                __weak typeof(self)weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf loadTranslations:weakSelf.currentPhrase from:weakSelf.fromLanguage to:weakSelf.toLanguage page:weakSelf.page];
                });
            }
            return cell;
        }
        TranslationResult *result = [self.results objectAtIndex:indexPath.row];
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ResultCell"];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ResultCell"];
        }
        cell.textLabel.text = result.translatedPhrase;
        cell.detailTextLabel.text = result.meaning;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 1)];
        view.backgroundColor = [UIColor grayColor];
        [cell addSubview:view];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0 && indexPath.row==0)
        return 100;
    else
        return 40;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section!=0){
        if(indexPath.row < [self.results count]){
            TranslationResult *result = [self.results objectAtIndex:indexPath.row];
            if(result!=nil){
                if([result.translatedPhrase length]>0){
                    NSString *link = [NSString stringWithFormat:templateWikiLink,result.translatedLanguage,result.translatedPhrase];
                    link = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: link]];
                }
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) startSearch{
    if([self.searchTextField.text length] >0){
        self.sentLoad = TRUE;
        self.page = 0;
        self.currentPhrase = self.searchTextField.text;
        [self.results removeAllObjects];
        [self.tableView reloadData];
        self.fromLanguage = [self.languages objectAtIndex:self.fromPicker.selectedRow];
        self.toLanguage = [self.languages objectAtIndex:self.toPicker.selectedRow];
        
        [self loadTranslations:self.currentPhrase from:self.fromLanguage to:self.toLanguage page:self.page];
    }
}

-(void) inverseSelection{
    int fromSelectedRow = self.fromPicker.selectedRow;
    int toSelectedRow = self.toPicker.selectedRow;
    
    [self setPickerChoice:self.fromPicker choice:toSelectedRow];
    [self setPickerChoice:self.toPicker choice:fromSelectedRow];
}

#pragma mark UI Picker data Source

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.languages count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Language *language = [self.languages objectAtIndex:row];
    return language.languageName;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    Language *language = [self.languages objectAtIndex:row];
    if(pickerView.tag ==0){
        self.fromPicker.text = language.languageName;
        self.fromPicker.selectedRow = (int)row;
    }else{
        self.toPicker.text = language.languageName;
        self.toPicker.selectedRow = (int)row;
    }
}

-(void)setDefaultChoice:(PickerTextField*)picker{
    [self setPickerChoice:picker choice:0];
}

-(void) setPickerChoice:(PickerTextField*)picker choice:(int)choice{
    Language *language = [self.languages objectAtIndex:choice];
    picker.text = language.languageName;
    picker.selectedRow = choice;
}

@end
