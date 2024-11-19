"
I am a presenter representing a path in a file dialog. 

I'll display a link with each part of the path and the user will be able to click on them to launch an action provided as parameter.

## Examples

```smalltalk
	path := self instantiate: StFBPathPresenter.
	path action: [ :fileReference | self display: aFileReference ].
```

## Internal Representation and Key Implementation Points.

### Instance Variables

- action:				<aValuable>		An action to launch when the user click on a link
- count:					<anInteger>		A counter used internaly to have unique ids for my subparts.

"
Class {
	#name : 'StPathPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'action'
	],
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'accessing' }
StPathPresenter >> action: aValuable [
	action := aValuable
]

{ #category : 'accessing' }
StPathPresenter >> addLinkTo: aPath [

	^ self addPresenter: (self newLink
			   action: [ action value: aPath asFileReference ];
			   label: (self labelFor: aPath);
			   yourself)
]

{ #category : 'accessing' }
StPathPresenter >> addPresenter: aPresenter [

	self layout
		add: aPresenter
		expand: false
		fill: false
		padding: 0
]

{ #category : 'accessing' }
StPathPresenter >> addSeparator [

	^ self addPresenter: (self newLabel
			   label: '/';
			   yourself)
]

{ #category : 'accessing' }
StPathPresenter >> file: aFile [

	| parts |
	self initializeLayout.
	parts := aFile asAbsolute fullPath withParents.
	Smalltalk os isWindows ifTrue: [
		parts first isRoot ifTrue: [ parts := parts copyWithoutFirst ] ].
	parts
		do: [ :path | self addLinkTo: path ]
		separatedBy: [ self addSeparator ]
]

{ #category : 'initialization' }
StPathPresenter >> initializeLayout [

	^ layout := SpBoxLayout newLeftToRight
]

{ #category : 'accessing' }
StPathPresenter >> labelFor: aPath [

	^ aPath basename = '/'
		ifFalse: [ aPath basename ]
		ifTrue: [ 'Root' ]
]

{ #category : 'accessing' }
StPathPresenter >> layout [

	^ super layout ifNil: [ self initializeLayout ]
]
