Class {
	#name : #StSettingsCommand,
	#superclass : #StPlaygroundCommand,
	#category : #'NewTools-Playground-Command'
}

{ #category : #converting }
StSettingsCommand >> asSpecCommand [ 
	
	^ super asSpecCommand 
		iconName: #configuration;
		yourself

]

{ #category : #execution }
StSettingsCommand >> execute [ 

	SettingBrowser new 
		changePackageSet: { (RPackageOrganizer default packageNamed: 'GT-Playground') }; 
		open; 
		expandAll	
]

{ #category : #initialization }
StSettingsCommand >> initialize [ 
	
	super initialize.
	self 
		basicName: 'Settings';
		basicDescription: 'Open settings browser.'
]
