"
Creates an anonymous command class with a debugging script. 
The created command class can be instantiated by the debugger as a custom debugging action.
The created command class has a pragma that identifies itself as a custom debugging action.
"
Class {
	#name : 'SindarinCreateCommandFromScriptCommand',
	#superclass : 'SindarinCommand',
	#category : 'NewTools-Sindarin-Commands',
	#package : 'NewTools-Sindarin-Commands'
}

{ #category : 'accessing - defaults' }
SindarinCreateCommandFromScriptCommand class >> defaultDescription [
	^'Create a command from the current debugging script'
]

{ #category : 'accessing - defaults' }
SindarinCreateCommandFromScriptCommand class >> defaultIconName [
	^#smallAdd 
]

{ #category : 'accessing - defaults' }
SindarinCreateCommandFromScriptCommand class >> defaultName [
	^'Create new command from script'
]

{ #category : 'executing' }
SindarinCreateCommandFromScriptCommand >> execute [
	self context createCommandFromScript
]
