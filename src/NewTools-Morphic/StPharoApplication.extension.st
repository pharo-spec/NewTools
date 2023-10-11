Extension { #name : 'StPharoApplication' }

{ #category : '*NewTools-Morphic' }
StPharoApplication >> defaultConfigurationForMorphic [

	^ StPharoMorphicConfiguration new
]

{ #category : '*NewTools-Morphic' }
StPharoApplication >> useMorphic [

	self
		useBackend: #Morphic 
		with: StPharoMorphicConfiguration new
]
