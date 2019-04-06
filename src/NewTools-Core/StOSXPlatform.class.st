Class {
	#name : #StOSXPlatform,
	#superclass : #StPlatform,
	#category : #'NewTools-Core'
}

{ #category : #testing }
StOSXPlatform class >> isAvailable [

	^ Smalltalk os isMacOS
]

{ #category : #accessing }
StOSXPlatform >> defaultTheme [
	"There are several available: 
		- Sierra-light
		- Sierra-dark
		- McOS-MJV-Light-1.2
		- McOS-MJV-Dark-1.2"

	^ 'Sierra-dark-solid-thin'
]
