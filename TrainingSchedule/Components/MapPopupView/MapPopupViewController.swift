//
//  MapPopupViewController.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 4/7/24.
//

import UIKit

struct PopUpContent {
    var distance: String?
    var image: UIImage?
}

protocol MapPopViewControllerDelegate: AnyObject {
    func isHide()
}

class MapPopupViewController: UIViewController {
    @IBOutlet weak var blurBackgroundView: UIView!

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var closeButton: UIButton!

    @IBOutlet weak var mapImageView: UIImageView!

    var popUpContent = PopUpContent()

    weak var delegate: MapPopViewControllerDelegate?

    init() {
        super.init(nibName: "MapPopupViewController", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        commonSetup()
    }

    @IBAction func buttonTapped(_ sender: Any) {
        self.hide()
    }
}

extension MapPopupViewController {
    private func commonSetup() {
        self.titleLabel.text = "Congratulations!! You have ran \(popUpContent.distance ?? "0.0") meters."
        self.mapImageView.image = popUpContent.image ?? UIImage()
        self.view.backgroundColor = .clear
        self.blurBackgroundView.backgroundColor = .black.withAlphaComponent(0.6)
        self.blurBackgroundView.alpha = 0
        self.contentView.alpha = 0
        self.contentView.layer.cornerRadius = 10.0
    }

    func show() {
        UIView.animate(withDuration: 1, delay: 0.2) {
            self.blurBackgroundView.alpha = 1
            self.contentView.alpha = 1
        }
    }

    private func hide() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
            self.blurBackgroundView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
        delegate?.isHide()
    }
}
