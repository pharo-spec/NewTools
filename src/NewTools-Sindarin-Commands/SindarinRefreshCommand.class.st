Class {
	#name : #SindarinRefreshCommand,
	#superclass : #SindarinCommand,
	#category : #'NewTools-Sindarin-Commands'
}

{ #category : #'accessing - defaults' }
SindarinRefreshCommand class >> defaultDescription [
	^ 'Refresh the UI. Necessary after manual control of Sindarin.'
]

{ #category : #'accessing - defaults' }
SindarinRefreshCommand class >> defaultIconName [
	^#refresh 
]

{ #category : #'accessing - defaults' }
SindarinRefreshCommand class >> defaultName [
	^ 'Refresh'
]

{ #category : #hooks }
SindarinRefreshCommand >> execute [
	self context refresh
]
