Extension { #name : #SpCodePresenter }

{ #category : #'*NewTools-Debugger-Extensions' }
SpCodePresenter class >> debuggerCodeCommandsWith: presenter forRootGroup: aRootCmCommandsGroup [
	<extensionCommands>
	| group |
	group := (CmCommandGroup named: 'Debugger actions on code selection')
		asSpecGroup.
	group
		description: 'Debugger actions on code selection.';
		beDisplayedAsGroup.
	group
		register: (RunToSelectionDebugCommand forSpecContext: presenter owner);
		register: (SkipAllToSelectionDebugCommand forSpecContext: presenter owner).
	aRootCmCommandsGroup register: group
]
