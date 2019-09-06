Class {
	#name : #OpenFullDebuggerPreDebugCommand,
	#superclass : #PreDebugCommand,
	#category : #'Debugger-Commands'
}

{ #category : #default }
OpenFullDebuggerPreDebugCommand class >> defaultDescription [
	^ 'Open a full debugger to navigate in the full bugged stack.'
]

{ #category : #initialization }
OpenFullDebuggerPreDebugCommand class >> defaultIconName [
	^  #glamorousBug
]

{ #category : #default }
OpenFullDebuggerPreDebugCommand class >> defaultName [
	<PreDebugCommand>
	^ 'Debug'
]

{ #category : #initialization }
OpenFullDebuggerPreDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #hooks }
OpenFullDebuggerPreDebugCommand >> execute [
	self preDebugWindow openFullDebugger
]
