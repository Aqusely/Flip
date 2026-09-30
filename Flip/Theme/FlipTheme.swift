import SwiftUI

// Палитра и шрифты из макета на холсте.
extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }

    static let flipBackground = Color(hex: 0xF6F1EA) // кремовый фон
    static let flipInk        = Color(hex: 0x1E1B2E) // текст и тёмные карточки
    static let flipMuted      = Color(hex: 0x7A7488) // второстепенный текст
    static let flipTrack      = Color(hex: 0xE3DACD) // пустые дорожки прогресса
    static let flipChip       = Color(hex: 0xEDE6DB) // круглые кнопки
    static let flipDashed     = Color(hex: 0xD4CBBE) // пунктир «Новая колода»

    // Для элементов на тёмной карточке (flipInk)
    static let flipInkRaised  = Color(hex: 0x3A3450) // дорожка, пилюля серии
    static let flipOnInk      = Color(hex: 0xB7B1C6) // подпись «Цель дня», иконки таббара
    static let flipOnInkDim   = Color(hex: 0x8C86A0) // «/ 20 слов»

    static let flipPeach      = Color(hex: 0xF9B7A0)
    static let flipPeachInk   = Color(hex: 0x5B1E0B)
    static let flipLavender   = Color(hex: 0xC9C0FF)
    static let flipLavenderInk = Color(hex: 0x2A1F73)
    static let flipMint       = Color(hex: 0xA8E6CC)
    static let flipMintInk    = Color(hex: 0x0B4A34)
    static let flipButter     = Color(hex: 0xFFD66B)
    static let flipButterInk  = Color(hex: 0x5A4300) // буква на аватаре
    static let flipCoral      = Color(hex: 0xF2704E)
}

extension Font {
    // Шрифты лежат в Flip/Fonts и подключены через Info.plist (UIAppFonts).
    // Оба вариативные: один файл — все толщины, толщину задаёт .weight().

    /// Заголовки и цифры: .unbounded(28, .bold)
    static func unbounded(_ size: CGFloat, _ weight: Font.Weight = .bold) -> Font {
        .custom("Unbounded", size: size).weight(weight)
    }

    /// Обычный текст: .manrope(14, .medium)
    static func manrope(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        .custom("Manrope", size: size).weight(weight)
    }

    static let flipTitle   = Font.unbounded(28, .bold)
    static let flipHeading = Font.unbounded(18, .bold)
    static let flipBody    = Font.manrope(16, .medium)
    static let flipCaption = Font.manrope(13, .semibold)
}
