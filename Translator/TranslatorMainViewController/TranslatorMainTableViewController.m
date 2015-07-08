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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"MainTableViewController_title", nil);
    [self.tableView registerNib:[UINib nibWithNibName:@"TranslatorHeaderTableViewCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:TRANSLATOR_HEADER_FIELD];
    [self.appController getLanguageData:^(NSArray *array, NSError *error) {
        self.languages = array;
    }];
    self.page = 0;
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
            cell.fromPicker.pickerDataSource = self;
            cell.fromPicker.pickerDelegate = self;
            cell.fromPicker.tag = 0;
            self.fromPicker = cell.fromPicker;
            [self setDefaultChoice:self.fromPicker];
            cell.toPicker.pickerDataSource = self;
            cell.toPicker.pickerDelegate = self;
            cell.toPicker.tag = 1;
            self.toPicker = cell.toPicker;
            [self setDefaultChoice:self.toPicker];
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
            cell.textLabel.text = NSLocalizedString(@"VenueTableView_loading", nil);
            return cell;
        }
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0 && indexPath.row==0)
        return 100;
    else
        return 40;
    
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
    Language *language = [self.languages objectAtIndex:0];
    picker.text = language.languageName;
    picker.selectedRow = 0;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
