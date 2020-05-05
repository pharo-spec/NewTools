Class {
	#name : #StPlaygroundPublishCommand,
	#superclass : #StPlaygroundCommand,
	#category : #'NewTools-Playground-Command'
}

{ #category : #default }
StPlaygroundPublishCommand class >> defaultDescription [

	^  'Publish contents to the cloud.'
]

{ #category : #accessing }
StPlaygroundPublishCommand class >> defaultIconName [

	^ #glamorousSaveToUrl
]

{ #category : #default }
StPlaygroundPublishCommand class >> defaultName [

	^ 'Publish'
]

{ #category : #execution }
StPlaygroundPublishCommand >> execute [ 

	self inform: #TODO.
]
