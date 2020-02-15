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
	group := (CmCommandGroup named: 'Context Actions') asSpecGroup.
	group beDisplayedAsGroup.
	group description: 'Actions on the selected context.'.
	group iconName: #smallDoIt.
	(StDebugCommand stackContextMenuActionsCommandsForDebugger: stDebuggerInstance)
		do: [ :cmd | group register: cmd ].
	^ group
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
	group := (CmCommandGroup named: 'Explore') asSpecGroup.
	group description: 'Explore the receiver object''s graph.'.
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

{ #category : #commands }
StDebuggerStackCommandTreeBuilder >> stackContextMenuNavigationCommands [
	| group |
	group := (CmCommandGroup named: 'Browse') asSpecGroup.
	group description: 'Navigate the system from the stack.'.
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
	group := (CmCommandGroup named: 'Stack') asSpecGroup.
	group description: 'Stack edition.'.
	group iconName: #edit.
	(StDebugCommand stackContextMenuEditionCommandsForDebugger: stDebuggerInstance)
		do: [ :cmd | group register: cmd ].
	^ group
]

{ #category : #commands }
StDebuggerStackCommandTreeBuilder >> stackContextNavigationCommands [
	"Commands to navigate the context"

	| group |
	group := (CmCommandGroup
		named: 'Receiver class code navigation commands') asSpecGroup.
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

{ #category : #commands }
StDebuggerStackCommandTreeBuilder >> stackMethodNavigationCommands [
	"Commands to navigate the selected context's method "

	| group |
	group := (CmCommandGroup named: 'Selected method navigation commands')
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

{ #category : #commands }
StDebuggerStackCommandTreeBuilder >> stackMethodSelectorNavigationCommands [
	"Commands to navigate the selected context's method selector as context "

	| group |
	group := (CmCommandGroup
		named: 'Selected method''s selector navigation commands')
		asSpecGroup.
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

{ #category : #commands }
StDebuggerStackCommandTreeBuilder >> stackReceiverClassNavigationCommands [
	"Commands to navigate the selected context's receiver class as context "

	| group |
	group := (CmCommandGroup named: 'Receiver class navigation commands')
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
