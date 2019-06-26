Class {
	#name : #FBMockUseToTestDoubleClickAction,
	#superclass : #Object,
	#instVars : [
		'isOpenInBrowserCall'
	],
	#category : #'NewTools-FlagBrowser-Tests-Presenters'
}

{ #category : #'as yet unclassified' }
FBMockUseToTestDoubleClickAction >> classLocation [
	^ 'test'.
]

{ #category : #'as yet unclassified' }
FBMockUseToTestDoubleClickAction >> initialize [
	isOpenInBrowserCall := false
]

{ #category : #'as yet unclassified' }
FBMockUseToTestDoubleClickAction >> interval [
	^ 1 to: 5
]

{ #category : #accessing }
FBMockUseToTestDoubleClickAction >> isOpenInBrowserCall [
	^ isOpenInBrowserCall
]

{ #category : #'as yet unclassified' }
FBMockUseToTestDoubleClickAction >> openInBrowser [
	isOpenInBrowserCall := true
]

{ #category : #'as yet unclassified' }
FBMockUseToTestDoubleClickAction >> sourceCode [
	^ 'test'
]
