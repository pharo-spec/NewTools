"
The application for the Pharo IDE.
"
Class {
	#name : 'StPharoApplication',
	#superclass : 'SpApplication',
	#classVars : [
		'Current'
	],
	#category : 'NewTools-Core-Application',
	#package : 'NewTools-Core',
	#tag : 'Application'
}

{ #category : 'instance creation' }
StPharoApplication class >> current [ 
	
	^ Current ifNil: [ Current := self new ]
]

{ #category : 'class initialization' }
StPharoApplication class >> initialize [ 

	SessionManager default registerToolClassNamed: self name
]

{ #category : 'system startup' }
StPharoApplication class >> shutDown: quitting [

	Current ifNil: [ ^ self ].
	Current shutDown: quitting
]

{ #category : 'system startup' }
StPharoApplication class >> startUp: resuming [

	Current ifNil: [ ^ self ].
	Current startUp: resuming
]

{ #category : 'private' }
StPharoApplication class >> use: application during: aBlock [ 
	| oldCurrent |
	
	oldCurrent := Current.
	Current := application.
	^ aBlock ensure: [ Current := oldCurrent ]
]

{ #category : 'accessing - resources' }
StPharoApplication >> defaultWindowExtent [
	
	self flag: #TODO. "Replace this with a real real estate"
	^ 800@600
]

{ #category : 'initialization' }
StPharoApplication >> initialize [

	super initialize.
	self initializeConfiguration.
	self initializeJobListener
]

{ #category : 'initialization' }
StPharoApplication >> initializeConfiguration [

	self resetConfiguration.
	SystemAnnouncer uniqueInstance weak 
		when: UIThemeChanged 
		send: #resetConfiguration
		to: self
]

{ #category : 'initialization' }
StPharoApplication >> initializeJobListener [

	Job jobAnnouncer weak
		when: JobStart send: #jobStart: to: self jobList;
		when: JobChange send: #jobChanged: to: self jobList;
		when: JobEnd send: #jobEnd: to: self jobList
]

{ #category : 'private - factory' }
StPharoApplication >> newIconProvider [

	^ StPharoDefaultIconProvider new
]

{ #category : 'accessing' }
StPharoApplication >> pushJobWith: aBlock [

	self jobList pushJobWith: aBlock
]

{ #category : 'initialization' }
StPharoApplication >> resetConfiguration [
	
	self configuration reset
]

{ #category : 'running' }
StPharoApplication >> run [ 

	Current ifNotNil: [ Current close ].
	super run. 
	Current := self
]

{ #category : 'system startup' }
StPharoApplication >> shutDown: quitting [
]

{ #category : 'private - running' }
StPharoApplication >> start [

	
]

{ #category : 'system startup' }
StPharoApplication >> startUp: resuming [

	self resetConfiguration
]

{ #category : 'settings' }
StPharoApplication >> toolbarDisplayMode [

	^ StPharoSettings toolbarDisplayMode
]

{ #category : 'accessing - resources' }
StPharoApplication >> tools [

	^ Smalltalk tools
]
