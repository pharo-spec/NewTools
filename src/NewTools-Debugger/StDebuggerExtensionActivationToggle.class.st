Class {
	#name : 'StDebuggerExtensionActivationToggle',
	#superclass : 'Announcement',
	#instVars : [
		'debuggerExtensionClass'
	],
	#category : 'NewTools-Debugger-Model',
	#package : 'NewTools-Debugger',
	#tag : 'Model'
}

{ #category : 'accessing' }
StDebuggerExtensionActivationToggle class >> debuggerExtensionClass: aDebuggerExtensionClass [

	^ self new
		  debuggerExtensionClass: aDebuggerExtensionClass;
		  yourself
]

{ #category : 'accessing' }
StDebuggerExtensionActivationToggle >> debuggerExtensionClass [

	^ debuggerExtensionClass
]

{ #category : 'accessing' }
StDebuggerExtensionActivationToggle >> debuggerExtensionClass: anObject [

	debuggerExtensionClass := anObject
]
