Class {
	#name : 'SindarinStepToMethodEntryCommand',
	#superclass : 'SindarinCommand',
	#category : 'NewTools-Sindarin-Commands',
	#package : 'NewTools-Sindarin-Commands'
}

{ #category : 'accessing - defaults' }
SindarinStepToMethodEntryCommand class >> defaultDescription [
	^ 'Step to the beginning of the next method, then returns debugger control.'
]

{ #category : 'accessing - defaults' }
SindarinStepToMethodEntryCommand class >> defaultIconName [
	^ #into 
]

{ #category : 'accessing - defaults' }
SindarinStepToMethodEntryCommand class >> defaultName [
	<toolbarExtensionDebugCommand: 50>
	<codeExtensionDebugCommand: 50>
	^ 'To method entry'
]

{ #category : 'executing' }
SindarinStepToMethodEntryCommand >> execute [ 	
	self flag: 'Not nice to always force update of debugger -> use observer?'.
	self context sindarinDebugger stepToMethodEntry.
	self context forceSessionUpdate
]
