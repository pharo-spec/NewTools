"
I am a presenter representing a path in a file dialog. 

I'll display a link with each part of the path and the user will be able to click on them to launch an action provided as parameter.

Examples
--------------------

	path := self instantiate: FDPathPresenter.
	path action: [ :fileReference | self display: aFileReference ].
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	action:				<aValuable>		An action to launch when the user click on a link
	count:					<anInteger>		A counter used internaly to have unique ids for my subparts.

"
Class {
	#name : 'StFBPathPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'action',
		'count'
	],
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'accessing' }
StFBPathPresenter >> action: aValuable [
	action := aValuable
]

{ #category : 'accessing' }
StFBPathPresenter >> addLinkTo: aPath [

	^ self addPresenter: (self newLink
			   action: [ action value: aPath asFileReference ];
			   label: aPath basename;
			   yourself)
]

{ #category : 'accessing' }
StFBPathPresenter >> addPresenter: aPresenter [

	self layout
		add: aPresenter
		expand: false
		fill: false
		padding: 0
]

{ #category : 'accessing' }
StFBPathPresenter >> addSeparator [

	^ self addPresenter: (self newLabel
			   label: '/';
			   yourself)
]

{ #category : 'accessing' }
StFBPathPresenter >> file: aFile [

	self initializeLayout.
	aFile asAbsolute fullPath withParents
		do: [ :path | self addLinkTo: path ]
		separatedBy: [ self addSeparator ]
]

{ #category : 'initialization' }
StFBPathPresenter >> initializeLayout [

	^ layout := SpBoxLayout newLeftToRight
]

{ #category : 'accessing' }
StFBPathPresenter >> layout [

	^ super layout ifNil: [ self initializeLayout ]
]
