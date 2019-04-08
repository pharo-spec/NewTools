Class {
	#name : #StPharoGtkConfiguration,
	#superclass : #SpecApplicationConfiguration,
	#category : #'NewTools-Core'
}

{ #category : #configuring }
StPharoGtkConfiguration >> configureOSX: anApplication [

	self installTheme: 'Sierra-dark'.
	"self installTheme: 'Sierra-light'"	
]

{ #category : #configuring }
StPharoGtkConfiguration >> configureWindows: anApplication [

	self installTheme: 'Windows-10-master'
]

{ #category : #'private running' }
StPharoGtkConfiguration >> installTheme: aString [

	GtkSettings default themeName: aString
]
