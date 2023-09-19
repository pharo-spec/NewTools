Class {
	#name : 'StExceptionExtensionPresenter',
	#superclass : 'StPresenter',
	#traits : 'TStDebuggerExtension',
	#classTraits : 'TStDebuggerExtension classTrait',
	#instVars : [
		'exception'
	],
	#category : 'NewTools-Debugger-View',
	#package : 'NewTools-Debugger',
	#tag : 'View'
}

{ #category : 'debugger extension' }
StExceptionExtensionPresenter >> activateForException: anException [
	exception := anException.
	anException activateDebuggerExtension: self
]

{ #category : 'debugger extension' }
StExceptionExtensionPresenter >> debuggerExtensionToolName [
	^'Exception'
]

{ #category : 'layout' }
StExceptionExtensionPresenter >> defaultLayout [

	^SpBoxLayout newTopToBottom 
]

{ #category : 'initialization' }
StExceptionExtensionPresenter >> initialize [
	super initialize.
	self class showInDebugger: false
]

{ #category : 'updating' }
StExceptionExtensionPresenter >> updateLayoutWith: anExceptionDebuggerLayout [
]

{ #category : 'updating' }
StExceptionExtensionPresenter >> updatePresenter [ 
	self activateForException: self debugger exception

]
