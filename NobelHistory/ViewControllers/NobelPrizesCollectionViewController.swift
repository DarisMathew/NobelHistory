//
//  NobelPrizesCollectionViewController.swift
//  NobelHistory
//
//  Created by Lars Dahmen on 20.09.23.
//

import UIKit

enum Section {
    case main
}

class NobelPrizesCollectionViewController: UICollectionViewController {
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, NobelPrize> = configureDataSource()
    private var snapShot = NSDiffableDataSourceSnapshot<Section, NobelPrize>()
    private var viewModel: NobelPrizesViewModel!
    
    private var isFilterEnabled: Bool = false
    private var loadMoreDebounceTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureViewModel()
        setupCollectionView()
        fetchData()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Nobel Prizes"
        let filterIcon = UIImage(systemName: "line.horizontal.3.decrease.circle")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: filterIcon, style: .plain, target: self, action: #selector(showFilterActionSheet))
    }
    
    private func configureViewModel() {
        viewModel = NobelPrizesViewModel(repository: .shared) { [weak self] in
            self?.dataChanged()
        }
    }
    
    private func setupCollectionView() {
        collectionView.collectionViewLayout = createCompositionalLayout()
        registerCells()
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: layoutConfig)
    }
    
    private func registerCells() {
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "NobelPrizeCell")
    }
    
    private func configureDataSource() -> UICollectionViewDiffableDataSource<Section, NobelPrize>{
        dataSource = UICollectionViewDiffableDataSource<Section, NobelPrize>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NobelPrizeCell", for: indexPath) as? UICollectionViewListCell else {
                return nil
            }
            var content = cell.defaultContentConfiguration()
            content.text = "\(item.awardYear) - \(item.category.en)"
            content.secondaryText = item.laureates?.first?.name()
            cell.contentConfiguration = content
            return cell
        }
        updateSnapshot()
        return dataSource
    }
    
    private func fetchData() {
        Task {
            do {
                try await viewModel.updateData()
            } catch {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let nobelPrize = dataSource.itemIdentifier(for: indexPath) else { return }
        navigateToDetailViewController(with: nobelPrize)
    }
    
    private func navigateToDetailViewController(with nobelPrize: NobelPrize) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewControllerIdentifier = "NobelPrizeListDetailViewController"
        
        let detailViewController = storyboard.instantiateViewController(identifier: viewControllerIdentifier) { coder in
            return NobelPrizeListDetailViewController(viewModel: self.viewModel,
                                                      nobelPrize: nobelPrize,
                                                      coder: coder)
        }
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func dataChanged() {
        updateSnapshot()
    }
    
    private func updateSnapshot() {
        snapShot = NSDiffableDataSourceSnapshot<Section, NobelPrize>()
        snapShot.appendSections([.main])
        snapShot.appendItems(viewModel.nobelPrizes, toSection: .main)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
    
    @objc func showFilterActionSheet() {
        if presentedViewController != nil { return }
        
        let actionSheet = UIAlertController(title: "Filter with Categories and Year", message: "Select a category to filter", preferredStyle: .actionSheet)
        
        let categories = [
            ("Chemistry", "che"),
            ("Economics", "eco"),
            ("Literature", "lit"),
            ("Peace", "pea"),
            ("Physics", "phy"),
            ("Medicine", "med"),
            ("All", "")
        ]
        categories.forEach { category in
            actionSheet.addAction(UIAlertAction(title: category.0, style: .default, handler: { [weak self] _ in
                if category.1.isEmpty {
                    self?.isFilterEnabled = false
                    Task {
                        do {
                            try await self?.viewModel.resetFilter()
                            self?.collectionView.setContentOffset(.zero, animated: true)
                        } catch {
                            self?.isFilterEnabled = false
                            print("Error resetting filter: \(error)")
                        }
                    }
                } else {
                    self?.isFilterEnabled = true
                    self?.showYearInput(forCategory: category.1)
                }
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func showYearInput(forCategory category: String) {
        let alert = UIAlertController(title: "Enter Year", message: "Enter the year for \(category.capitalized)", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Year"
            textField.keyboardType = .numberPad
        }
        
        alert.addAction(UIAlertAction(title: "Filter", style: .default, handler: { [weak self] _ in
            guard let year = alert.textFields?.first?.text, !year.isEmpty, self?.isValidYear(year) == true else {
                self?.presentAlert(title: "Invalid Input", message: "Please enter a valid year (1901 or later).")
                self?.isFilterEnabled = false
                return
            }
            self?.isFilterEnabled = true
            Task {
                do {
                    try await self?.viewModel.filterNobelPrizes(category: category, year: year)
                } catch {
                    self?.isFilterEnabled = false
                    print("Error applying filter: \(error)")
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Helper function to validate year format
    private func isValidYear(_ year: String) -> Bool {
        guard let yearInt = Int(year), yearInt >= 1901 else {
            return false
        }
        return year.count == 4
    }
    
    // Helper function to present alerts for errors or validations
    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension NobelPrizesCollectionViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let scrollViewHeight = scrollView.frame.size.height
        let contentHeight = scrollView.contentSize.height
        
        // Check if the user has scrolled to the bottom of the collection view
        // If filter is enabled dont reload when scrolling
        if position > contentHeight - scrollViewHeight && !isFilterEnabled && !viewModel.isLoading  {
            Task {
                do {
                    try await viewModel.updateData()
                } catch {
                    print("Failed to load more data: \(error)")
                }
            }
        }
    }
}
