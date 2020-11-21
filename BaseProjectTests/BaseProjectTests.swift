import XCTest

class BaseProjectTests: XCTestCase {

  override func setUpWithError() throws {
  }

  override func tearDownWithError() throws {
  }

  func testItineraryDateFormatting() throws {
    let src = "2020-10-31T15:35"
    let newValue = src.formattedTimeForItineraryRawTime
    let expectedValue = "15:35"
    XCTAssertEqual(newValue, expectedValue, "Time should be \(expectedValue)")
  }
  
  func testItineraryDateInvalidFormatting() throws {
    let src = "2020-10-31 15:35"
    let newValue = src.formattedTimeForItineraryRawTime
    let expectedValue = "15:35"
    XCTAssertEqual(newValue, expectedValue, "(Must Fail) Time should be \(expectedValue)")
  }

}
