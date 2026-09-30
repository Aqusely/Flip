# Флип — карточки для изучения английских слов

Учебное iOS-приложение на **SwiftUI**: колоды карточек со словами, которые можно переворачивать и смахивать — вправо «знаю», влево «не знаю». Сделано для практики анимаций и управления состоянием в SwiftUI.

<p align="center">
  <img src="Screenshots/decks.png" width="220" alt="Колоды">
  <img src="Screenshots/study.png" width="220" alt="Обучение">
  <img src="Screenshots/card-back.png" width="220" alt="Обратная сторона карточки">
  <img src="Screenshots/result.png" width="220" alt="Результат">
</p>

## Возможности

- **Колоды** — сетка колод с кольцами прогресса, цель дня, серия занятий
- **Обучение** — карточка переворачивается по тапу и смахивается свайпом; штампы «ЗНАЮ / НЕ ЗНАЮ» проявляются по мере движения пальца
- **Отмена** — можно вернуть предыдущую карточку, ответ откатывается
- **Результат** — процент правильных ответов, статистика, список слов на повтор и конфетти за хороший результат
- **Повтор ошибок** — новая сессия только из карточек с ответом «не знаю»

## Анимации

| Где | Что используется |
|---|---|
| Кольца прогресса | `trim(from:to:)` + `withAnimation(.easeInOut)` в `onAppear` |
| Появление плиток колод | каскад через `.delay(index * 0.08)` |
| Нажатие на плитки и кнопки | свой `ButtonStyle` + `scaleEffect` + `.spring` |
| Пульсирующий огонёк | `.animation(_:body:)` + `repeatForever` |
| Капсула в таббаре | `matchedGeometryEffect` |
| Переворот карточки | `rotation3DEffect` по оси Y, смена сторон в середине поворота |
| Свайп карточки | `DragGesture` → `offset` + `rotationEffect` |
| Улёт и появление карточек | `withAnimation { } completion: { }`, `.id` + `.transition` + `.zIndex` |
| Счётчики | `.contentTransition(.numericText())` |
| Звезда на экране результата | `phaseAnimator` |
| Конфетти | случайные кусочки + `.spring` |

## Архитектура

```
Flip/
├─ Models/        Card, Deck, склонение «слово/слова/слов»
├─ Store/         DeckStore — ObservableObject с @Published колодами
├─ Views/         DecksView, StudyView, ResultView
├─ Components/    DeckTile, ProgressRing, FlipCard, CardFront, CardBack,
│                 TabBar, PressableStyle
├─ Theme/         палитра и шрифты
├─ Extensions/    свайп «назад» при скрытой панели навигации
└─ Fonts/         Unbounded, Manrope
```

- `DeckStore` создаётся через `@StateObject` в `FlipApp` и передаётся экранам через `@ObservedObject`
- Локальное состояние экранов — `@State`, переворот карточки передаётся в `FlipCard` через `@Binding`
- Экран обучения получает `id` колоды и находит её в store, чтобы всегда видеть актуальные данные
- `ResultView` ничего не знает о store: получает готовые числа и замыкания `onRepeat` / `onClose`

## Требования

- Xcode 26+
- iOS 26.5+

## Запуск

1. Клонировать репозиторий
2. Открыть `Flip.xcodeproj`
3. Выбрать симулятор iPhone и нажать **Run** (⌘R)

Если сборка просит команду разработки — в настройках таргета **Signing & Capabilities** выбрать свою команду.

## Планы

- [ ] Сохранение прогресса между запусками (`Codable` + `UserDefaults`)
- [ ] Настоящие «Цель дня» и «Серия дней»
- [ ] Экраны «Статистика» и «Профиль»
- [ ] Создание своих колод

## Шрифты

- [Unbounded](https://fonts.google.com/specimen/Unbounded) — SIL Open Font License 1.1
- [Manrope](https://fonts.google.com/specimen/Manrope) — SIL Open Font License 1.1
