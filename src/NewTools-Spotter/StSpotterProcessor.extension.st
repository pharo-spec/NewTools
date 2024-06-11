Extension { #name : 'StSpotterProcessor' }

{ #category : '*NewTools-Spotter' }
StSpotterProcessor >> headerCategoryFor: aLink on: aSpotterPresenter [

	^ aSpotterPresenter headerCategoryFor: aLink
]

{ #category : '*NewTools-Spotter' }
StSpotterProcessor >> labelForClasses [

	^ '#Classes'
]

{ #category : '*NewTools-Spotter' }
StSpotterProcessor >> labelForImplementors [

	^ '#Implementors'
]

{ #category : '*NewTools-Spotter' }
StSpotterProcessor >> labelForPackages [

	^ '#Packages'
]
