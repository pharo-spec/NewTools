Extension { #name : #RBProgramNode }

{ #category : #'*NewTools-Debugger' }
RBProgramNode >> isActiveHaltOrBreakpoint [
	^self propertyAt: #isActiveHaltOrBreakpoint ifAbsent: [ false ]
]

{ #category : #'*NewTools-Debugger' }
RBProgramNode >> setActiveHaltOrBreakpoint: aBoolean [
	^self propertyAt: #isActiveHaltOrBreakpoint put: aBoolean
]
