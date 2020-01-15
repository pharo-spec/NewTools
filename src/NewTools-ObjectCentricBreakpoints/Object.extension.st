Extension { #name : #Object }

{ #category : #'*NewTools-ObjectCentricBreakpoints' }
Object >> haltOnAccess: access [
	^ self class slotNames
		collect: [ :slotName | self haltOnAccess: access to: slotName ]
]

{ #category : #'*NewTools-ObjectCentricBreakpoints' }
Object >> haltOnAccess: access to: instVarName [
	^OCBreakpoint new haltTarget: self onAccess: access to: instVarName
]

{ #category : #'*NewTools-ObjectCentricBreakpoints' }
Object >> haltOnAccessTo: anInstVarName [
	^ self haltOnAccess: #all to: anInstVarName asSymbol
]

{ #category : #'*NewTools-ObjectCentricBreakpoints' }
Object >> haltOnCallTo: methodSelector [
	^ OCBreakpoint new haltTarget: self onCallTo: methodSelector
]

{ #category : #'*NewTools-ObjectCentricBreakpoints' }
Object >> haltOnRead [
	^self haltOnAccess: #read 
]

{ #category : #'*NewTools-ObjectCentricBreakpoints' }
Object >> haltOnReadAccessTo: anInstVarName [
	^self haltOnAccess: #read to: anInstVarName asSymbol
]

{ #category : #'*NewTools-ObjectCentricBreakpoints' }
Object >> haltOnStateAccess [
	^self haltOnAccess: #all 
]

{ #category : #'*NewTools-ObjectCentricBreakpoints' }
Object >> haltOnWrite [
	^self haltOnAccess: #write 
]

{ #category : #'*NewTools-ObjectCentricBreakpoints' }
Object >> haltOnWriteTo: anInstVarName [
	^self haltOnAccess: #write to: anInstVarName asSymbol
]
