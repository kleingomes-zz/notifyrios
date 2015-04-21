//
//  AppStartViewController.swift
//  notifyr
//
//  Created by Klein on 2015-02-21.
//  Copyright (c) 2015 Nelson Narciso. All rights reserved.
//

import UIKit

class AppStartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {            
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("ECSlidingViewController") as! UIViewController
        //presentViewController(vc, animated: false, completion: nil)
        
        var appDelegate = UIApplication.sharedApplication().delegate!
        appDelegate.window!!.rootViewController = vc;
    }

}
