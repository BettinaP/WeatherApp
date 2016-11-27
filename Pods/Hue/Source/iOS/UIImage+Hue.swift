import UIKit

class CountedColor {
  let color: UIColor
  let count: Int

  init(color: UIColor, count: Int) {
    self.color = color
    self.count = count
  }
}

extension UIImage {

  fileprivate func resize(_ newSize: CGSize) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(newSize, false, 2)
    draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return result!
  }

  public func colors(_ scaleDownSize: CGSize? = nil) -> (background: UIColor, primary: UIColor, secondary: UIColor, detail: UIColor) {
    let cgImage: CGImage

    if let scaleDownSize = scaleDownSize {
      cgImage = resize(scaleDownSize).cgImage!
    } else {
      let ratio = size.width / size.height
      let r_width: CGFloat = 250
      cgImage = resize(CGSize(width: r_width, height: r_width / ratio)).cgImage!
    }

    let width = cgImage.width
    let height = cgImage.height
    let bytesPerPixel = 4
    let bytesPerRow = width * bytesPerPixel
    let bitsPerComponent = 8
    let randomColorsThreshold = Int(CGFloat(height) * 0.01)
    let blackColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    let whiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let raw = malloc(bytesPerRow * height)
    let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue
    let context = CGContext(data: raw, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
    context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
    let data = UnsafeMutableRawPointer<UInt8>(context?.data)
    let imageBackgroundColors = NSCountedSet(capacity: height)
    let imageColors = NSCountedSet(capacity: width * height)

    let sortComparator: (CountedColor, CountedColor) -> Bool = { (a, b) -> Bool in
      return a.count <= b.count
    }

    for x in 0..<width {
      for y in 0..<height {
        let pixel = ((width * y) + x) * bytesPerPixel
        let color = UIColor(
          red:   CGFloat(data[pixel+1]) / 255,
          green: CGFloat(data[pixel+2]) / 255,
          blue:  CGFloat(data[pixel+3]) / 255,
          alpha: 1
        )

        if x >= 5 && x <= 10 {
          imageBackgroundColors.add(color)
        }

        imageColors.add(color)
      }
    }

    var sortedColors = [CountedColor]()

    for color in imageBackgroundColors {
      guard let color = color as? UIColor else { continue }

      let colorCount = imageBackgroundColors.count(for: color)

      if randomColorsThreshold <= colorCount  {
        sortedColors.append(CountedColor(color: color, count: colorCount))
      }
    }

    sortedColors.sort(by: sortComparator)

    var proposedEdgeColor = CountedColor(color: blackColor, count: 1)

    if let first = sortedColors.first { proposedEdgeColor = first }

    if proposedEdgeColor.color.isBlackOrWhite && !sortedColors.isEmpty {
      for countedColor in sortedColors where CGFloat(countedColor.count / proposedEdgeColor.count) > 0.3 {
        if !countedColor.color.isBlackOrWhite {
          proposedEdgeColor = countedColor
          break
        }
      }
    }

    let imageBackgroundColor = proposedEdgeColor.color
    let isDarkBackgound = imageBackgroundColor.isDark

    sortedColors.removeAll()

    for imageColor in imageColors {
      guard let imageColor = imageColor as? UIColor else { continue }

      let color = imageColor.colorWithMinimumSaturation(0.15)

      if color.isDark == !isDarkBackgound {
        let colorCount = imageColors.count(for: color)
        sortedColors.append(CountedColor(color: color, count: colorCount))
      }
    }

    sortedColors.sort(by: sortComparator)

    var primaryColor, secondaryColor, detailColor: UIColor?

    for countedColor in sortedColors {
      let color = countedColor.color

      if primaryColor == nil &&
        color.isContrastingWith(imageBackgroundColor) {
          primaryColor = color
      } else if secondaryColor == nil &&
        primaryColor != nil &&
        primaryColor!.isDistinctFrom(color) &&
        color.isContrastingWith(imageBackgroundColor) {
          secondaryColor = color
      } else if secondaryColor != nil &&
        (secondaryColor!.isDistinctFrom(color) &&
          primaryColor!.isDistinctFrom(color) &&
          color.isContrastingWith(imageBackgroundColor)) {
            detailColor = color
            break
      }
    }

    free(raw)

    return (
      imageBackgroundColor,
      primaryColor   ?? (isDarkBackgound ? whiteColor : blackColor),
      secondaryColor ?? (isDarkBackgound ? whiteColor : blackColor),
      detailColor    ?? (isDarkBackgound ? whiteColor : blackColor))
  }
}
