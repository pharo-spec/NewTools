"
This is a JobManager to work with the Jobs package. 
This manager will listen to the announcer and fire the events as it corresponds, allowing the user to interact with the joblist tool.


"
Class {
	#name : 'StPharoJobManager',
	#superclass : 'Object',
	#classTraits : '{} + TraitedClass',
	#category : 'NewTools-Core-Application',
	#package : 'NewTools-Core',
	#tag : 'Application'
}

{ #category : 'private' }
StPharoJobManager class >> application [

	self flag: #TODO. "Not cool, but well... better than extend the StPharoApplication. 
	At least this side is contained."
	^ StPharoApplication current
]

{ #category : 'accessing' }
StPharoJobManager class >> disable [
	<script>
	
	Job jobAnnouncer unsubscribe: self
]

{ #category : 'accessing' }
StPharoJobManager class >> enable [
	<script>

	Job jobAnnouncer
		when: JobStart send: #jobStart: to: self;
		when: JobChange send: #jobChanged: to: self;
		when: JobEnd send: #jobEnd: to: self
]

{ #category : 'initialization' }
StPharoJobManager class >> initialize [

	self enable
]

{ #category : 'private - events' }
StPharoJobManager class >> jobChanged: ann [

	self jobList jobChanged: ann
]

{ #category : 'private - events' }
StPharoJobManager class >> jobEnd: ann [

	self jobList jobEnd: ann.
	"this is just a cleanup... because jobs may leak!"
	self jobList isEmpty
		ifTrue: [ self application removeProperty: #jobList ]
]

{ #category : 'private' }
StPharoJobManager class >> jobList [

	^ self application jobList
]

{ #category : 'private - events' }
StPharoJobManager class >> jobStart: ann [

	self jobList jobStart: ann
]
