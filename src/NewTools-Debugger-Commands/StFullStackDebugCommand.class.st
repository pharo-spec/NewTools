Class {
	#name : #StFullStackDebugCommand,
	#superclass : #StDebugCommand,
	#category : #'NewTools-Debugger-Commands'
}

{ #category : #default }
StFullStackDebugCommand class >> defaultDescription [
	^ 'Shows the full stack.'
]

{ #category : #initialization }
StFullStackDebugCommand class >> defaultIconName [
	^ #glamorousMore
]

{ #category : #default }
StFullStackDebugCommand class >> defaultName [
	<toolbarDebugCommand: 999>
	^ 'Stack'
]

{ #category : #initialization }
StFullStackDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #hooks }
StFullStackDebugCommand >> execute [
	self debugger showFullStack
]
