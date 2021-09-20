Extension { #name : #HelpTopic }

{ #category : #'*NewTools-Spotter-Processors' }
HelpTopic >> stActDefault [
	HelpBrowser openOn: self
]

{ #category : #'*NewTools-Spotter-Processors' }
HelpTopic >> stAllSubtopics [

	 ^ self subtopics flatCollect: [:aTopic |
		aTopic asOrderedCollection, aTopic stAllSubtopics ]
		 
]

{ #category : #'*NewTools-Spotter-Processors' }
HelpTopic >> stTopicIcon [
	^ self hasSubtopics
		ifTrue: [ Smalltalk ui icons iconNamed: #bookIcon ]
		ifFalse: [ Smalltalk ui icons iconNamed: #pageIcon ]
]
