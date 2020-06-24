Extension { #name : #Object }

{ #category : #'*NewTools-ObjectCentricBreakpoints' }
Object >> haltOnAccess: access [
	access = #read ifTrue:[^self haltOnRead].
	access = #read ifTrue:[^self haltOnWrite].
	^self haltOnAccess
]

{ #category : #'*NewTools-ObjectCentricBreakpoints' }
Object >> haltOnAccess: access to: anInstVarName [
	access = #read ifTrue:[^self haltOnReadTo: anInstVarName].
	access = #read ifTrue:[^self haltOnWriteTo: anInstVarName].
	^self haltOnAccessTo: anInstVarName
]
