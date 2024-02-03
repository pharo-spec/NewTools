"
This is a JobManager to work with the Jobs package. 
This manager will listen to the announcer and fire the events as it corresponds, allowing the user to interact with the joblist tool.


"
Class {
	#name : 'StPharoJobManager',
	#superclass : 'Object',
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

{ #category : 'class initialization' }
StPharoJobManager class >> initialize [

	self enable
]

{ #category : 'private' }
StPharoJobManager class >> isHeadless [

	"this is a huge hack to know if we are running with an UI or not. 
	 I need it because this Jobs are created all around the world, and I need 
	 a control point."
	^ Smalltalk isInteractiveGraphic not
]

{ #category : 'private - events' }
StPharoJobManager class >> jobChanged: ann [

	self isHeadless ifTrue: [ ^ self ].
	self jobList jobChanged: ann
]

{ #category : 'private - events' }
StPharoJobManager class >> jobEnd: ann [

	self isHeadless ifTrue: [ ^ self ].
	self jobList jobEnd: ann
]

{ #category : 'private' }
StPharoJobManager class >> jobList [

	^ self application jobList
]

{ #category : 'private - events' }
StPharoJobManager class >> jobStart: ann [

	self isHeadless ifTrue: [ ^ self ].
	self jobList jobStart: ann
]
