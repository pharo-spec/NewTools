Class {
	#name : #FBMockUseToTestDoubleClickAction,
	#superclass : #Object,
	#instVars : [
		'isOpenInBrowserCall'
	],
	#category : #'NewTools-FlagBrowser-Tests-Presenters'
}

{ #category : #accessing }
FBMockUseToTestDoubleClickAction >> isOpenInBrowserCall [
	^ isOpenInBrowserCall
]

{ #category : #'as yet unclassified' }
FBMockUseToTestDoubleClickAction >> openInBrowser [
	isOpenInBrowserCall := true
]
