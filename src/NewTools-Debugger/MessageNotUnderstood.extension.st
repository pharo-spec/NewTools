Extension { #name : 'MessageNotUnderstood' }

{ #category : '*NewTools-Debugger' }
MessageNotUnderstood >> debuggerExtensionLayout [ 
	^StDebuggerMNUExtension on: self
]

{ #category : '*NewTools-Debugger' }
MessageNotUnderstood >> showInDebuggerExtension [

	^ true
]
