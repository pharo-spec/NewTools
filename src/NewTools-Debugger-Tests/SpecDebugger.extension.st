Extension { #name : #SpecDebugger }

{ #category : #'*NewTools-Debugger-Tests' }
SpecDebugger >> contextInspector [
	<haltOrBreakpointForDevelopment>
	self halt: 'Broken'
]

{ #category : #'*NewTools-Debugger-Tests' }
SpecDebugger >> inspector [

	^ inspector
]
