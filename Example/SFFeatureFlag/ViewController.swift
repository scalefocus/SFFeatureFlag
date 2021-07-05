//
//  ViewController.swift
//  SFFeatureFlag
//
//  Created by Maja Sapunova on 06/08/2021.
//  Copyright (c) 2021 Maja Sapunova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var profileDetailsButton: UIButton!
    @IBOutlet weak var recommendedArticlesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        evaluateEnabledFeatures()
    }


    private func setupViews() {
        profileDetailsButton.isHidden = true
        recommendedArticlesButton.isHidden = true
    }
    
    private func evaluateEnabledFeatures() {
        profileDetailsButton.isHidden = !FeatureFlagManager.shared.isFeatureEnabled(featureType: .profileDetails)
        recommendedArticlesButton.isHidden = !FeatureFlagManager.shared.isFeatureEnabled(featureType: .recommendedArticles, conditionsDataSource: ["country" : "mk"])
    }

    @IBAction func onProfileDetailsTapped(_ sender: Any) {
        //Navigate to the profile details screen
    }
    
    @IBAction func onRecommendedArticlesTapped(_ sender: Any) {
        //Navigate to the recommended articles screen
    }
    
}

