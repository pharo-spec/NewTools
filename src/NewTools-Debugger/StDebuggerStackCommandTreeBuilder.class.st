Class {
	#name : #StDebuggerStackCommandTreeBuilder,
	#superclass : #StDebuggerCommandTreeBuilder,
	#category : #'NewTools-Debugger-Model'
}

{ #category : #accessing }
StDebuggerStackCommandTreeBuilder class >> groupDescription [
	^ 'Actions on the debugger stack.'
]

{ #category : #accessing }
StDebuggerStackCommandTreeBuilder class >> groupName [ 	
	^'Stack'
]

{ #category : #accessing }
StDebuggerStackCommandTreeBuilder >> browseGroupDescription [
	^ 'Navigate the system from the stack.'
]

{ #category : #accessing }
StDebuggerStackCommandTreeBuilder >> browseGroupName [
	^ 'Browse'
]

{ #category : #building }
StDebuggerStackCommandTreeBuilder >> buildDebuggerCommandGroup [
	|stackGroup|
	stackGroup := self group.	
	stackGroup decoratedGroup register: self stackContextMenuActionsCommands.
	stackGroup decoratedGroup register: self stackContextMenuNavigationCommands.
	stackGroup decoratedGroup register: self stackContextMenuExplorationCommands.
	stackGroup decoratedGroup register: self stackContextMenuStackEditionsCommands

	
]

{ #category : #commands }
StDebuggerStackCommandTreeBuilder >> navigationCommand: aCommandClass forContext: anObject [
	| cmd |
	cmd := aCommandClass forSpecContext: anObject.
	cmd name: aCommandClass shortName.
	^ cmd
]

{ #category : #commands }
StDebuggerStackCommandTreeBuilder >> stackContextMenuActionsCommands [
	| group |
	group := (CmCommandGroup named: self stackContextMenuActionsGroupName) asSpecGroup.
	group beDisplayedAsGroup.
	group description: self stackContextMenuActionsDescription.
	group iconName: #smallDoIt.
	(StDebugCommand stackContextMenuActionsCommandsForDebugger: stDebuggerInstance)
		do: [ :cmd | group register: cmd ].
	^ group
]

{ #category : #accessing }
StDebuggerStackCommandTreeBuilder >> stackContextMenuActionsDescription [
	^ 'Actions on the selected context.'
]

{ #category : #accessing }
StDebuggerStackCommandTreeBuilder >> stackContextMenuActionsGroupName [
	^ 'Context Actions'
]

{ #category : #commands }
StDebuggerStackCommandTreeBuilder >> stackContextMenuCommandsForRootGroup: aRootCmCommandsGroup [
	aRootCmCommandsGroup decoratedGroup register: self stackContextMenuActionsCommands.
	aRootCmCommandsGroup decoratedGroup register: self stackContextMenuNavigationCommands.
	aRootCmCommandsGroup decoratedGroup register: self stackContextMenuExplorationCommands.
	aRootCmCommandsGroup decoratedGroup register: self stackContextMenuStackEditionsCommands.
	^ aRootCmCommandsGroup asMenuPresenter
]

{ #category : #commands }
StDebuggerStackCommandTreeBuilder >> stackContextMenuExplorationCommands [
	| group |
	group := (CmCommandGroup named: self stackContextMenuExplorationGroupName) asSpecGroup.
	group description: self stackContextMenuExplorationDescription.
	group iconName: SpSystemDiscoveryCommand defaultIconName.
	group
		register:
			(self
				navigationCommand: SpBrowseInstancesCommand
				forContext: stDebuggerInstance stackSelectionReceiverClassContext).
	group
		register:
			(self
				navigationCommand: SpBrowseSubInstancesCommand
				forContext: stDebuggerInstance stackSelectionReceiverClassContext).
	group
		register:
			(self
				navigationCommand: SpBrowsePointersToCommand
				forContext: stDebuggerInstance stackSelectionReceiverContext).
	^ group
]

{ #category : #accessing }
StDebuggerStackCommandTreeBuilder >> stackContextMenuExplorationDescription [
	^ 'Explore the receiver object''s graph.'
]

{ #category : #accessing }
StDebuggerStackCommandTreeBuilder >> stackContextMenuExplorationGroupName [
	^ 'Explore'
]

{ #category : #commands }
StDebuggerStackCommandTreeBuilder >> stackContextMenuNavigationCommands [
	| group |
	group := (CmCommandGroup named: self browseGroupName) asSpecGroup.
	group description: self browseGroupDescription.
	group iconName: #smallSystemBrowser.
	group register: self stackContextNavigationCommands.
	group register: self stackMethodNavigationCommands.
	group register: self stackMethodSelectorNavigationCommands.
	group register: self stackReceiverClassNavigationCommands.
	^ group
]

{ #category : #commands }
StDebuggerStackCommandTreeBuilder >> stackContextMenuStackEditionsCommands [
	| group |
	group := (CmCommandGroup named: self stackGroupName) asSpecGroup.
	group description: self stackGroupDescription.
	group iconName: #edit.
	(StDebugCommand stackContextMenuEditionCommandsForDebugger: stDebuggerInstance)
		do: [ :cmd | group register: cmd ].
	^ group
]

{ #category : #commands }
StDebuggerStackCommandTreeBuilder >> stackContextNavigationCommands [
	"Commands to navigate the context"

	| group |
	group := (CmCommandGroup named: self stackContextNavigationGroupName)
		asSpecGroup.
	group beDisplayedAsGroup.
	group
		register:
			((SpBrowseClassCommand
				forSpecContext: stDebuggerInstance stackSelectionMethodContext)
				name: 'method';
				shortcutKey: nil;
				yourself).
	group
		register:
			((SpBrowseClassCommand
				forSpecContext: stDebuggerInstance stackSelectionReceiverClassContext)
				name: 'receiver';
				shortcutKey: nil;
				yourself).
	^ group
]

{ #category : #accessing }
StDebuggerStackCommandTreeBuilder >> stackContextNavigationGroupName [
	^ 'Receiver class code navigation commands'
]

{ #category : #accessing }
StDebuggerStackCommandTreeBuilder >> stackGroupDescription [
	^ 'Stack edition.'
]

{ #category : #accessing }
StDebuggerStackCommandTreeBuilder >> stackGroupName [
	^ 'Stack'
]

{ #category : #commands }
StDebuggerStackCommandTreeBuilder >> stackMethodNavigationCommands [
	"Commands to navigate the selected context's method "

	| group |
	group := (CmCommandGroup named: self stackMethodNavigationGroupName)
		asSpecGroup.
	group beDisplayedAsGroup.
	{SpBrowseMethodInheritanceCommand.
	SpBrowseMethodVersionsCommand}
		do: [ :navCmdClass | 
			group
				register:
					(self
						navigationCommand: navCmdClass
						forContext: stDebuggerInstance stackSelectionMethodContext) ].
	^ group
]

{ #category : #accessing }
StDebuggerStackCommandTreeBuilder >> stackMethodNavigationGroupName [
	^ 'Selected method navigation commands'
]

{ #category : #commands }
StDebuggerStackCommandTreeBuilder >> stackMethodSelectorNavigationCommands [
	"Commands to navigate the selected context's method selector as context "

	| group |
	group := (CmCommandGroup
		named: self stackMethodSelectorNavigationGroupName) asSpecGroup.
	group beDisplayedAsGroup.
	{SpBrowseImplementorsCommand.
	SpBrowseSendersCommand.
	SpBrowseMethodReferencesCommand}
		do: [ :navCmdClass | 
			group
				register:
					(self
						navigationCommand: navCmdClass
						forContext: stDebuggerInstance stackSelectionMethodSelectorContext) ].
	^ group
]

{ #category : #accessing }
StDebuggerStackCommandTreeBuilder >> stackMethodSelectorNavigationGroupName [
	^ 'Selected method''s selector navigation commands'
]

{ #category : #commands }
StDebuggerStackCommandTreeBuilder >> stackReceiverClassNavigationCommands [
	"Commands to navigate the selected context's receiver class as context "

	| group |
	group := (CmCommandGroup named: self stackReceiverClassNavigationGroupName)
		asSpecGroup.
	group beDisplayedAsGroup.
	{SpBrowseClassReferencesCommand.
	SpBrowseClassHierarchyCommand.
	SpBrowseClassVariablesCommand.
	SpBrowseClassVarRefsCommand.
	SpBrowseInstVarRefsCommand}
		do: [ :navCmdClass | 
			group
				register:
					(self
						navigationCommand: navCmdClass
						forContext: stDebuggerInstance stackSelectionReceiverClassContext) ].
	^ group
]

{ #category : #accessing }
StDebuggerStackCommandTreeBuilder >> stackReceiverClassNavigationGroupName [
	^ 'Receiver class navigation commands'
]
