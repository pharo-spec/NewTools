Extension { #name : 'ClyClass' }

{ #category : '*NewTools-CodeCritiques' }
ClyClass class >> newToolsCodeCritiquesCommandsIn: aCommandMap [

	<calypsoCommands>
	(aCommandMap contextMenu group: SycClassExtraMenuGroup) add: SycClassCritiqueCommand order: 50
]
