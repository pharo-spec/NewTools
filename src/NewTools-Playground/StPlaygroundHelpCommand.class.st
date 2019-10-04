Class {
	#name : #StPlaygroundHelpCommand,
	#superclass : #StPlaygroundCommand,
	#category : #'NewTools-Playground-Command'
}

{ #category : #converting }
StPlaygroundHelpCommand >> asSpecCommand [ 
	
	^ super asSpecCommand 
		iconName: #glamorousHelp;
		yourself

]

{ #category : #execution }
StPlaygroundHelpCommand >> execute [ 

	HelpBrowser open selectTopicSatisfying: [:each |
		each owner notNil 
			and: [ (each owner key = GTPlaygroundHelp key) 
			and: [ each title = 'Overview' ] ] ]
]

{ #category : #initialization }
StPlaygroundHelpCommand >> initialize [ 
	
	super initialize.
	self 
		basicName: 'Help';
		basicDescription: 'Open help browser.'
]
