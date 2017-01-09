//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

class PickerKeyboardInputView: UIView {

    fileprivate lazy var pickerView: UIPickerView = {
        let view = UIPickerView()
        view.showsSelectionIndicator = true
        view.dataSource = self
        view.delegate = self
        return view
    }()

    fileprivate let pickerData: [String]
    fileprivate let completion: TextFieldChangedHandler

    init(pickerData: [String], startingValueIndex: Int, completion: @escaping TextFieldChangedHandler) {
        self.pickerData = pickerData
        self.completion = completion
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216)
        super.init(frame: frame)
        buildView()
        pickerView.reloadAllComponents()
        pickerView.selectRow(startingValueIndex, inComponent: 0, animated: false)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PickerKeyboardInputView: UIBuilder {

    func configureView() {
        addSubview(pickerView)
    }

    func configureConstraints() {
        pickerView.fillInSuperview()
    }

}

extension PickerKeyboardInputView: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

}

extension PickerKeyboardInputView: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        completion(pickerData[row])
    }

}
