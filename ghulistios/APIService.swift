//
//  APIservice.swift
//  ghulistios
//
//  Created by f4ni on 13.12.2020.
//

import Foundation
import UIKit

class APIService: NSObject {
    
    var since = Int(0) {
        didSet{
            
        }
    }

    lazy var apiUrl: String = {
        return "https://api.github.com/users?since=\(self.since)"
    }()

    func getUserDetail(user: String?, completion: @escaping (Result<[String: AnyObject]>) -> Void) {
            
        
        
            //let urlString = "https://api.github.com/users/\(user ?? "")"
        let urlString = "https://api.github.com/users/\(user ?? "")"


            guard let url = URL(string: urlString) else { return completion(.Error("Invalid URL, we can't update your feed")) }


            URLSession.shared.dataTask(with: url) { (dat, response, error) in
                
             guard error == nil else { return completion(.Error(error!.localizedDescription)) }
                guard let data = dat else { return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))}
                
                do {
                    let json = try ( JSONSerialization.jsonObject(with: data, options: .allowFragments)) as! [String: AnyObject]
                    let usr = User()
                    //let json = try JSONDecoder.init().decode(UserDetail.self, from: data)
                    print("**********************")
                    //usr.setValuesForKeys(json)
                    DispatchQueue.main.async {
                                                completion(.Success(json))
                                            }

                    /*
                    if let udata = try? JSONDecoder().decode(UserDetail.self, from: data)
                    {
                        print(udata.avatar_url)
                        
                    }
                    //if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                        //print(json)
                        //guard let itemsJsonArray = json as? [String: AnyObject] else {
                        //    return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
                        //}
                        
                    //}
 */
                } catch let error {
                    print("error json \(error.localizedDescription)")
                    return completion(.Error(error.localizedDescription))
                }
                }.resume()
        }
    func getUserList(since: Int = 0, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        
        let urlString = "https://api.github.com/users?since=\(since)"

        
        print(urlString)
        
        guard let url = URL(string: urlString) else { return completion(.Error("Invalid URL, we can't update your feed")) }


        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
         guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
}
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [[String: AnyObject]] {
                    //print(json)
                    guard let itemsJsonArray = json as? [[String: AnyObject]] else {
                        return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
                    }
                    DispatchQueue.main.async {
                        completion(.Success(itemsJsonArray))
                    }
                }
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
            }.resume()
    }
}

enum Result<T> {
    case Success(T)
    case Error(String)
}





