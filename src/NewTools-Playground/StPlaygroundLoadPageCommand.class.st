Class {
	#name : #StPlaygroundLoadPageCommand,
	#superclass : #StPlaygroundCommand,
	#category : #'NewTools-Playground-View'
}

{ #category : #default }
StPlaygroundLoadPageCommand class >> defaultDescription [

	^ 'Load page contents in current playground'
]

{ #category : #default }
StPlaygroundLoadPageCommand class >> defaultName [

	^ 'Load'
]

{ #category : #executing }
StPlaygroundLoadPageCommand >> execute [

	self context doLoadPage
]
