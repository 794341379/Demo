//
//  ViewController.swift
//  Swift3Demo
//
//  Created by pisen on 16/9/14.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let str:String =  EncryptManager.sharedManager.encryptStrings(str: "hello")
        print(str)
        // 私有方法访问不到
//        let msg: String = EncryptManager.sharedManager.encryptMethod(str:"123456")
//        
//        print(msg)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
