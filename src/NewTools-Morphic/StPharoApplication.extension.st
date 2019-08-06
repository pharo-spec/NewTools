Extension { #name : #StPharoApplication }

{ #category : #'*NewTools-Morphic' }
StPharoApplication >> styleSheet [

	^ self propertyAt: StPharoMorphicConfiguration styleSheetPropertyName
]
