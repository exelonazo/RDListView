//
//  WebViewController.swift
//  ListViews
//
//  Created by Everis on 04-09-17.
//  Copyright © 2017 Felipe. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    var storyUrl:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //We check for internet availability
        if(Reachability.isConnectedToNetwork()){
            //check optional value
            if let unwrappedUrl = storyUrl{
                loadUrl(url: unwrappedUrl)
            }else{
                self.alert(message: "There is an error opening the web page, try again later")
                print("Error unwrapping url")
            }
        }else{
            self.alert(message: "There is no internet connection, please check your ISP")
        }
        
    }
    
    //MARK:- Load Url inside the webView
    func loadUrl(url:String){
        let sUrl = URL(string:url)
        if let unwrapped = sUrl {
            let request = URLRequest(url: unwrapped)
            let session = URLSession.shared
            let task = session.dataTask(with: request){ (data, response, error) in
                
                if error == nil{
                    self.webView.loadRequest(request)
                }else{
                    print(error!)
                    self.alert(message: "There is an error opening the web page, try again later")
                }
            }
            task.resume()
        }
    }

}
