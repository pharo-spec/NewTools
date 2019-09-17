Class {
	#name : #StMillerListPresenter,
	#superclass : #SpMillerColumnPresenter,
	#instVars : [
		'paginator',
		'pageSize',
		'shownPages',
		'pages'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #defaults }
StMillerListPresenter class >> defaultPageSize [

	^ 300
]

{ #category : #defaults }
StMillerListPresenter class >> defaultShowPages [

	^ 2
]

{ #category : #initialization }
StMillerListPresenter >> addPresenter: aPagePresenter [
	| newPageSize |

	newPageSize := self recalculateSizeForPages: pages size + 1.
	self updateForPages: pages size + 1.
	self basicAddPresenter: aPagePresenter size: newPageSize.
	pages add: aPagePresenter.

	aPagePresenter takeKeyboardFocus
]

{ #category : #private }
StMillerListPresenter >> basicAddPresenter: aPagePresenter size: aNumber [
	
	aPagePresenter owner: self.
	layout 
		add: aPagePresenter
		withConstraints: [ :constraint | 
			constraint 
				expand: false; 
				height: aNumber ]
]

{ #category : #initialization }
StMillerListPresenter >> initialize [ 

	pages := OrderedCollection new.
	super initialize
]

{ #category : #initialization }
StMillerListPresenter >> initializePresenters [
	
	layout := SpBoxLayout newVertical
]

{ #category : #initialization }
StMillerListPresenter >> newPresenterFor: aModel [
	| pagePresenter contentPresenter |
	
	contentPresenter := super newPresenterFor: aModel.
	pagePresenter := SpPlaybookMillerPagePresenter 
		newModel: aModel
		presenter: contentPresenter.
		
	pagePresenter onExpand: [ 
		self changeSelection: aModel from: pagePresenter ].
		
	^ pagePresenter
]

{ #category : #accessing }
StMillerListPresenter >> pageSize [

	^ pageSize ifNil: [ pageSize := self class defaultPageSize ]
]

{ #category : #accessing }
StMillerListPresenter >> pageSize: aNumber [

	pageSize := aNumber.
	self reset
]

{ #category : #accessing }
StMillerListPresenter >> pages [

	^ pages
]

{ #category : #accessing }
StMillerListPresenter >> paginator: aPaginator [

	"To avoid cycles"
	paginator = aPaginator ifTrue: [ ^ self ].
	
	paginator := aPaginator.
	aPaginator millerList: self
]

{ #category : #private }
StMillerListPresenter >> recalculateSizeForPages: aNumber [
	
	^ aNumber > 1
		ifTrue: [ (self pageSize / (aNumber min: self shownPages)) asInteger ]
		ifFalse:[ self pageSize ]
]

{ #category : #private }
StMillerListPresenter >> reset [

	self updateForPages: pages size
]

{ #category : #private }
StMillerListPresenter >> resetTo: aNumber [

	super resetTo: aNumber.
	pages := pages first: aNumber	
]

{ #category : #accessing }
StMillerListPresenter >> shownPages [
	
	^ shownPages ifNil: [ shownPages := self class defaultShowPages ]
]

{ #category : #accessing }
StMillerListPresenter >> shownPages: aNumber [
	
	shownPages := aNumber.
	self reset
]

{ #category : #private }
StMillerListPresenter >> updateForPages: aNumber [
	| newPageSize |

	newPageSize := self recalculateSizeForPages: aNumber.
	newPageSize = self pageSize 
		ifFalse: [ self updatePageSizesTo: newPageSize ]
]

{ #category : #private }
StMillerListPresenter >> updatePageSizesTo: aNumber [

	layout removeAll.
	pages do: [ :each | 
		self basicAddPresenter: each size: aNumber ]
]
