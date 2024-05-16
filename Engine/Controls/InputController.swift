import GameController

class InputController {
    struct Point {
        var x: Float
        var y: Float
        static let zero = Point(x: 0, y: 0)
    }
    
    static let shared = InputController()
    var keysPressed: Set<GCKeyCode> = []
    var keysJustPressed: Set<GCKeyCode> = []

    var leftMouseDown = false
    var mouseDelta = Point.zero
    var mouseScroll = Point.zero
    var touchLocation: CGPoint?
    var touchDelta: CGSize? {
      didSet {
        touchDelta?.height *= -1
        if let delta = touchDelta {
          mouseDelta = Point(x: Float(delta.width), y: Float(delta.height))
        }
        leftMouseDown = touchDelta != nil
      }
    }



    private init() {
        setupKeyboardObservers()
        setupMouseObservers()
    }

    private func setupKeyboardObservers() {
        let center = NotificationCenter.default
        center.addObserver(forName: .GCKeyboardDidConnect, object: nil, queue: nil) { notification in
            let keyboard = notification.object as? GCKeyboard
            keyboard?.keyboardInput?.keyChangedHandler = { [weak self] _, _, keyCode, pressed in
                guard let self = self else { return }
                if pressed {
                    if !self.keysPressed.contains(keyCode) {
                        self.keysJustPressed.insert(keyCode)
                    }
                    self.keysPressed.insert(keyCode)
                } else {
                    self.keysPressed.remove(keyCode)
                }
            }
        }
    #if os(macOS)
      NSEvent.addLocalMonitorForEvents(
        matching: [.keyUp, .keyDown]) { _ in nil }
    #endif
    }

    private func setupMouseObservers() {
        let center = NotificationCenter.default
        center.addObserver(forName: .GCMouseDidConnect, object: nil, queue: nil) { notification in
            let mouse = notification.object as? GCMouse
            mouse?.mouseInput?.leftButton.pressedChangedHandler = { [weak self] _, _, pressed in
                self?.leftMouseDown = pressed
            }
            mouse?.mouseInput?.mouseMovedHandler = { [weak self] _, deltaX, deltaY in
                self?.mouseDelta = Point(x: deltaX, y: deltaY)
            }
            mouse?.mouseInput?.scroll.valueChangedHandler = { [weak self] _, xValue, yValue in
                self?.mouseScroll.x = xValue
                self?.mouseScroll.y = yValue
            }
        }
    }

    func keyPressed(_ keyCode: GCKeyCode) -> Bool {
        return keysPressed.contains(keyCode)
    }

    func keyJustPressed(_ keyCode: GCKeyCode) -> Bool {
        let isJustPressed = keysJustPressed.contains(keyCode)
        keysJustPressed.remove(keyCode)
        return isJustPressed
    }

    func updateEndOfFrame() {
        keysJustPressed.removeAll()
    }
}
