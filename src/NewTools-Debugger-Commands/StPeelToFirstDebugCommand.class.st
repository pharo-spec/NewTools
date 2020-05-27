"
Requests the debugger to peel the stack to the first occurrence of the currently selected message in the stack
"
Class {
	#name : #StPeelToFirstDebugCommand,
	#superclass : #StDebugCommand,
	#category : #'NewTools-Debugger-Commands'
}

{ #category : #accessing }
StPeelToFirstDebugCommand class >> defaultDescription [
	^ 'Peels the stack back to the second occurance of the currently selected message.'
]

{ #category : #initialization }
StPeelToFirstDebugCommand class >> defaultIconName [
	^ #down
]

{ #category : #accessing }
StPeelToFirstDebugCommand class >> defaultName [
	^ 'Peel to first like this'
]

{ #category : #initialization }
StPeelToFirstDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #actions }
StPeelToFirstDebugCommand >> execute [
	self debugger copyStackToClipboard
]
