Extension { #name : 'StPharoApplication' }

{ #category : '*NewTools-Gtk' }
StPharoApplication >> defaultConfigurationForGtk [

	^ StPharoGtkConfiguration new
]

{ #category : '*NewTools-Gtk' }
StPharoApplication >> syntaxHighlightTheme [
	
	self flag: #TODO. "This needs to be refactored as common to all platforms, but for now..."
	^ self 
		propertyAt: #syntaxHighlightTheme 
		ifAbsent: [ nil ]
]

{ #category : '*NewTools-Gtk' }
StPharoApplication >> useGtk [

	self useBackend: #Gtk with: StPharoGtkConfiguration new
]

{ #category : '*NewTools-Gtk' }
StPharoApplication >> useGtkDark [

	self useBackend: #Gtk with: StPharoGtkDarkConfiguration new
]
