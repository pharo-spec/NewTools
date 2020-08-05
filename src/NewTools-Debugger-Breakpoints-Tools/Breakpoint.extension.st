Extension { #name : #Breakpoint }

{ #category : #'*NewTools-Debugger-Breakpoints-Tools' }
Breakpoint >> asBreakpointInspectionItemIn: aStBreakpointInspectionItem [ 
	^aStBreakpointInspectionItem buildBreakpointItemFor: self
]

{ #category : #'*NewTools-Debugger-Breakpoints-Tools' }
Breakpoint >> printForBreakpointInspection [
	^node methodNode sourceCode
]
