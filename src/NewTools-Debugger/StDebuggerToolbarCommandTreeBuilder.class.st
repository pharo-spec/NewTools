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
	group decoratedGroup register: self stackContextMenuBrowseCommands.
	group decoratedGroup register: self stackContextMenuExplorationCommands.	
	group decoratedGroup register: self stackContextMenuStackEditionsCommands.
	group decoratedGroup register: self stackContextMenuActionsCommands.
]
