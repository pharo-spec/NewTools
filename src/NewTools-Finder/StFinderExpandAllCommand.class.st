"
Command to open a settings browser focused on the Finder settings.
"
Class {
	#name : 'StFinderExpandAllCommand',
	#superclass : 'StFinderListingCommand',
	#category : 'NewTools-Finder-Commands',
	#package : 'NewTools-Finder',
	#tag : 'Commands'
}

{ #category : 'default' }
StFinderExpandAllCommand class >> defaultDescription [

	^ 'Command to expand all displayed finder results.'
]

{ #category : 'default' }
StFinderExpandAllCommand class >> defaultIconName [

	^ #expandBox
]

{ #category : 'default' }
StFinderExpandAllCommand class >> defaultName [ 

	^ 'Expand all'
]

{ #category : 'default' }
StFinderExpandAllCommand class >> defaultShortcut [

	^ $x meta
]

{ #category : 'executing' }
StFinderExpandAllCommand >> execute [

	self resultTree expandAll.
]
