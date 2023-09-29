Extension { #name : 'StDebugger' }

{ #category : '*NewTools-Debugger-Tests' }
StDebugger class >> activatedDebuggerExtensions [

	^ self extensionToolsClasses select: [ :extension |
		  extension showInDebugger ]
]

{ #category : '*NewTools-Debugger-Tests' }
StDebugger >> inspector [

	^ inspector
]

{ #category : '*NewTools-Debugger-Tests' }
StDebugger >> stackAndCodeContainer [

	^ stackAndCodeContainer
]

{ #category : '*NewTools-Debugger-Tests' }
StDebugger >> toolbarCommandGroup [

	^ toolbarCommandGroup
]
