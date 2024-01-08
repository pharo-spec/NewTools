Class {
	#name : 'StMessageVersionListPresenter',
	#superclass : 'StMessageListPresenter',
	#category : 'NewTools-MethodBrowsers-Versions',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Versions'
}

{ #category : 'private' }
StMessageVersionListPresenter >> authorOf: anItem [
	^ anItem author
]

{ #category : 'actions' }
StMessageVersionListPresenter >> doCompareToCurrentVersion [
	
	self owner doCompareToCurrentVersion
]

{ #category : 'actions' }
StMessageVersionListPresenter >> doCompareToOtherVersion [
	
	self owner doCompareToOtherVersion

]

{ #category : 'actions' }
StMessageVersionListPresenter >> doRevert [
	
	self owner doRevert
]

{ #category : 'initialization' }
StMessageVersionListPresenter >> initializePresenters [

	super initializePresenters.
	
	listPresenter addColumn: (SpStringTableColumn 
		title: 'Timestamp' 
		evaluated: [ :item | self timeStampOf: item ])
]

{ #category : 'private' }
StMessageVersionListPresenter >> messageListActions [

	^ CmCommandGroup forSpec
		beRoot;
		register: ((CmCommandGroup forSpecNamed: 'Compare')
			beDisplayedAsGroup;
			register: (StVersionCompareToCurrentCommand forSpecContext: self);
			register: (StVersionCompareToVersionCommand forSpecContext: self);
			yourself);
		register: ((CmCommandGroup forSpecNamed: 'Navigation')
			beDisplayedAsGroup;
			register: (StMessageSendersCommand forSpecContext: self);
			register: (StMessageImplementorsCommand forSpecContext: self);
			yourself);
		register: ((CmCommandGroup forSpecNamed: 'CRITICAL')
			beDisplayedAsGroup;
			register: (StVersionRevertCommand forSpecContext: self);
			yourself)	;
		yourself

]

{ #category : 'private' }
StMessageVersionListPresenter >> timeStampOf: anItem [
	^ anItem timeStamp
]
