//
//  BeneficiaryListViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 22/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

class BeneficiaryListViewController: UIViewController {
    
    // MARK: - StoryBoard Instance
       static func storyboardInstance() -> BeneficiaryListViewController {
           return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! BeneficiaryListViewController
       }

    @IBOutlet weak var beneficiaryCollectionView: UICollectionView!{
        didSet {
            beneficiaryCollectionView.delegate = self
            beneficiaryCollectionView.dataSource = self
            beneficiaryCollectionView.isPagingEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        beneficiaryCollectionView.register(UINib(nibName: CollectionViewCellIdentifiers.beneficiaryListCollectionViewCell, bundle: Bundle.main), forCellWithReuseIdentifier: CollectionViewCellIdentifiers.beneficiaryListCollectionViewCell)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
    }
    @IBAction func manageMyCardButtonPressed(_ sender: Any) {
        let manageCardVC = ManageMyCardViewController.storyboardInstance()
        self.navigationController?.pushViewController(manageCardVC, animated: false)
    }
    
    @IBAction func exchangeButtonPressed(_ sender: Any) {
        let exchangeVC = ExchangeViewController.storyboardInstance()
        self.navigationController?.pushViewController(exchangeVC, animated: false)
    }
    @IBAction func recentTransactionButtonPressed(_ sender: Any) {
        let recentTransactionVC = RecentTransactionsViewController.storyboardInstance()
        self.navigationController?.pushViewController(recentTransactionVC, animated: false)
    }
    @IBAction func moreOptionButtonPressed(_ sender: Any) {
        let moreOptionVC = MoreOptionsViewController.storyboardInstance()
        self.navigationController?.pushViewController(moreOptionVC, animated: false)
    }
}

extension BeneficiaryListViewController: UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifiers.beneficiaryListCollectionViewCell, for: indexPath) as? BeneficiaryListCollectionViewCell{
            if indexPath.row == 0{
                cell.beneficiaryImageView.image = UIImage(named: "chatbot")
                cell.beneficiaryNameLabel.text = "ADD NEW\nCONTACT"
            }else if indexPath.row == 6{
                cell.beneficiaryImageView.image = UIImage(named: "corporate")
                cell.beneficiaryNameLabel.text = " Corporate "
            }else{
                cell.beneficiaryNameLabel.text = "Beneficiary Name"
            }
            
                return cell
            }
            return UICollectionViewCell()
        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let sendingOptionsVC = ReciverEmailViewController.storyboardInstance()//SendingOptionsViewController.storyboardInstance()
            self.navigationController?.pushViewController(sendingOptionsVC, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3
        let yourHeight = yourWidth

        return CGSize(width: yourWidth, height: yourHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
