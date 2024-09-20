Extension { #name : 'ASTProgramNode' }

{ #category : '*NewTools-Debugger-Extensions' }
ASTProgramNode >> enableHalts: aBoolean [
	^self propertyAt: #enabledForHaltOrBreakpoint put: aBoolean
]

{ #category : '*NewTools-Debugger-Extensions' }
ASTProgramNode >> enabledForHaltOrBreakpoint [
	^self propertyAt: #enabledForHaltOrBreakpoint ifAbsent: [ true ]
]
