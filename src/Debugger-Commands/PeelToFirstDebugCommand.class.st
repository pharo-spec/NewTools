Class {
	#name : #PeelToFirstDebugCommand,
	#superclass : #DebugCommand,
	#category : #'Debugger-Commands'
}

{ #category : #accessing }
PeelToFirstDebugCommand class >> defaultCommandName [
	<StackContextMenuDebugCommand>
	^ 'Peel to first like this'
]

{ #category : #accessing }
PeelToFirstDebugCommand class >> defaultDescription [
	^ 'Peels the stack back to the second occurance of the currently selected message.'
]

{ #category : #initialization }
PeelToFirstDebugCommand class >> defaultIconName [
	^ #down
]

{ #category : #initialization }
PeelToFirstDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #actions }
PeelToFirstDebugCommand >> execute [

	self session peelToFirstLike: self currentContext 
]
