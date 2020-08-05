Extension { #name : #VariableBreakpoint }

{ #category : #'*NewTools-Debugger-Breakpoints-Tools' }
VariableBreakpoint >> asBreakpointInspectionItemIn: aStBreakpointInspectionItem [ 
	^aStBreakpointInspectionItem buildVariableBreakpointItemFor: self
]

{ #category : #'*NewTools-Debugger-Breakpoints-Tools' }
VariableBreakpoint >> printForBreakpointInspection [

	| str |
	self flag: #DBG.
	self flag: 'For now, we display text that we build. Can we improve that and can we have something more testable?'.
	str := WriteStream on: String new.
	str << 'Break on'.
	str space.
	str << accessStrategy asString.
	str space.
	str << 'accesses of:'.

	str cr.

	targetVariableNames do: [ :varName | 
		str << '-'.
		str << varName asString.
		str cr ].

	str << 'in'.
	str space.
	str << (self isObjectCentric
		 ifTrue: [ 'self' ]
		 ifFalse: [ targetClassOrMethod asString ]).
	str space.
	str << (targetClassOrMethod isCompiledMethod
		 ifTrue: [ 'method.' ]
		 ifFalse: [ 'class and its super classes.' ]).

	^ str contents
]
