Class {
	#name : #StWinPlatform,
	#superclass : #StPlatform,
	#category : #'NewTools-Core'
}

{ #category : #testing }
StWinPlatform class >> isAvailable [

	^ Smalltalk os isWindows
]

{ #category : #accessing }
StWinPlatform >> defaultTheme [

	^ 'Windows-10-master'
]
