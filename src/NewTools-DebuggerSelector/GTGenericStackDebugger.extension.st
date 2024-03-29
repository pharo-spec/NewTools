Extension { #name : 'GTGenericStackDebugger' }

{ #category : '*NewTools-DebuggerSelector' }
GTGenericStackDebugger classSide >> iAmADebugger [
	"Leave blank for intermediate classes. Add the <iAmADebugger> pragma for concrete debugger classes. This pragma is used by the system to find all available debuggers"

	<iAmADebugger>
	
]

{ #category : '*NewTools-DebuggerSelector' }
GTGenericStackDebugger classSide >> rank [
	^ 70
]

{ #category : '*NewTools-DebuggerSelector' }
GTGenericStackDebugger classSide >> rankDebugSession: aDebugSession [
	"Returns an integer representing how much this debugger is suitable to debug @aDebugSession. The higher the integer returned, the more suitable this debugger is. Signal the DebugSessionCannotBeOpenedByThisDebugger exception if this debugger absolutely cannot debug @aDebugSession (for example if this debugger can only handle debug sessions from test executions, and @aDebugSession does not come from a test execution)"
	^ self rank
]
