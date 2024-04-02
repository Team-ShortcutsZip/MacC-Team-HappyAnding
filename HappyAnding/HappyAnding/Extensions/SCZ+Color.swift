//
//  SCZ+Color.swift
//  HappyAnding
//
//  Created by JeonJimin on 4/2/24.
//

import SwiftUI

/// 단축어 아이콘 셀 배경 색상을 미리 정의해둔 파일입니다.
/// SCZColor.colors[shortcut.color]!.color(for: colorScheme).fillGradient() 와 같이 사용 가능합니다.
/// 
protocol ColorProtocol {
    var light: ColorType { get }
    var dark: ColorType { get }
}

extension ColorProtocol {
    func color(for scheme: ColorScheme) -> ColorType {
        switch scheme {
        case .light:
            return light
        case .dark:
            return dark
        @unknown default:
            return light
        }
    }
}

struct ColorType {
    var fill: GradientType
    var stroke: GradientType?
    
    func fillGradient() -> LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [Color(hexString: fill.gradient01),
                                        Color(hexString: fill.gradient02)]
                              ),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    func strokeGradient() -> LinearGradient? {
        guard let stroke else { return nil }
        return LinearGradient(
            gradient: Gradient(colors: [Color(hexString: stroke.gradient01),
                                        Color(hexString: stroke.gradient02)]
                              ),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

struct GradientType {
    var gradient01: String
    var gradient02: String
}

struct SCZColor {
    static let defaultColor = Red().light.fillGradient()
    static let colors: [String: ColorProtocol] = [
        "Red": Red(),
        "Coral": Coral(),
        "Orange": Orange(),
        "Yellow": Yellow(),
        "Green": Green(),
        "Mint": Mint(),
        "Teal": Teal(),
        "Cyan": Cyan(),
        "Blue": Blue(),
        "Purple": Purple(),
        "LightPurple": Lavendar(),
        "Silver": Silver(),
        "Khaki": Khaki(),
        "Brown": Brown()
    ]
    
    struct Red: ColorProtocol {
        var light: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "F46D71",
                                    gradient02: "F25A5F"
                                ),
                             stroke:
                                GradientType(
                                    gradient01: "F26367",
                                    gradient02: "F05056"
                                )
            )
        }
        var dark: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "EF676D",
                                    gradient02: "EC5057"
                                ),
                             stroke: nil
            )
        }
    }
    struct Coral: ColorProtocol {
        var light: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "FF8C70",
                                    gradient02: "FF7C5E"
                                ),
                             stroke:
                                GradientType(
                                    gradient01: "FF8166",
                                    gradient02: "FF6F53"
                                )
            )
        }
        var dark: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "FF8C70",
                                    gradient02: "FF7C5E"
                                ),
                             stroke: nil
            )
        }
    }
    struct Orange: ColorProtocol {
        var light: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "F8AD5C",
                                    gradient02: "F7A145"
                                ),
                             stroke:
                                GradientType(
                                    gradient01: "F7A453",
                                    gradient02: "F7993E"
                                )
            )
        }
        var dark: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "F8AD5C",
                                    gradient02: "F7A145"
                                ),
                             stroke: nil
            )
        }
    }
    struct Yellow: ColorProtocol {
        var light: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "EEC806",
                                    gradient02: "ECC001"
                                ),
                             stroke:
                                GradientType(
                                    gradient01: "EDC203",
                                    gradient02: "E9BA00"
                                )
            )
        }
        var dark: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "EEC806",
                                    gradient02: "ECC001"
                                ),
                             stroke: nil
            )
        }
    }
    struct Green: ColorProtocol {
        var light: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "4ECD68",
                                    gradient02: "37C554"
                                ),
                             stroke:
                                GradientType(
                                    gradient01: "48C85F",
                                    gradient02: "31BF4B"
                                )
            )
        }
        var dark: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "4ECD68",
                                    gradient02: "37C554"
                                ),
                             stroke: nil
            )
        }
    }
    struct Mint: ColorProtocol {
        var light: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "00D1B1",
                                    gradient02: "00CBA6"
                                ),
                             stroke:
                                GradientType(
                                    gradient01: "00CDAA",
                                    gradient02: "03C59E"
                                )
            )
        }
        var dark: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "00D1B1",
                                    gradient02: "00CBA6"
                                ),
                             stroke: nil
            )
        }
    }
    struct Teal: ColorProtocol {
        var light: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "00CEE0",
                                    gradient02: "00C8DD"
                                ),
                             stroke:
                                GradientType(
                                    gradient01: "04C9DE",
                                    gradient02: "00C2D9"
                                )
            )
        }
        var dark: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "00CEE0",
                                    gradient02: "00C8DD"
                                ),
                             stroke:
                                GradientType(
                                    gradient01: "04C9DE",
                                    gradient02: "00C2D9"
                                )
            )
        }
    }
    struct Cyan: ColorProtocol {
        var light: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "02B9F8",
                                    gradient02: "00B0F6"
                                ),
                             stroke:
                                GradientType(
                                    gradient01: "00B2F6",
                                    gradient02: "01A7F4"
                                )
            )
        }
        var dark: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "02B9F8",
                                    gradient02: "00B0F6"
                                ),
                             stroke:
                                GradientType(
                                    gradient01: "00B2F6",
                                    gradient02: "01A7F4"
                                )
            )
        }
    }
    struct Blue: ColorProtocol {
        var light: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "5572CA",
                                    gradient02: "3F60C3"
                                ),
                             stroke:
                                GradientType(
                                    gradient01: "4E67C5",
                                    gradient02: "3655BC"
                                )
            )
        }
        var dark: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "5572CA",
                                    gradient02: "3F60C3"
                                ),
                             stroke:
                                GradientType(
                                    gradient01: "4E67C5",
                                    gradient02: "3655BC"
                                )
            )
        }
    }
    struct Purple: ColorProtocol {
        var light: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "8F61C6",
                                    gradient02: "804DBF"
                                ),
                             stroke:
                                GradientType(
                                    gradient01: "8458C1",
                                    gradient02: "7343B7"
                                )
            )
        }
        var dark: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "8F61C6",
                                    gradient02: "804DBF"
                                ),
                             stroke:
                                GradientType(
                                    gradient01: "8458C1",
                                    gradient02: "7343B7"
                                )
            )
        }
    }
    struct Lavendar: ColorProtocol {
        var light: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "BF82E6",
                                    gradient02: "B772E2"
                                ),
                             stroke:
                                GradientType(
                                    gradient01: "B876E3",
                                    gradient02: "AE66E0"
                                )
            )
        }
        var dark: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "BF82E6",
                                    gradient02: "B772E2"
                                ),
                             stroke:
                                GradientType(
                                    gradient01: "B876E3",
                                    gradient02: "AE66E0"
                                )
            )
        }
    }
    struct Pink: ColorProtocol {
        var light: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "F792D7",
                                    gradient02: "F684D3"
                                ),
                             stroke:
                                GradientType(
                                    gradient01: "F687D4",
                                    gradient02: "F477CD"
                                )
            )
        }
        var dark: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "F792D7",
                                    gradient02: "F684D3"
                                ),
                             stroke:
                                GradientType(
                                    gradient01: "F687D4",
                                    gradient02: "F477CD"
                                )
            )
        }
    }
    struct Silver: ColorProtocol {
        var light: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "8E97A1",
                                    gradient02: "7F8A95"
                                ),
                             stroke:
                                GradientType(
                                    gradient01: "838E98",
                                    gradient02: "727D89"
                                )
            )
        }
        var dark: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "8E97A1",
                                    gradient02: "7F8A95"
                                ),
                             stroke:
                                GradientType(
                                    gradient01: "838E98",
                                    gradient02: "727D89"
                                )
            )
        }
    }
    struct Khaki: ColorProtocol {
        var light: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "9BA59C",
                                    gradient02: "8E998E"
                                ),
                             stroke:
                                GradientType(
                                    gradient01: "919D92",
                                    gradient02: "818F83"
                                )
            )
        }
        var dark: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "9BA59C",
                                    gradient02: "8E998E"
                                ),
                             stroke:
                                GradientType(
                                    gradient01: "919D92",
                                    gradient02: "818F83"
                                )
            )
        }
    }
    struct Brown: ColorProtocol {
        var light: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "A39893",
                                    gradient02: "968A85"
                                ),
                             stroke:
                                GradientType(
                                    gradient01: "9A8E89",
                                    gradient02: "8C7C78"
                                )
            )
        }
        var dark: ColorType {
            return ColorType(fill:
                                GradientType(
                                    gradient01: "A39893",
                                    gradient02: "968A85"
                                ),
                             stroke:
                                GradientType(
                                    gradient01: "9A8E89",
                                    gradient02: "8C7C78"
                                )
            )
        }
    }
    
}

