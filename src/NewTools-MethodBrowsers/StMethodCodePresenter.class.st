"
I represent a code presenter used for the method browser, as I provide a refactoring command group
"
Class {
	#name : 'StMethodCodePresenter',
	#superclass : 'SpCodePresenter',
	#instVars : [
		'methodBrowser'
	],
	#category : 'NewTools-MethodBrowsers-Base',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Base'
}

{ #category : 'commands' }
StMethodCodePresenter class >> buildCommandsGroupWith: presenter forRoot: aCmCommandsGroup [

	presenter methodBrowser ifNotNil: [ aCmCommandsGroup register: presenter refactoringCommandsGroup ].
	super buildCommandsGroupWith: presenter forRoot: aCmCommandsGroup
]

{ #category : 'accessing' }
StMethodCodePresenter >> methodBrowser [

	^ methodBrowser
]

{ #category : 'accessing' }
StMethodCodePresenter >> methodBrowser: aBrowser [

	methodBrowser := aBrowser
]

{ #category : 'intialization' }
StMethodCodePresenter >> refactoringCommandsGroup [

	| group |
	group := (CmCommandGroup named: 'Source Code') asSpecGroup
		         beDisplayedAsSubMenu;
		         iconName: #smallAuthoringTools;
		         yourself.
	{
		StRenameClassCommand.
		StExtractTempCommand.
		StConvertTempToInstVarCommand.
		StInlineMethodCommand.
		StRenameArgOrTempCommand.
		StGenerateVariableAccessorCommand.
		StMoveInstanceVariableToClassSideCommand.
		StPushUpVariableCommand.
		StPushDownVariableCommand.
		StRemoveVariableCommand.
		StProtectVariableCommand.
		StRenameVariableCommand.
		StExtractMethodCommand } do: [ :cmdClass | group register: (cmdClass forSpecContext: methodBrowser) ].
	^ group
]
