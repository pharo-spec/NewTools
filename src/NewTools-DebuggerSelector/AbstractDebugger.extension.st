Extension { #name : #AbstractDebugger }

{ #category : #'*NewTools-DebuggerSelector' }
AbstractDebugger class >> beCurrent [
	self isAbstract ifTrue: [ 
		self error: 'Cannot register an abstract debugger' ].
	DebuggerSelector singleton mainDebuggerClass: self
]

{ #category : #'*NewTools-DebuggerSelector' }
AbstractDebugger class >> iAmADebugger [
	"Leave blank for intermediate classes. Add the <iAmADebugger> pragma for concrete debugger classes. This pragma is used by the system to find all available debuggers"

	self subclassResponsibility
]

{ #category : #'*NewTools-DebuggerSelector' }
AbstractDebugger class >> rankDebugSession: aDebugSession [
	"Returns an integer representing how much this debugger is suitable to debug @aDebugSession. The higher the integer returned, the more suitable this debugger is. Signal the DebugSessionCannotBeOpenedByThisDebugger exception if this debugger absolutely cannot debug @aDebugSession (for example if this debugger can only handle debug sessions from test executions, and @aDebugSession does not come from a test execution)"

	self subclassResponsibility
]
