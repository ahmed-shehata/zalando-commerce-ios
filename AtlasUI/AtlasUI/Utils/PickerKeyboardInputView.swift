//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

class PickerKeyboardInputView: UIView {

    private lazy var pickerView: UIPickerView = {
        let view = UIPickerView()
        view.showsSelectionIndicator = true
        view.dataSource = self
        view.delegate = self
        return view
    }()

    private let pickerData: [String]
    private let completion: TextFieldChangedHandler

    init(pickerData: [String], completion: TextFieldChangedHandler) {
        self.pickerData = pickerData
        self.completion = completion
        let frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 216)
        super.init(frame: frame)
        buildView()
        pickerView.reloadAllComponents()
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
        pickerView.fillInSuperView()
    }

}

extension PickerKeyboardInputView: UIPickerViewDataSource {

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

}

extension PickerKeyboardInputView: UIPickerViewDelegate {

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        completion(pickerData[row])
    }

}
