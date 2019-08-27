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

	 self installTheme: self macThemeName.
	
	anApplication 
		propertyAt: self class cssProviderCodePropertyName  
		put: (GtkCssProvider newFromString: '* { font: 12pt "Monaco" }')
]

{ #category : #configuring }
StPharoGtkConfiguration >> configureUnix: anApplication [

	anApplication 
		propertyAt: self class cssProviderCodePropertyName  
		put: (GtkCssProvider newFromString: '* { font: 12pt "Sans" }')
]

{ #category : #configuring }
StPharoGtkConfiguration >> configureWindows: anApplication [

	self installTheme: self windowsThemeName.
	
	anApplication 
		propertyAt: self class cssProviderCodePropertyName  
		put: (GtkCssProvider newFromString: '* { font: 10pt "Microsoft Sans Serif" }')
]

{ #category : #'private running' }
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
