Class {
	#name : 'DebuggerSelectionRecordUnit',
	#superclass : 'Object',
	#instVars : [
		'debuggerClass',
		'success'
	],
	#category : 'NewTools-DebuggerSelector-Tests',
	#package : 'NewTools-DebuggerSelector-Tests'
}

{ #category : 'instance creation' }
DebuggerSelectionRecordUnit class >> newOnDebuggerClass: aDebuggerClass withSuccess: aBoolean [
	| instance |
	instance := self new.
	instance debuggerClass: aDebuggerClass.
	instance success: aBoolean.
	^ instance
]

{ #category : 'accessing' }
DebuggerSelectionRecordUnit >> debuggerClass [
	^ debuggerClass
]

{ #category : 'accessing' }
DebuggerSelectionRecordUnit >> debuggerClass: anObject [
	debuggerClass := anObject
]

{ #category : 'accessing' }
DebuggerSelectionRecordUnit >> success [
	^ success
]

{ #category : 'accessing' }
DebuggerSelectionRecordUnit >> success: anObject [
	success := anObject
]
