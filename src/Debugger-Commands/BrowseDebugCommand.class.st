Class {
	#name : #BrowseDebugCommand,
	#superclass : #DebugCommand,
	#category : #'Debugger-Commands'
}

{ #category : #accessing }
BrowseDebugCommand class >> defaultDescription [
	^ 'Browse current executing method.'
]

{ #category : #initialization }
BrowseDebugCommand class >> defaultIconName [

	^ nil
]

{ #category : #accessing }
BrowseDebugCommand class >> defaultName [
	<StackContextMenuDebugCommand>
	
	^ 'Browse'
]

{ #category : #initialization }
BrowseDebugCommand class >> defaultShortcut [

	^ nil
]

{ #category : #actions }
BrowseDebugCommand >> execute [

	self session browse: self currentContext 
]
