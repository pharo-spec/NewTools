Class {
	#name : #StSettingsCommand,
	#superclass : #LtCommand,
	#category : #'NewTools-Playground-Command'
}

{ #category : #accessing }
StSettingsCommand class >> activations [

	^ { self toolBarActivation }
]

{ #category : #accessing }
StSettingsCommand class >> toolBarActivation [

	^ LtToolBarActivation new 
		order: 30;
		bePositionRight;
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
		addGroup: StPlaygroundCommandGroup uniqueInstance;
		name: 'Settings';
		description: 'Open settings browser.';
		iconName: #configuration
]
