Class {
	#name : #StFileOutMethodDebugCommand,
	#superclass : #StDebugCommand,
	#category : #'NewTools-Debugger-Commands'
}

{ #category : #accessing }
StFileOutMethodDebugCommand class >> defaultDescription [
	^ 'Write the source code of the selected method on a file.'
]

{ #category : #initialization }
StFileOutMethodDebugCommand class >> defaultIconName [
	^ #smallExport
]

{ #category : #accessing }
StFileOutMethodDebugCommand class >> defaultName [
	<StackContextMenuEditionDebugCommand>
	^ 'File out method'
]

{ #category : #initialization }
StFileOutMethodDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #actions }
StFileOutMethodDebugCommand >> execute [
	
	self context fileOutSelectedContext
]
