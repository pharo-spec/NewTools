Class {
	#name : #FullStackDebugCommand,
	#superclass : #DebugCommand,
	#category : #'NewTools-Debugger-Commands'
}

{ #category : #default }
FullStackDebugCommand class >> defaultDescription [
	^ 'Open a full debugger to navigate in the full bugged stack.'
]

{ #category : #initialization }
FullStackDebugCommand class >> defaultIconName [
	^ #glamorousMore
]

{ #category : #default }
FullStackDebugCommand class >> defaultName [
	<toolbarDebugCommand: 999>
	<StackContextMenuDebugCommand>
	^ 'Full stack'
]

{ #category : #initialization }
FullStackDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #hooks }
FullStackDebugCommand >> execute [
	self debugger showFullStack
]
