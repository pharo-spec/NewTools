Class {
	#name : #StFullStackDebugCommand,
	#superclass : #StDebugCommand,
	#category : #'NewTools-Debugger-Commands'
}

{ #category : #default }
StFullStackDebugCommand class >> defaultDescription [
	^ 'Open a full debugger to navigate in the full bugged stack.'
]

{ #category : #initialization }
StFullStackDebugCommand class >> defaultIconName [
	^ #glamorousMore
]

{ #category : #default }
StFullStackDebugCommand class >> defaultName [
	<toolbarDebugCommand: 999>
	<StackContextMenuDebugCommand>
	^ 'Show full stack'
]

{ #category : #initialization }
StFullStackDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #hooks }
StFullStackDebugCommand >> execute [
	self debugger showFullStack
]
