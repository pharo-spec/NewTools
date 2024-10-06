Class {
	#name : 'SindarinStepToReturnCommand',
	#superclass : 'SindarinCommand',
	#category : 'NewTools-Sindarin-Commands',
	#package : 'NewTools-Sindarin-Commands'
}

{ #category : 'accessing - defaults' }
SindarinStepToReturnCommand class >> defaultDescription [
	^ 'Steps execution until a new instance is created'
]

{ #category : 'accessing - defaults' }
SindarinStepToReturnCommand class >> defaultIconName [
	^ #rightSide
]

{ #category : 'accessing - defaults' }
SindarinStepToReturnCommand class >> defaultName [
	<toolbarExtensionDebugCommand: 50>
	<codeExtensionDebugCommand: 50>
	^ 'To return'
]

{ #category : 'executing' }
SindarinStepToReturnCommand >> execute [ 	
	self flag: 'Not nice to always force update of debugger -> use observer?'.
	self context sindarinDebugger stepToReturn.
	self context forceSessionUpdate
]
