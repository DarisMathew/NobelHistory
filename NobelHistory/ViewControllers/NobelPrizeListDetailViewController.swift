//
//  NobelPrizeListDetialViewController.swift
//  NobelHistory
//
//  Created by interview on 05.09.24.
//

import UIKit


class NobelPrizeListDetailViewController: UIViewController {
    var viewModel: NobelPrizesViewModel
    var nobelPrize: NobelPrize
    
    var activityIndicator: UIActivityIndicatorView!
    var blurEffectView: UIVisualEffectView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var birthPlaceLabel: UILabel!
    @IBOutlet weak var deathDateLabel: UILabel!
    
    // Dependency injection via initializer
    init?(viewModel: NobelPrizesViewModel,
          nobelPrize: NobelPrize,
          coder:NSCoder) {
        self.viewModel = viewModel
        self.nobelPrize = nobelPrize
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadLaureateDetails()
    }
    
    private func setupUI() {
        titleLabel.text = "Details for \(nobelPrize.awardYear) - \(nobelPrize.category.en)"
        setupLoadingUI()
    }
    
    private func setupLoadingUI() {
        setupBlurEffect()
        setupActivityIndicator()
        setupConstraints()
    }
    
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.contentView.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: blurEffectView.contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: blurEffectView.contentView.centerYAnchor)
        ])
    }
    
    private func loadLaureateDetails() {
        showLoadingIndicator()

        Task {
            do {
                guard let laureate = try await viewModel.getNobelLaureateItemDetails(id: nobelPrize.laureates?.first?.id ?? "") else {
                    print("No data available for this laureate.")
                    return
                }
                updateUI(laureate: laureate)
            } catch {
                print("Error fetching details: \(error)")
            }
            hideLoadingIndicator()
        }
    }
    
    private func showLoadingIndicator() {
            blurEffectView.isHidden = false
            activityIndicator.startAnimating()
        }
        
        private func hideLoadingIndicator() {
            blurEffectView.isHidden = true
            activityIndicator.stopAnimating()
        }
    
    private func updateUI(laureate: NobelLaureate) {
        nameLabel.text = laureate.name()
        genderLabel.text = laureate.gender ?? "Unknown"
        birthDateLabel.text = laureate.birth?.date ?? "Date not available"
        birthPlaceLabel.text = laureate.birth?.place.locationString?.en ?? "Location not available"
        deathDateLabel.text = laureate.death?.date ?? "N/A"
    }
}
