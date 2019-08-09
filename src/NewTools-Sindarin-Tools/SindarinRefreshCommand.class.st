Class {
	#name : #SindarinRefreshCommand,
	#superclass : #SindarinCommand,
	#category : #'NewTools-Sindarin-Tools'
}

{ #category : #default }
SindarinRefreshCommand class >> defaultCommandName [
	^ 'Refresh'
]

{ #category : #default }
SindarinRefreshCommand class >> defaultDescription [
	^ 'Refresh the UI. Necessary after manual control of Sindarin.'
]

{ #category : #initialization }
SindarinRefreshCommand class >> defaultIconName [
	^#refresh 
]

{ #category : #hooks }
SindarinRefreshCommand >> execute [
	self context refresh
]
