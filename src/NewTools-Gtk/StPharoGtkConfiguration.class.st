Class {
	#name : #StPharoGtkConfiguration,
	#superclass : #SpApplicationConfiguration,
	#category : #'NewTools-Gtk'
}

{ #category : #'as yet unclassified' }
StPharoGtkConfiguration class >> cssProviderCodePropertyName [

	^ #cssProviderCode
]

{ #category : #configuring }
StPharoGtkConfiguration >> configureOSX: anApplication [

	self installTheme: 'Sierra-dark'.
	 "self installTheme: 'Sierra-light'".
	
	anApplication cssProviderCode: (GtkCssProvider newFromString: '* { font: 12pt "Monaco" }')
]

{ #category : #configuring }
StPharoGtkConfiguration >> configureUnix: anApplication [

	anApplication cssProviderCode: (GtkCssProvider newFromString: '* { font: 12pt "Sans" }')
]

{ #category : #configuring }
StPharoGtkConfiguration >> configureWindows: anApplication [

	self installTheme: 'Windows-10-master'.
	
	anApplication cssProviderCode: (GtkCssProvider newFromString: '* { font: 10pt "Microsoft Sans Serif" }')
]

{ #category : #'private running' }
StPharoGtkConfiguration >> installTheme: aString [

	GtkSettings default themeName: aString
]
