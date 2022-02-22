import Foundation
import XCTest
import SnapshotTesting
import WeatherForecastUI
import SwiftUI
import SharedModel

// Run this test with iPhone 13 Pro Max
// iOS 15.2
// Otherwise the test will break
final class CityCellViewTests: XCTestCase {

    override func setUp() {
        isRecording = false
    }

    func test_View_When_IsLoading() {
        let view = CityCellView("London", content: .isLoading)
        assertSnapshot(
            matching: view,
            as: .image(
                layout: .device(config: .iPhoneSe)
            )
        )
    }

    func test_View_When_IsLoaded() {
        let view = CityCellView("London", content: .loaded((Location.mock, Weather.mock)))
        assertSnapshot(
            matching: view,
            as: .image(
                layout: .device(config: .iPhoneSe)
            )
        )
    }
}
