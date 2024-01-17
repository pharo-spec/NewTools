"
Command to open a settings browser focused on the Finder settings.
"
Class {
	#name : 'StFinderCollapseAllCommand',
	#superclass : 'StFinderListingCommand',
	#category : 'NewTools-Finder-Commands',
	#package : 'NewTools-Finder',
	#tag : 'Commands'
}

{ #category : 'default' }
StFinderCollapseAllCommand class >> defaultDescription [

	^ 'Command to collapse all displayed results'
]

{ #category : 'default' }
StFinderCollapseAllCommand class >> defaultIconName [

	^ #refresh
]

{ #category : 'default' }
StFinderCollapseAllCommand class >> defaultName [ 

	^ 'Collapse all'
]

{ #category : 'default' }
StFinderCollapseAllCommand class >> defaultShortcut [

	^ $c meta
]

{ #category : 'executing' }
StFinderCollapseAllCommand >> execute [

	self resultTree collapseAll.
]
