Class {
	#name : #StPlaygroundHelpCommand,
	#superclass : #LtCommand,
	#category : #'NewTools-Playground-Command'
}

{ #category : #accessing }
StPlaygroundHelpCommand class >> activations [

	^ { self toolBarActivation }
]

{ #category : #accessing }
StPlaygroundHelpCommand class >> toolBarActivation [

	^ LtToolBarActivation new 
		order: 10;
		bePositionRight;
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
		addGroup: StPlaygroundCommandGroup uniqueInstance;
		name: 'Help';
		description: 'Open help browser.';
		iconName: #glamorousHelp
]
