Extension { #name : #RBProgramNode }

{ #category : #'*NewTools-Debugger' }
RBProgramNode >> allBreakpointLinks [
	^ self links select: [ :link | link metaObject = Break ]
]

{ #category : #'*NewTools-Debugger' }
RBProgramNode >> enableForHaltOrBreakpoint: aBoolean [
	^self propertyAt: #enabledForHaltOrBreakpoint put: aBoolean
]

{ #category : #'*NewTools-Debugger' }
RBProgramNode >> enabledForHaltOrBreakpoint [
	^self propertyAt: #enabledForHaltOrBreakpoint ifAbsent: [ true ]
]

{ #category : #'*NewTools-Debugger' }
RBProgramNode >> isHaltNode [
	^ false
]
