Class {
	#name : 'HaltInCompiledBlockPrintOnTest',
	#superclass : 'TestCase',
	#instVars : [
		'oldCode'
	],
	#category : 'NewTools-Debugger-Tests-Model',
	#package : 'NewTools-Debugger-Tests',
	#tag : 'Model'
}

{ #category : 'running' }
HaltInCompiledBlockPrintOnTest >> setUp [
	super setUp.
	
	oldCode := (BlockClosure >> #printOn:) sourceCode.
	BlockClosure compileSilently: 'printOn: aStream
	 	self halt.
	'.
]

{ #category : 'running' }
HaltInCompiledBlockPrintOnTest >> tearDown [ 
	oldCode ifNotNil: 	[BlockClosure compileSilently: oldCode].
	super tearDown
]

{ #category : 'running' }
HaltInCompiledBlockPrintOnTest >> testExecutingHaltingPrintOnABlockOpensASingleDebugger [

	| ourException dbg debugSession sem myProcess |
	"This is a smoke test making sure that putting an halt in BlockClosure printOn: does not lead 
	to endless loop."
	
	sem := Semaphore new.
	
	myProcess := [[[  ] printString] on: Exception do: [:e | 
		e freeze.
		ourException := e ].	
		sem signal.
	] fork.
	"We are creating a dedicated process, because when closing the debugger it will kill the process and 
	using the active process will kill the test."
	sem wait.
	
	debugSession := myProcess newDebugSessionNamed: 'test' startedAt: ourException signalerContext.
	
	debugSession exception: ourException.
	
	dbg := StDebugger openOn: debugSession withFullView: true.
	dbg window close.
]
