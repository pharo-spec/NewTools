Class {
	#name : #StPharoGtkConfiguration,
	#superclass : #SpApplicationConfiguration,
	#category : #'NewTools-Gtk'
}

{ #category : #private }
StPharoGtkConfiguration >> addProviderFromString: aString [

	(GtkCssProvider newFromString: aString) addForApplicationToDefaultScreen
]

{ #category : #configuring }
StPharoGtkConfiguration >> configureOSX: anApplication [

	self installTheme: self macThemeName.
	self addProviderFromString: '.code { font: 12pt "Monaco" }'
]

{ #category : #configuring }
StPharoGtkConfiguration >> configureUnix: anApplication [

	self addProviderFromString: '.code { font: 12pt "Sans" }'

]

{ #category : #configuring }
StPharoGtkConfiguration >> configureWindows: anApplication [

	self installTheme: self windowsThemeName.
	self addProviderFromString: '.code { font: 10pt "Microsoft Sans Serif" }'
]

{ #category : #private }
StPharoGtkConfiguration >> installTheme: aString [

	GtkSettings default themeName: aString
]

{ #category : #accessing }
StPharoGtkConfiguration >> macThemeName [
		
	^ 'Sierra-light'
]

{ #category : #accessing }
StPharoGtkConfiguration >> windowsThemeName [

	^ 'Windows-10-master'
]
