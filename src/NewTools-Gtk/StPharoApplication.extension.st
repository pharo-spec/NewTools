Extension { #name : #StPharoApplication }

{ #category : #'*NewTools-Gtk' }
StPharoApplication >> cssProviderCode [

	^ self propertyAt: StPharoGtkConfiguration cssProviderCodePropertyName
]

{ #category : #'*NewTools-Gtk' }
StPharoApplication >> cssProviderCode: aProvider [

	^ self 
		propertyAt: #cssProviderCode
		put: aProvider
]
