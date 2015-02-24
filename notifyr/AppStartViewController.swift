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
        
        //


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {            
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("ECSlidingViewController") as UIViewController
        presentViewController(vc, animated: false, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
