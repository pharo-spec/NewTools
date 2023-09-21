"
I am a subclass of debug context where I override all methods requesting an UI action.
By default, I act as if a user validated the requested popup.
This is for tests.
"
Class {
	#name : 'StDebugContextForTests',
	#superclass : 'DebugContext',
	#category : 'NewTools-Debugger-Tests-Utils',
	#package : 'NewTools-Debugger-Tests',
	#tag : 'Utils'
}

{ #category : 'private' }
StDebugContextForTests >> browseMethod: aMethod [

	"Do not open a browser, we are in a test"
]

{ #category : 'ui requests' }
StDebugContextForTests >> confirm: aString [
	"Voluntarily returns true to simulate popup validation"

	^ true
]

{ #category : 'ui requests' }
StDebugContextForTests >> confirm: message trueChoice: trueChoice falseChoice: falseChoice [
	"Yes?"
	^ true
]
