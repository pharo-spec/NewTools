Extension { #name : #VariableBreakpoint }

{ #category : #'*NewTools-Debugger-Breakpoints-Tools' }
VariableBreakpoint >> asBreakpointInspectionItemIn: aStBreakpointInspectionItem [ 
	^aStBreakpointInspectionItem buildVariableBreakpointItemFor: self
]

{ #category : #'*NewTools-Debugger-Breakpoints-Tools' }
VariableBreakpoint >> printContentsForBreakpointInspection [

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
		 ifFalse: [ 'instances and its super classes.' ]).

	^ str contents
]

{ #category : #'*NewTools-Debugger-Breakpoints-Tools' }
VariableBreakpoint >> printTargetForBreakpointInspection [

	| str |
	str := WriteStream on: String new.
	str << accessStrategy asString.
	str space.
	str << 'accesses to'.
	str space.
	str << (targetClassOrMethod isCompiledMethod
		 ifTrue: [ 'temp' ]
		 ifFalse: [ 'inst' ]).
	str space.
	str << 'var(s):'.
	str space.
	targetVariableNames do: [ :name | 
		str nextPutAll: name.
		str space ].
	^ str contents
]

{ #category : #'*NewTools-Debugger-Breakpoints-Tools' }
VariableBreakpoint >> scopeIncludes: anObject [

	| classScope |
	self isObjectCentric ifTrue: [ ^ targetInstance == anObject ].
	classScope := targetClassOrMethod isCompiledMethod
		              ifTrue: [ targetClassOrMethod methodClass ]
		              ifFalse: [ targetClassOrMethod ].
	^ classScope = anObject class
]
