Extension { #name : 'OCProgramNode' }

{ #category : '*NewTools-Debugger-Extensions' }
OCProgramNode >> enableHalts: aBoolean [
	^self propertyAt: #enabledForHaltOrBreakpoint put: aBoolean
]

{ #category : '*NewTools-Debugger-Extensions' }
OCProgramNode >> enabledForHaltOrBreakpoint [
	^self propertyAt: #enabledForHaltOrBreakpoint ifAbsent: [ true ]
]
