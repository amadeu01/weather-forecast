import Foundation
import XCTest
import SnapshotTesting
import WeatherForecastUI
import SwiftUI
import SharedModel

// Run this test with iPhone 13 Pro Max
// iOS 15.2
// Otherwise the test will break
final class WeatherViewTests: XCTestCase {

    override func setUp() {
        isRecording = false
    }

    func test_View_WhenSmallDevice() {
        let view = WeatherView(.mock)
        assertSnapshot(
            matching: view,
            as: .image(
                layout: .device(config: .iPhoneSe)
            )
        )
    }

    func test_View_WhenMediumDevice() {
        let view = WeatherView(.mock)
        assertSnapshot(
            matching: view,
            as: .image(
                layout: .device(config: .iPhone12)
            )
        )
    }
}
