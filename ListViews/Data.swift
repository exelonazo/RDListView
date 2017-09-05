//
//  Data.swift
//  ListViews
//
//  Created by Everis on 04-09-17.
//  Copyright © 2017 Felipe. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

class Data{
    func requestData(completion: @escaping (JSON) -> Void, failed: @escaping (Error) -> Void){
        Alamofire.request(Constants.NetworkConstans.API_URL, method: .get).responseData { (dataResponse) in
            if dataResponse.result.isSuccess{
                completion(JSON(dataResponse.result.value!))
            }else{
                failed(dataResponse.error!)
            }
        }
    }
}

