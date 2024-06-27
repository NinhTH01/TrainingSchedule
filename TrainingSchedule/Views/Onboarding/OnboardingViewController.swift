//
//  OnboardingViewController.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 26/6/24.
//

import UIKit

class OnboardingViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var nextButton: UIButton!

    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var pageControl: UIPageControl!
    // MARK: - Variables and Const
    private let slides: [OnboardingSlide] = [OnboardingData.slide1, OnboardingData.slide2, OnboardingData.slide3]

    private var currentPage = 0 {
        didSet {
            if currentPage == slides.count - 1 {
                nextButton.setTitle("Get started!", for: .normal)
            } else {
                nextButton.setTitle("Next", for: .normal)
            }
            pageControl.currentPage = currentPage
        }
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    // MARK: - IBAction
    @IBAction private func nextButtonAction(_ sender: Any) {
        if currentPage == slides.count - 1 {
            let controller = (storyboard?.instantiateViewController(identifier: "HomeTC") as? UITabBarController)!
            controller.modalPresentationStyle = .fullScreen
            UserDefaults.standard.hasOnboarded = true
            present(controller, animated: true, completion: nil)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
// MARK: - Extensions
extension OnboardingViewController:
    UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView
            .dequeueReusableCell(withReuseIdentifier:
                                    OnboardingCollectionViewCell.identifier, for: indexPath)
        as? OnboardingCollectionViewCell)!
        cell.setup(slides[indexPath.row])
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width

        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
