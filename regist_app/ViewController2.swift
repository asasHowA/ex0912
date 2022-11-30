//
//  ViewController2.swift
//  ex0912
//
//  Created by doi-macbook on 2022/11/08.
//

import UIKit

var _touroku1:String? = ""
var _touroku2:String? = ""
var _touroku3:String? = ""

class ViewController2: UIViewController {
    @IBOutlet weak var touroku1: UITextField!
    @IBOutlet weak var touroku2: UITextField!
    @IBOutlet weak var touroku3: UITextField!
    @IBOutlet weak var x_zahyou: UILabel!
    @IBOutlet weak var y_zahyou: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       navigationController?.isNavigationBarHidden = false
     }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        x_zahyou.text = "x:" + tap_x
        y_zahyou.text = "y:" + tap_y
        print(tap_x,tap_y)
        touroku1.placeholder = "半径を入力してください"
        touroku2.placeholder = "登録点１を入力してください"
        touroku3.placeholder = "登録点２を入力してください"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func decision(_ sender: Any) {
        _touroku1 = touroku1.text
        _touroku2 = touroku2.text
        _touroku3 = touroku3.text

        out_put.append([tap_x,tap_y,_touroku1!,_touroku2!,_touroku3!])
        self.navigationController?.popViewController(animated: true)
    }
    
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
