Extension { #name : #StDebugger }

{ #category : #'*NewTools-Debugger-Tests' }
StDebugger >> contextInspector [
	<haltOrBreakpointForDevelopment>
	self halt: 'Broken'
]

{ #category : #'*NewTools-Debugger-Tests' }
StDebugger >> inspector [

	^ inspector
]
