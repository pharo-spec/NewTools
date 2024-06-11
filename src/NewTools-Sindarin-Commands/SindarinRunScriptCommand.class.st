"
Run a given Sindarin script.
Behavior delegated to an instance of Sindarin debugger.
"
Class {
	#name : 'SindarinRunScriptCommand',
	#superclass : 'SindarinCommand',
	#category : 'NewTools-Sindarin-Commands',
	#package : 'NewTools-Sindarin-Commands'
}

{ #category : 'accessing - defaults' }
SindarinRunScriptCommand class >> defaultDescription [
	^'Run the current debugging script'
]

{ #category : 'accessing - defaults' }
SindarinRunScriptCommand class >> defaultIconName [
	^#smallDoIt
]

{ #category : 'accessing - defaults' }
SindarinRunScriptCommand class >> defaultName [
	^'Run script'
]

{ #category : 'executing' }
SindarinRunScriptCommand >> execute [
	self context executeScript
]
