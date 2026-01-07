Class {
	#name : 'StMethodVersionListPresenter',
	#superclass : 'StMethodListPresenter',
	#category : 'NewTools-MethodBrowsers-Versions',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Versions'
}

{ #category : 'private' }
StMethodVersionListPresenter >> authorOf: anItem [
	^ anItem author
]

{ #category : 'actions' }
StMethodVersionListPresenter >> doCompareToCurrentVersion [
	
	self owner doCompareToCurrentVersion
]

{ #category : 'actions' }
StMethodVersionListPresenter >> doCompareToOtherVersion [
	
	self owner doCompareToOtherVersion

]

{ #category : 'actions' }
StMethodVersionListPresenter >> doRevert [
	
	self owner doRevert
]

{ #category : 'initialization' }
StMethodVersionListPresenter >> initializePresenters [

	super initializePresenters.
	
	listPresenter addColumn: (SpStringTableColumn 
		title: 'Timestamp' 
		evaluated: [ :item | self timeStampOf: item ])
]

{ #category : 'private' }
StMethodVersionListPresenter >> methodListActions [

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
			register: (StImplementorsCommand forSpecContext: self);
			yourself);
		register: ((CmCommandGroup forSpecNamed: 'CRITICAL')
			beDisplayedAsGroup;
			register: (StVersionRevertCommand forSpecContext: self);
			yourself)	;
		yourself

]

{ #category : 'private' }
StMethodVersionListPresenter >> timeStampOf: anItem [
	^ anItem timeStamp
]
