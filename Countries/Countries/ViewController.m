//
//  ViewController.m
//  Countries
//
//  Created by TOM on 5/6/13.
//  Copyright (c) 2013 TOM. All rights reserved.
//

#import "ViewController.h"
#import "Wiki.h"

@interface ViewController ()
{
    NSDictionary* _mainDictionary;
    NSArray* _area ;
    BOOL sortedByName;
    BOOL sortedByDetail;
    NSMutableArray* _countriesArray;
    
    int count;
    
}
@property (strong,nonatomic) UISegmentedControl* segmentedControl;
@end

@implementation ViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"];
    _mainDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    _area =[_mainDictionary allKeys];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"sortByName",@"sortByDetail"]];
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [self.segmentedControl addTarget:self action:@selector(sorted) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentedControl;
    
    count=0;

}

-(void) sorted {
    int index = self.segmentedControl.selectedSegmentIndex;
    if (index==0) {
        sortedByName = YES;
        sortedByDetail = NO;
        [self.tableView reloadData];
        NSLog(@"0");
    }
    if (index==1) {
        NSLog(@"1");
        sortedByDetail = YES;
        sortedByName = NO;
        [self.tableView reloadData];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _area[section];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    return _area.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* _countriesArrays =[[NSMutableArray alloc] initWithArray: [[_mainDictionary objectForKey:_area[section]] allKeys]];
    return _countriesArrays.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    int row = indexPath.row;
    int section = indexPath.section;
    
    _countriesArray =[[NSMutableArray alloc] initWithArray: [[_mainDictionary objectForKey:_area[section]] allKeys]];
    cell.textLabel.text = _countriesArray[row];
    
    UIImage* flag = [UIImage imageNamed:[[[_mainDictionary objectForKey:_area[section]] objectForKey:_countriesArray[row]] objectForKey:@"flag" ]];
    cell.imageView.image = flag;
    
    NSNumber* detail = [[[_mainDictionary objectForKey:_area[section]] objectForKey:_countriesArray[row]] objectForKey:@"detail"];
    cell.detailTextLabel.text = detail.stringValue;
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    if (sortedByName == YES) {
        NSArray* array = [[NSArray alloc] initWithArray:_countriesArray];
        NSArray* sortedArray = [array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        _countriesArray = [[NSMutableArray alloc] initWithArray:sortedArray];
        cell.textLabel.text = _countriesArray[row];
        NSNumber* detail = [[[_mainDictionary objectForKey:_area[section]] objectForKey:_countriesArray[row]] objectForKey:@"detail"];
        cell.detailTextLabel.text = detail.stringValue;
        UIImage* flag = [UIImage imageNamed:[[[_mainDictionary objectForKey:_area[section]] objectForKey:_countriesArray[row]] objectForKey:@"flag" ]];
        cell.imageView.image = flag;

    }
    
    if (sortedByDetail == YES) {
        NSMutableArray* detailArray = [[NSMutableArray alloc] init];
        for (int i=0; i<_countriesArray.count;i++) {
            NSNumber* detail = [[[_mainDictionary objectForKey:_area[section]] objectForKey:_countriesArray[i]] objectForKey:@"detail"];
            [detailArray addObject:detail];
        }
        NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
        [detailArray sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
        
        NSMutableArray* sortedArray = [[NSMutableArray alloc] init];
       
        for (int i=0; i<detailArray.count; i++) {
            for(NSString* dicName in [[_mainDictionary objectForKey:_area[section]] allKeys])
            {
                if ([[[_mainDictionary objectForKey:_area[section]]objectForKey:dicName] objectForKey:@"detail"] == detailArray[i]) {
                    [sortedArray addObject:dicName];
                }
                
            }

        }
        
        _countriesArray = [[NSMutableArray alloc] initWithArray:sortedArray];
        cell.textLabel.text = _countriesArray[row];
        NSNumber* detail = [[[_mainDictionary objectForKey:_area[section]] objectForKey:_countriesArray[row]] objectForKey:@"detail"];
        cell.detailTextLabel.text = detail.stringValue;
        UIImage* flag = [UIImage imageNamed:[[[_mainDictionary objectForKey:_area[section]] objectForKey:_countriesArray[row]] objectForKey:@"flag" ]];
        cell.imageView.image = flag;

    }

    return cell;
}
-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    Wiki* _wiki = [[Wiki alloc] initWithNibName:@"Wiki" bundle:nil];
    _wiki.link = [[[_mainDictionary objectForKey:_area[indexPath.section]] objectForKey:_countriesArray[indexPath.row]] objectForKey:@"wiki"];
    [self.navigationController pushViewController:_wiki animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end

