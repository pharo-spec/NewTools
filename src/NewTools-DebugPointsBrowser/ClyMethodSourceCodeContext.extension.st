Extension { #name : 'ClyMethodSourceCodeContext' }

{ #category : '*NewTools-DebugPointsBrowser' }
ClyMethodSourceCodeContext class >> newToolsDebugPointsBrowserCommandsIn: aCommandMap [

	<calypsoCommands>
	(aCommandMap contextMenu group: ClySourceCodeDebugPointsMenuGroup) add: ClyAddAndConfigureBreakPointCommand order: 1.8.
	(aCommandMap textLeftBarMenu group: ClyDebuggingPointsMenuGroup) add: ClyAddAndConfigureBreakPointCommand order: 1.8
]
