Extension { #name : #ReExceptionProperty }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
ReExceptionProperty >> actions [
	^ {(RePropertyAction new
		icon: (self iconNamed: #smallDebug);
		description: 'Debug the exception';
		action: [ :prop | 
			NewDebuggerSelector
				debugProcess: Processor activeProcess
				fromContext: prop stack
				labeled: prop message ];
		yourself)}
]
