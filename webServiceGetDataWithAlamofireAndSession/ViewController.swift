//
//  ViewController.swift
//  webServiceGetDataWithAlamofireAndSession
//
//  Created by iFlame on 10/6/17.
//  Copyright © 2017 iflame. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var TableView: UITableView!
    
    var arr = [[String:Any]]()
    
    // Session
    let urlSession = URLSession(configuration: .default)
    var dataTask = URLSessionDataTask()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Get Data With Alamofire
//        callGetMethodAlamofire()
        
        // Get Data With Session
        callGetMethodSession()
    }
    
    
    // MARK : - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! Mycell
        var array = arr[indexPath.row]
        cell.Lbl1.text = array["name"] as? String
        cell.Lbl2.text = array["gender"] as? String
        return cell
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK : - Get Data With Alamofire
    func callGetMethodAlamofire()
    {
        // Start Indicator
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        Alamofire.request("https://api.androidhive.info/contacts/",method:.get).responseJSON {
            response in
            switch response.result
            {
                case .success(let obj):
                    print(obj)
                    if let json = response.result.value as? [String:Any]
                    {
                        print(json)
                        if let jsonData = json["contacts"] as? [Any]
                        {
                            print(jsonData)
                            self.arr = jsonData as! [[String:Any]]
                            print(self.arr)
                        }
                    }
                break
                
                case .failure(let error):
                    print(error)
                break
            }
            self.TableView.reloadData()
            
            // Stop Indicator
            indicator.stopAnimating()
            indicator.removeFromSuperview()
            
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    
    // MARK : - Get Data With Session
    func callGetMethodSession()
    {
        // Start Indicator
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let url = NSURL(string: "https://api.androidhive.info/contacts/")
        let urlRequest = NSMutableURLRequest(url: url! as URL)
        urlRequest.httpMethod = "GET"
        
        dataTask = URLSession.shared.dataTask(with: urlRequest as URLRequest)
        {
            data,response,error in
            if let error = error
            {
                print(error)
            }
            if let data = data
            {
                do
                {
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
                    if let json = jsonData as? [String:Any]
                    {
                        print(json)
                        if let arrData = json["contacts"] as? [Any]
                        {
                            self.arr = arrData as! [[String : Any]]
                            print(self.arr)
                        }
                    }
                }
                catch
                {
                    
                }
            }
            self.TableView.reloadData()
            
            // Stop Indicator
            indicator.stopAnimating()
            indicator.removeFromSuperview()
            
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        dataTask.resume()
    }
}
