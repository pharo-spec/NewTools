Extension { #name : 'ClyMethodSourceCodeContext' }

{ #category : '*NewTools-DebugPointsBrowser' }
ClyMethodSourceCodeContext class >> newToolsDebugPointsBrowserCommandsIn: aCommandMap [

	<calypsoCommands>
	(aCommandMap textLeftBarMenu group: ClyDebuggingPointsMenuGroup) add: ClyAddAndConfigureBreakPointCommand order: 1.8
]
