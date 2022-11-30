//
//  ViewController.swift
//  ex0912
//
//  Created by doi-macbook on 2022/09/12.
//

import UIKit
import AVFoundation
import Foundation

var xkiroku:[String] = []
var ykiroku:[String] = []
var tap_x:String = ""
var tap_y:String = ""
var out_put:[[String]] = [["x","y","range","登録点1","登録点2"]]


class ViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       navigationController?.isNavigationBarHidden = true
     }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var tapLocation: CGPoint = CGPoint()
    var xBeganTaplist: [Double] = []
    var xEndedTaplist: [Double] = []
    
    var yBeganTaplist: [Double] = []
    var yEndedTaplist: [Double] = []
    
    var tapxy:String = ""

    
    let filename:String = "test"
    
    var synthesizer: AVSpeechSynthesizer!
    var voice: AVSpeechSynthesisVoice!
    
    override func viewDidLoad(){
        super.viewDidLoad()
    
        synthesizer = AVSpeechSynthesizer()
        voice = AVSpeechSynthesisVoice.init(language: "ja-JP")
        let remove_recognizer = UITapGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        remove_recognizer.numberOfTouchesRequired = 2
        remove_recognizer.numberOfTapsRequired = 3
        view.addGestureRecognizer(remove_recognizer)
        
        let out_recognizer = UITapGestureRecognizer(target: self, action: #selector(output(_:)))
        out_recognizer.numberOfTouchesRequired = 3
        out_recognizer.numberOfTapsRequired = 2
        view.addGestureRecognizer(out_recognizer)

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("離れた")
        for touch in touches {
            let location = touch.location(in: self.view)
            ///print(location)
            xEndedTaplist.append(location.x)
            yEndedTaplist.append(location.y)
            ///print(xEndedTaplist,yEndedTaplist)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.xEndedTaplist.removeFirst()
                self.yEndedTaplist.removeFirst()
            }
        }

        
        if xEndedTaplist.count >= 2{
            //print("配列要素数",xEndedTaplist.count)
            for i in 0...xEndedTaplist.count-2{
                var d = sqrt(pow((xEndedTaplist[i]-(xEndedTaplist.last)!),2)+pow((yEndedTaplist[i]-(yEndedTaplist.last)!),2))
                //print(d)
                //DPI＝264では、2mmは10.39px
                if d <= 10{
                    print("double tap:",d)
                    tapxy = "エックス" + String(xEndedTaplist[i]) + "ワイ" + String(yEndedTaplist[i])
                    xkiroku.append(String(xEndedTaplist[i]))
                    ykiroku.append(String(yEndedTaplist[i]))
                    print(xkiroku)
                    print(ykiroku)
                    
                    if(synthesizer.isSpeaking){
                        synthesizer.stopSpeaking(at: .immediate)
                    }
                    let utterance = AVSpeechUtterance.init(string:tapxy)
                    let voice = AVSpeechSynthesisVoice.init(language: "ja-JP")
                    utterance.rate = 0.6 //読み上げの速度
                    utterance.voice = voice
                    synthesizer.speak(utterance)
                    
                    tap_x = String(xEndedTaplist[i])
                    tap_y = String(yEndedTaplist[i])
                    performSegue(withIdentifier: "gonext", sender: nil)
                }
                break
            }
        }else{
            //print("配列要素数1")
        }
    }

    @IBAction func handleGesture(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else {
            return
        }
        print("配列削除")
        xkiroku.removeAll()
        ykiroku.removeAll()
    }
    
    @IBAction func output(_ gesture: UIGestureRecognizer){
        guard gesture.state == .ended else {
            return
        }
        print(out_put)
        createFile(fileName: filename, fileArrData:out_put )
    }

    func speak(_ text: String) {
        if(synthesizer.isSpeaking){
            synthesizer.stopSpeaking(at: .immediate)
        }
        let utterance = AVSpeechUtterance.init(string: text)
        utterance.rate = 0.6
        utterance.voice = voice
        synthesizer.speak(utterance)
    }

    
    func createFile(fileName : String, fileArrData : [[String]]){
        let filePath = NSHomeDirectory() + "/Documents/" + fileName + ".csv"
        print(filePath)
        var fileStrData:String = ""
        
        //StringのCSV用データを準備
        for singleArray in fileArrData{
            for singleString in singleArray{
                fileStrData += "\"" + singleString + "\""
                if singleString != singleArray[singleArray.count-1]{
                    fileStrData += ","
                }
            }
            fileStrData += "\n"
        }
        print(fileStrData)
        
        do{
            try fileStrData.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
            print("Success to Wite the File")
        }catch let error as NSError{
            print("Failure to Write File\n\(error)")
        }
    }
}
