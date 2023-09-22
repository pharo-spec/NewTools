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

{ #category : 'testing' }
StExceptionExtensionPresenter class >> isDynamicExtension [

	^ true
]

{ #category : 'debugger extension' }
StExceptionExtensionPresenter class >> showInDebugger [
	^false
]

{ #category : 'debugger extension' }
StExceptionExtensionPresenter class >> showInDebugger: aBoolean [

	self flag: 'ugly but this extension should not be globally activated'
]

{ #category : 'debugger extension' }
StExceptionExtensionPresenter >> debuggerExtensionToolName [
	^debugger exception debuggerExtensionName
]

{ #category : 'layout' }
StExceptionExtensionPresenter >> defaultLayout [

	^SpBoxLayout newTopToBottom 
]

{ #category : 'debugger extension' }
StExceptionExtensionPresenter >> showInDebugger [

	^ self debugger exception showInDebuggerExtension
]

{ #category : 'updating' }
StExceptionExtensionPresenter >> updateLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: debugger exception debuggerExtensionLayout;
			 yourself)
]

{ #category : 'initialization' }
StExceptionExtensionPresenter >> updatePresenter [
	
]
