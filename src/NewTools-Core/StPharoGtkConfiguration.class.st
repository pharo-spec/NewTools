Class {
	#name : #StPharoGtkConfiguration,
	#superclass : #SpecApplicationConfiguration,
	#instVars : [
		'platform'
	],
	#category : #'NewTools-Core'
}

{ #category : #initialization }
StPharoGtkConfiguration >> initialize [

	super initialize.
	platform := StPlatform newForPlatform
]

{ #category : #'private running' }
StPharoGtkConfiguration >> installTheme [

	GtkSettings default themeName: self platform defaultTheme
]

{ #category : #accessing }
StPharoGtkConfiguration >> platform [ 

	^ platform
]