//정의된 LinearGradient
extension SCZColor {
    static let promotionBanner = Color(hexString: "7AB5E9", opacity: 0.64)
    static let promotionIndicator = LinearGradient(
        colors: [CharcoalGray.color,
                 CharcoalGray.opacity48],
        startPoint: .top,
        endPoint: .bottom
    )
    static let Basic = LinearGradient(
        colors: [CharcoalGray.opacity64,
                 Color(hexString: "A6A6A6")],
        startPoint: .top,
        endPoint: .bottom
    )
    static let Medium = LinearGradient(
        colors: [CharcoalGray.opacity88,
                 CharcoalGray.opacity64],
        startPoint: .top,
        endPoint: .bottom
    )
    static let Light = LinearGradient(
        colors: [CharcoalGray.opacity88,
                 CharcoalGray.opacity48],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let gold = LinearGradient(
        colors: [Color(hexString: "E4C139"),
                 Color(hexString: "8D7516")],
        startPoint: .top,
        endPoint: .bottom
    )
    static let silver = LinearGradient(
        colors: [Color(hexString: "999999"),
                 Color(hexString: "717171")],
        startPoint: .top,
        endPoint: .bottom
    )
    static let bronze = LinearGradient(
        colors: [Color(hexString: "E6BA92"),
                 Color(hexString: "A66F3B")],
        startPoint: .top,
        endPoint: .bottom
    )
    
    struct CharcoalGray {
        static let color: Color = Color(hexString: "404040")
        static let opacity88 = Color(hexString: "404040", opacity: 0.88)
        static let opacity64 = Color(hexString: "404040", opacity: 0.64)
        static let opacity48 = Color(hexString: "404040", opacity: 0.48)
        static let opacity24 = Color(hexString: "404040", opacity: 0.24)
        static let opacity08 = Color(hexString: "404040", opacity: 0.08)
        static let opacity04 = Color(hexString: "404040", opacity: 0.04)
    }
}
