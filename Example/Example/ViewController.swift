//
//  ViewController.swift
//  Example
//
//  Created by TonyStark106 on 2017/5/21.
//  Copyright © 2017年 TonyStark106. All rights reserved.
//

import UIKit
import MyFlatBuffers

class ViewController: UIViewController {
    
    var ses: URLSession?
    override func viewDidLoad() {
        super.viewDidLoad()

        let m = Monster()
        m.name = "Tony"
        m.hp = 255
        m.testarrayofstring = ["Spitfire", "coding"]
        
        let data = m.toFBData()
        // Deserialize
        if let n = Monster(root: data) {
            print("Monster name:    \(n.name!)")
            print("Monster hp:      \(n.hp)")
            print("Monster skills:  \(n.testarrayofstring!)")
            return
        }
        print("fail to serialize or deserialize")
        
//        let url = URL(string: "http://127.0.0.1:44444")!
//        ses = URLSession(configuration: URLSessionConfiguration.default)
//        let task = ses?.dataTask(with: url) { (data, res, err) in
//            if let d = data {
//                let m = Monster(root: d)
//                print(m!.name!)
//            }
//        }
//        task?.resume()
    }
    
}




