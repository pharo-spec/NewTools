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
	oldCode := (BlockClosure >> #printOn:) sourceCode
]

{ #category : 'running' }
HaltInCompiledBlockPrintOnTest >> testExecutingHaltingPrintOnABlockOpensASingleDebugger [

	| ourException dbg debugSession sem myProcess |
	"This is a smoke test making sure that putting an halt in BlockClosure printOn: does not lead 
	to endless loop."
	sem := Semaphore new.

	"Creating a dedicated process at high priority.
	The process will override printOn: and try to uninstall it as quickly as possible to make the dynamic scope of the extension as little as possible.
	Otherwise, other threads may be impacted by this global change.
	This is far from perfect, maybe this test should be written/done in a different way."
	myProcess := [
		             [
			             BlockClosure compileSilently: 'printOn: aStream self halt.'.
			             [ ] printString ]
			             on: Exception
			             do: [ :e |
					             e freeze.
					             ourException := e ].
		             BlockClosure compileSilently: oldCode.
		             sem signal ] forkAt: 70.
	sem wait.

	debugSession := myProcess newDebugSessionNamed: 'test' startedAt: ourException signalerContext.

	debugSession exception: ourException.

	dbg := StDebugger openOn: debugSession withFullView: true.
	dbg window close
]
