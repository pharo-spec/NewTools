Extension { #name : 'BlockClosure' }

{ #category : '*NewTools-Spotter' }
BlockClosure >> stHasDynamicItems [

	^ self numArgs ~= 0
]

{ #category : '*NewTools-Spotter' }
BlockClosure >> stIterator [
	
	^ StSpotterBlockIterator new 
		onDo: self;
		yourself
]
