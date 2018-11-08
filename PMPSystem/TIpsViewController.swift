//
//  TIpsViewController.swift
//  PMPSystem
//
//  Created by 沈宇帆 on 2018/11/3.
//  Copyright © 2018年 Monash University. All rights reserved.
//

import UIKit

class TIpsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var tips: [String] = ["Tip 1","Tip 2", "Tip 3"]
    var contents:[String] = ["Do not switch the machine frequently. Switch interval at least 5 minutes.","During the use of the projector, try not to use it continuously for more than 4 hours.","To keep the operating environment of the projector clean, pay attention to ventilation."]
    var imgs:[UIImage] = [UIImage(named: "tips1")!,UIImage(named: "tips2")!,UIImage(named: "tips3")!]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TIpsCell", for: indexPath) as! TipsCollectionViewCell
        cell.tipsNoLabel.text = tips[indexPath.row]
        cell.tipsContent.text = contents[indexPath.row]
        cell.tipsImg.image = imgs[indexPath.row]
        //cell.backgroundView = UIImageView(image: UIImage(named: "abstract"))
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        cell.backgroundColor = UIColor(red: 255, green: 255, blue: 224)
        return cell
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
