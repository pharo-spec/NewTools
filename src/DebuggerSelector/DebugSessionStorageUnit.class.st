Class {
	#name : #DebugSessionStorageUnit,
	#superclass : #Object,
	#instVars : [
		'debugSession',
		'timeOfCreation'
	],
	#category : #DebuggerSelector
}

{ #category : #'instance creation' }
DebugSessionStorageUnit class >> newFrom: aDebugSession [
	^ self new
		  debugSession: aDebugSession;
		  timeOfCreation: DateAndTime now;
		  yourself
]

{ #category : #accessing }
DebugSessionStorageUnit >> debugSession [
	^ debugSession
]

{ #category : #accessing }
DebugSessionStorageUnit >> debugSession: anObject [
	debugSession := anObject
]

{ #category : #accessing }
DebugSessionStorageUnit >> timeOfCreation [
	^ timeOfCreation
]

{ #category : #accessing }
DebugSessionStorageUnit >> timeOfCreation: anObject [
	timeOfCreation := anObject
]
