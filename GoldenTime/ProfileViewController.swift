//
//  ProfileViewController.swift
//  GoldenTime
//
//  Created by ramy nasser on 6/27/17.
//  Copyright © 2017 RamyNasser. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {

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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FirstProfileCell", for: indexPath) as! FirstProfileCell
            
            
            cell.NameLabel.text = "محمد احمد ابراهيم "
            cell.ProfileImage.image = UIImage(named: "default_male")

        // Configure the cell...

        return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SecondProfileCell", for: indexPath) as! SecondProfileCell
            
            cell.EmailLabel.text = "RamyNasser95@gmail.com"
            //text = "+01008096926"
            cell.MobileLabel.setTitle("+01008096926", for: .normal)
            cell.TeleLabel.text = "+3366162"
            cell.LocationLabel.text = "البحري بجوار محلات  السلام    البحري بجوار محلات  السلام البحري بجوار محلات  السلامالبحري بجوار لام"
            return cell
            

        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
        return 354
        
        }
        else {
        return 221
        }
    }
    

//354
    //221
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
