Class {
	#name : #FBMockFlagsListItems,
	#superclass : #Object,
	#instVars : [
		'title'
	],
	#category : #'NewTools-FlagBrowser-Tests-Presenters'
}

{ #category : #accessing }
FBMockFlagsListItems class >> title: aString [ 
	^ self new title: aString 
]

{ #category : #accessing }
FBMockFlagsListItems >> locations [ 
	^ title
]

{ #category : #'as yet unclassified' }
FBMockFlagsListItems >> parameter [
	^ title
]

{ #category : #accessing }
FBMockFlagsListItems >> title: aString [
	title := aString
]
