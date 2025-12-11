"
I'm used to mock certain aspects of the `StDebuggerActionModel` class for testing.
"
Class {
	#name : 'StMockDebuggerClientModel',
	#superclass : 'StDebuggerClientModel',
	#instVars : [
		'tag',
		'interruptedContext'
	],
	#category : 'NewTools-Debugger-Tests-Utils',
	#package : 'NewTools-Debugger-Tests',
	#tag : 'Utils'
}

{ #category : 'context' }
StMockDebuggerClientModel >> computeInitialTopContext [
]

{ #category : 'initialization' }
StMockDebuggerClientModel >> initialize [
	super initialize.
	self interruptedContext: (Context
			 sender: nil
			 receiver: nil
			 method: Object >> #doesNotUnderstand:
			 arguments: #( #message ))
]

{ #category : 'accessing' }
StMockDebuggerClientModel >> interruptedContext: anObject [

	interruptedContext := anObject.
	topContext := anObject
]

{ #category : 'accessing' }
StMockDebuggerClientModel >> session [
	^StMockSession new
]

{ #category : 'accessing' }
StMockDebuggerClientModel >> session: aDebugSession [
	session := aDebugSession 
]

{ #category : 'accessing' }
StMockDebuggerClientModel >> tag [
	^tag
	
]

{ #category : 'debug - stepping' }
StMockDebuggerClientModel >> updateTopContext [
	tag :=  #updateTopContext
	
]
