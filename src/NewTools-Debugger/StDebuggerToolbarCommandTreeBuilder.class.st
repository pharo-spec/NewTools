Class {
	#name : #StDebuggerToolbarCommandTreeBuilder,
	#superclass : #StDebuggerCommandTreeBuilder,
	#category : #'NewTools-Debugger-Model'
}

{ #category : #accessing }
StDebuggerToolbarCommandTreeBuilder class >> displayStrategy [
	^CmUIDisplayAsGroup
]

{ #category : #accessing }
StDebuggerToolbarCommandTreeBuilder class >> groupDescription [
	^ 'Debug actions.'
]

{ #category : #accessing }
StDebuggerToolbarCommandTreeBuilder class >> groupName [ 	
	^'Toolbar'
]

{ #category : #building }
StDebuggerToolbarCommandTreeBuilder >> buildDebuggerCommandGroup [
	|group|
	group := self group.
	group displayStrategy: self displayStrategy.
	group decoratedGroup register: self toolbarDefaultDebuggingCommands 
]

{ #category : #accessing }
StDebuggerToolbarCommandTreeBuilder >> defaultDebugActionsDescription [
	^'Defaults debugging actions'
]

{ #category : #accessing }
StDebuggerToolbarCommandTreeBuilder >> defaultDebugActionsGroupName [
	^'Debugging actions'
]

{ #category : #'accessing - commands classes' }
StDebuggerToolbarCommandTreeBuilder >> defaultDebugCommandsClasses [
	^ StDebugCommand toolbarCommandsForDebugger: stDebuggerInstance
]

{ #category : #commands }
StDebuggerToolbarCommandTreeBuilder >> toolbarDefaultDebuggingCommands [
	| group |
	group := (CmCommandGroup named: self defaultDebugActionsGroupName)
		asSpecGroup.
	group beDisplayedAsGroup.
	group description: self defaultDebugActionsDescription.
	group iconName: #smallDebug.
	self defaultDebugCommandsClasses do: [ :cmd | group register: cmd ].
	^ group
]
