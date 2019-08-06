Extension { #name : #StPharoApplication }

{ #category : #'*NewTools-Gtk' }
StPharoApplication >> cssProviderCode [

	^ self propertyAt: StPharoGtkConfiguration cssProviderCodePropertyName
]
