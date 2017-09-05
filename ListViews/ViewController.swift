//
//  ViewController.swift
//  ListViews
//
//  Created by Everis on 04-09-17.
//  Copyright © 2017 Felipe. All rights reserved.
//

import UIKit
import IJProgressView


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private let fetchData = Data()
    private var arrLists:[List] = []
    private var lStoryTitle:String = ""
    private var lAuthor:String = ""
    private var lCreatedAt:String = ""
    private var lStoryUrl:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // We create a dimensional tableView (for dynamic heights)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        //RefreshControl Target
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        //Populate Data
        requestAndPopulateData()
    }
    
    func refreshData(_ sender: Any) {
            refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
            self.arrLists.removeAll()
            self.tableView.reloadData()
            //Populate Data
            requestAndPopulateData()
    }
    
    
    //MARK:- Table View Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath) as! ListCell
        
        cell.storyTitleLabel.text = arrLists[indexPath.row].storyTitle
        
        if let author = arrLists[indexPath.row].author{
            if let createdAt = arrLists[indexPath.row].createdAt{
                if let convertedDate  = createdAt.toDateAndComparingWithCurrentDate(from: createdAt){
                    cell.authorCreatedAt.text = "\(author) - \(convertedDate)"
                }
            }else{ print("error al cargar data") }
        }else{ print("error al cargar data") }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            self.arrLists.remove(at: indexPath.row)
            saveLists()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    
    //MARK: - Preparing for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WebViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            destination.storyUrl = arrLists[indexPath.row].storyUrl
        }
    }
    
    
    //MARK: - Request Data
    func requestAndPopulateData(){
        
        //We show progressView indicator
        IJProgressView.shared.showProgressView(self.view)
        
        //Is there a connection available ?
        if(!Reachability.isConnectedToNetwork()){
            print("There is no internet connection")
            if let fillArrayList = loadLists(){
                self.arrLists = fillArrayList
            }else{
                print("There is no lists in persistence")
                self.alert(message: "There is no data stored")
            }
            IJProgressView.shared.hideProgressView()
        }else{
            print("Internet Available")
            fetchData.requestData(completion: { (JSON) in
                let resLists = JSON["hits"]
                for i in 0 ... resLists.count-1{
                    //Validaciones -unwrapping-
                    if let storyTitle = resLists[i]["story_title"].string{
                        self.lStoryTitle = storyTitle
                    }
                    if let author = resLists[i]["author"].string{
                        self.lAuthor = author
                    }
                    if let createdAt = resLists[i]["created_at"].string{
                        self.lCreatedAt = createdAt
                    }
                    if let storyUrl = resLists[i]["story_url"].string{
                        self.lStoryUrl = storyUrl
                    }
                    
                    let kList = List(storyTitle: self.lStoryTitle,
                                     author: self.lAuthor,
                                     createdAt: self.lCreatedAt,
                                     storyUrl: self.lStoryUrl)
                    
                    
                    self.arrLists.append(kList)
                    
                }
                self.saveLists()
                if (self.refreshControl.isRefreshing){
                    self.refreshControl.endRefreshing()
                }
                self.tableView.reloadData()
                IJProgressView.shared.hideProgressView()
                
            }) { (Error) in
                IJProgressView.shared.hideProgressView()
                self.alert(message: "Error fetching data")
                print("Falló el intento de conexión con servidor")
            }
        }
        if (self.refreshControl.isRefreshing){
            self.refreshControl.endRefreshing()
        }
        self.tableView.reloadData()
        
    }
    
    
    
    //MARK:- Persistence
    private func saveLists() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self.arrLists, toFile: List.ArchiveURL.path)
        if isSuccessfulSave {
            print("List saved")
        } else {
            print("Error saving list")
        }
    }
    private func loadLists() -> [List]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: List.ArchiveURL.path) as? [List]
    }

}


//MARK: - Extension : Alert
extension UIViewController {
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
//MARK: - Extension : Dates
extension String {
    func toDateAndComparingWithCurrentDate(from fromDate: String) -> String? {
        var strDate = ""
        
        //We need to convert the feed's string in date format
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: fromDate)
        
        //After that we are going to set our components to get m/d/h/m/s and get the time differences between dates
        let userCalendar = Calendar.current
        let startTime = Date()
        let requestedComponent: Set<Calendar.Component> = [.month,.day,.hour,.minute,.second]
        let timeDifference = userCalendar.dateComponents(requestedComponent, from: date!, to: startTime)
        
        //When we got timeDifference, we need to know if it is month/day/hrs, etc.
        if(timeDifference.month! > 0){
            strDate = "\(timeDifference.month!)months"
        }else if(timeDifference.day! > 0){
            strDate = "\(timeDifference.day!)days"
        }else if (timeDifference.hour! > 0){
            strDate = "\(timeDifference.hour!)hrs"
        }else if (timeDifference.minute! > 0){
            strDate = "\(timeDifference.minute!)min"
        }else if (timeDifference.second! > 0){
            strDate = "\(timeDifference.second!)sec"
        }

        
        return strDate
    }
}


