//
//  PickerView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 10.02.2022.
//

import UIKit
import SwiftUI
import AudioToolbox

struct LocketModeControl: View {
    @Binding var selectedMode: LocketMode

    func calculateOffset() -> CGFloat {
        return selectedMode == .photo ? 30 : -40
    }

    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Button {
                    withAnimation {
                        selectedMode = .photo
                    }
                } label: {
                    Text(LocketMode.photo.rawValue)
                        .bold()
                        .foregroundColor(selectedMode == .photo ? .white: .white.opacity(0.7))
                }
                Button {
                    withAnimation {
                        selectedMode = .text
                    }
                } label: {
                    Text(LocketMode.text.rawValue)
                        .bold()
                        .foregroundColor(selectedMode == .text ? .white: .white.opacity(0.7))
                }
            }
            .offset(x: calculateOffset())
            .animation(.default, value: calculateOffset())
            Image("angle_up")
                .renderingMode(.template)
                .foregroundColor(.init(Palette.accent))
                .animation(.default, value: selectedMode)
        }

    }
}

struct CustomSlider<Content: View>: UIViewRepresentable {

    var content: Content
    @Binding var offset: CGFloat
    var pickerCount: Int


    init(pickerCount: Int, offset: Binding<CGFloat>,@ViewBuilder content: @escaping()->Content) {
        self.content = content()
        self._offset = offset
        self.pickerCount = pickerCount
    }

    func makeCoordinator() -> Coordinator {
        return CustomSlider.Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> some UIScrollView {

        let scrollView = UIScrollView()
        let swiftUIView = UIHostingController(rootView: content).view!
        let width = CGFloat(pickerCount * 2 * 20) + UIScreen.main.bounds.width
        swiftUIView.frame = CGRect(x: 0, y: 0, width: width, height: 50)

        scrollView.contentSize = swiftUIView.frame.size
        scrollView.addSubview(swiftUIView)
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = context.coordinator
        return scrollView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }

    class Coordinator: NSObject, UIScrollViewDelegate {

        var parent: CustomSlider

        init(parent: CustomSlider) {
            self.parent = parent
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.offset = scrollView.contentOffset.x
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let offset = scrollView.contentOffset.x
            let value = (offset / 20).rounded(.toNearestOrAwayFromZero)
            scrollView.setContentOffset(CGPoint(x: value * 20, y: 0), animated: true)

            //Vibrate and tick
//            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
//            AudioServicesPlayAlertSound(1157)
        }

        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

            //Vibrate and tick
           // AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
           // AudioServicesPlayAlertSound(1157)
        }
    }
}


struct HorizontalPicker<Item: View>: UIViewRepresentable {
    var items: [Item]
    var rowHeight: CGFloat
    @Binding var selected: Int

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: UIViewRepresentableContext<HorizontalPicker>) -> UIPickerView {
        let picker = UIPickerView(frame: .zero)

        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator

        // Rotate PickerView to horizontal
        let rotatingAngle: CGFloat! = -90 * (.pi/180)
        picker.transform = CGAffineTransform(rotationAngle: rotatingAngle)
        picker.autoresizesSubviews = true
        return picker
    }

    func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<HorizontalPicker>) {
        // Update the selected row in picker view based on `selected`'s value
        view.selectRow(selected, inComponent: 0, animated: false)
    }

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: HorizontalPicker

        init(_ pickerView: HorizontalPicker) {
            self.parent = pickerView
        }

        // Set row height
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return parent.rowHeight
        }

        // How many rows
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        // How many items
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.parent.items.count
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.parent.selected = row
        }

        // set Any custom UI view to the row
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            if let view = UIHostingController(rootView: parent.items[row]).view {
                view.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
                view.contentMode = .scaleAspectFill
                return view
            } else {
                return UIView()
            }
        }
    }
}

// MARK: - Test
struct HorizontalPickerTestView: View {

    @Binding var selected: Int
    let length: CGFloat = 100

    var body: some View {
        HorizontalPicker(items: LocketMode.allCases.map{ Text($0.rawValue) },
                         rowHeight: length,
                         selected: $selected)
    }
}

struct ItemView: View {
    var color: Color
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(color)
    }
}
