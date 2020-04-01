Extension { #name : #StPharoApplication }

{ #category : #'*NewTools-Gtk' }
StPharoApplication >> useGtk [

	self useBackend: #Gtk with: StPharoGtkConfiguration new
]

{ #category : #'*NewTools-Gtk' }
StPharoApplication >> useGtkDark [

	self useBackend: #Gtk with: StPharoGtkDarkConfiguration new
]
