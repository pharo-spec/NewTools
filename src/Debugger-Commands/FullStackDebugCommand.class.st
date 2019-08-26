Class {
	#name : #FullStackDebugCommand,
	#superclass : #DebugCommand,
	#category : #'Debugger-Commands'
}

{ #category : #default }
FullStackDebugCommand class >> defaultCommandName [
	<toolbarDebugCommand: 999>
	^ 'Full stack'
]

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

	^ 'Full stack'
]

{ #category : #initialization }
FullStackDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #hooks }
FullStackDebugCommand >> execute [
	self flag: 'Broken'.
	self flag: 'What is the usage?'.
	self debugger stack expandBy: self expandedStackSize
]
