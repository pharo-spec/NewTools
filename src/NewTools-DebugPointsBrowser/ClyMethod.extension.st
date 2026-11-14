Extension { #name : 'ClyMethod' }

{ #category : '*NewTools-DebugPointsBrowser' }
ClyMethod class >> newToolsDebugPointsBrowserCommandsIn: aCommandMap [

	<calypsoCommands>
	(aCommandMap contextMenu group: ClyMethodDebugPointsMenuGroup) add: ClyAddAndConfigureBreakPointCommand order: 1.8
]
