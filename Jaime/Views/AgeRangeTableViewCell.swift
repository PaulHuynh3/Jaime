//
//  AgeRangeTableViewCell.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-07-21.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import UIKit

class AgeRangeTableViewCell: UITableViewCell {

    let minSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 17
        slider.maximumValue = 100
        return slider
    }()

    let maxSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()

    let minLabel: UILabel = {
        let label = AgeRangeLabel()
        label.text = "Min 88"
        return label
    }()

    let maxLabel: UILabel = {
        let label = AgeRangeLabel()
        label.text = "Max 88"
        return label
    }()

    class AgeRangeLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            return .init(width: 80, height: 0)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        //draw vertical stackview of sliders
        let overallStackview = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [minLabel, minSlider]),
            UIStackView(arrangedSubviews: [maxLabel, maxSlider])
        ])
        overallStackview.axis = .vertical
        overallStackview.spacing = 16
        addSubview(overallStackview)
        overallStackview.fillSuperview()
        overallStackview.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
