Extension { #name : #ReExceptionProperty }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
ReExceptionProperty >> actions [
	^ {(RePropertyAction new
		icon: (self iconNamed: #smallDebug);
		description: 'Debug the exception';
		action: [ :prop | 
			(DebugRequest newForContext: prop stack) label: (prop message); submit ];
		yourself)}
]
