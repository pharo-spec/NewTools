Class {
	#name : #SEDReadWriteStream,
	#superclass : #ReadWriteStream,
	#instVars : [
		'debugger'
	],
	#category : #'NewTools-Sindarin-Emergency-Debugger'
}

{ #category : #'instance creation' }
SEDReadWriteStream class >> forDebugger: aSindarinDebugger [
	^ (self on: (String new: 100))
		debugger: aSindarinDebugger;
		yourself
]

{ #category : #accessing }
SEDReadWriteStream >> debugger: anObject [
	debugger := anObject
]
