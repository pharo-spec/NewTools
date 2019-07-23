Class {
	#name : #ProceedPreDebugCommand,
	#superclass : #PreDebugCommand,
	#instVars : [
		'proceedDebugCommand'
	],
	#category : #'Debugger-Commands'
}

{ #category : #initialization }
ProceedPreDebugCommand class >> defaultCommandName [
	<PreDebugCommand>
	^ ProceedDebugCommand defaultCommandName
]

{ #category : #initialization }
ProceedPreDebugCommand class >> defaultDescription [
	^ ProceedDebugCommand defaultDescription 
]

{ #category : #initialization }
ProceedPreDebugCommand class >> defaultIconName [
	^ ProceedDebugCommand defaultIconName
]

{ #category : #initialization }
ProceedPreDebugCommand class >> defaultShortcut [
	^ ProceedDebugCommand defaultShortcut 
]

{ #category : #accessing }
ProceedPreDebugCommand >> execute [
	self session
		resume;
		clear.
	self preDebugWindow close
]
