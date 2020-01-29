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
	<StackContextMenuEditionDebugCommand>
	^ 'Peel to first like this'
]

{ #category : #initialization }
StPeelToFirstDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #actions }
StPeelToFirstDebugCommand >> execute [

	self session peelToFirstLike: self currentContext 
]
