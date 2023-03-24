"
I am a subclass of debug context where I override all methods requesting an UI action.
By default, I act as if a user validated the requested popup.
This is for tests.
"
Class {
	#name : #StDebugContextForTests,
	#superclass : #DebugContext,
	#category : #'NewTools-Debugger-Tests-Utils'
}

{ #category : #'ui requests' }
StDebugContextForTests >> confirm: aString [
	"Voluntarily returns true to simulate popup validation"

	^ true
]
