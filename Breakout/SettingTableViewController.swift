//
//  SettingTableViewController.swift
//  Breakout
//
//  Created by Patrick Pan on 7/22/15.
//  Copyright (c) 2015 Patrick Pan. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    
    struct settingValues {
        static var numberOfBricks = 50
        static var ballVelocity:CGFloat = 50
        static var lives = 5
        static var enableUpgrades = true
    }
    
    
    @IBOutlet weak var BrickCountLabel: UILabel!
    
    @IBAction func BrickCountSlider(sender: UISlider) {
        let newBrickCount = Int(sender.value*100)
        settingValues.numberOfBricks = newBrickCount
        BrickCountLabel.text = "\(newBrickCount)"
    }
    
    @IBOutlet weak var livesLabel: UILabel!

    @IBAction func lives(sender: UIStepper) {
        livesLabel.text = "\(sender.stepValue)"
    }
    
    @IBOutlet weak var ballVelocityLabel: UILabel!
    
    @IBAction func ballVelocitySlider(sender: UISlider) {
        let newBallVelocityValue = sender.value*100
        settingValues.ballVelocity = CGFloat(newBallVelocityValue)
        ballVelocityLabel.text = "\(Int(newBallVelocityValue))"
    }
    
    
    @IBOutlet weak var upgradeLabel: UILabel!
    @IBAction func upgradeSetter(sender: UISwitch) {
        settingValues.enableUpgrades = !settingValues.enableUpgrades
        println("\(sender.on)")
    }
    
    @IBAction func ApplySetting(sender: UIButton) {
        if let gvc = self.tabBarController?.viewControllers?.first as? GameViewController {
            gvc.livesRemaining = settingValues.lives
            gvc.numberOfBricks = settingValues.numberOfBricks
            gvc.needToResetGame = true
            gvc.ballSpeed = CGFloat(settingValues.ballVelocity/1000)
        }
        self.tabBarController?.selectedIndex = 0
    }


}
