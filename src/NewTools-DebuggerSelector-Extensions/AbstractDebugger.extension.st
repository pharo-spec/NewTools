Extension { #name : #AbstractDebugger }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
AbstractDebugger class >> beCurrent [
	self isAbstract ifTrue: [ 
		self error: 'Cannot register an abstract debugger' ].
	OldDebuggerSelector singleton mainDebuggerClass: self
]

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
AbstractDebugger class >> iAmADebugger [
	"Leave blank for intermediate classes. Add the <iAmADebugger> pragma for concrete debugger classes. This pragma is used by the system to find all available debuggers"

	self subclassResponsibility
]
