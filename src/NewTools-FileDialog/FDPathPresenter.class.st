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
	#name : #FDPathPresenter,
	#superclass : #SpPresenter,
	#traits : 'TSpDynamicPresenter',
	#classTraits : 'TSpDynamicPresenter classTrait',
	#instVars : [
		'action',
		'count'
	],
	#category : #'NewTools-FileDialog-UI'
}

{ #category : #accessing }
FDPathPresenter >> action: anObject [
	action := anObject
]

{ #category : #accessing }
FDPathPresenter >> addLinkTo: aPath [
	^ self
		addPresenter:
			(SpLinkPresenter new
				action: [ action value: aPath asFileReference ];
				label: aPath basename;
				yourself)
]

{ #category : #accessing }
FDPathPresenter >> addPresenter: aPresenter [
	self presenterAt: count asString put: aPresenter.
	count := count + 1
]

{ #category : #accessing }
FDPathPresenter >> addSeparator [
	^ self
		addPresenter:
			(SpLabelPresenter new
				label: '/';
				yourself)
]

{ #category : #accessing }
FDPathPresenter >> file: aFile [
	count := 0.
	self basicPresenters removeAll.
	aFile asAbsolute fullPath withParents do: [ :path | self addLinkTo: path ] separatedBy: [ self addSeparator ]
]

{ #category : #accessing }
FDPathPresenter >> layout [
	| l |
	l := SpBoxLayout newHorizontal.
	self presentersDo: [ :p | l add: p expand: false fill: false padding: 0 ].
	^ l
]
