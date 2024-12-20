Class {
	#name : 'TStDebuggerExtensionTestClass',
	#superclass : 'SpPresenter',
	#traits : 'TStDebuggerExtension',
	#classTraits : 'TStDebuggerExtension classTrait',
	#category : 'NewTools-Debugger-Tests-Model',
	#package : 'NewTools-Debugger-Tests',
	#tag : 'Model'
}

{ #category : 'testing' }
TStDebuggerExtensionTestClass class >> acceptsPredicate: aStDebuggerContextPredicate [

	^ true
]

{ #category : 'layout' }
TStDebuggerExtensionTestClass class >> defaultLayout [

	^ SpBoxLayout newVertical
]

{ #category : 'testing' }
TStDebuggerExtensionTestClass class >> isOnlyForTests [

	^ true
]

{ #category : 'debugger extension' }
TStDebuggerExtensionTestClass >> debuggerExtensionToolName [
	
	^ 'TStDebuggerExtensionTestClass'
]
