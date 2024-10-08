"
I am an abstract adapter for tallies (from different system profilers) to be used by the ProfilerPresenter
"
Class {
	#name : 'StTallyModel',
	#superclass : 'MorphTreeNodeModel',
	#category : 'NewTools-ProfilerUI-Model',
	#package : 'NewTools-ProfilerUI',
	#tag : 'Model'
}

{ #category : 'comparing' }
StTallyModel >> <= aTallyModelAndreas [
	^ self item tally <= aTallyModelAndreas item tally
]

{ #category : 'comparing' }
StTallyModel >> = aTallyModel [

	^ self item tally = aTallyModel item tally and: [
		  self item class = aTallyModel item class and: [
			self item method = aTallyModel item method ] ]
]

{ #category : 'converting' }
StTallyModel >> asString [

	^ [ self reportString ]
		  on: Error
		  do: [ 'error printing' ]
]

{ #category : 'transforming' }
StTallyModel >> asTallyModel [
	^ self
]

{ #category : 'actions' }
StTallyModel >> browseItem [
	self item originMethod browse
]

{ #category : 'accessing' }
StTallyModel >> childrenItems [

	| perCent threshold |
	model tallyRoot ifNil: [ ^ #(  ) ].

	perCent := model showNodeThreshold.
	threshold := (perCent asFloat / 100 * model tallyRoot tally) rounded.

	^ (self item sonsOver: threshold) asSortedCollection
]

{ #category : 'accessing' }
StTallyModel >> data [
	^ self
]

{ #category : 'accessing' }
StTallyModel >> detectPathOfMethodSelector: aMethodSelector maxDepth: aMaxDepth [

	aMaxDepth < 0 ifTrue: [ ^ #(  ) ].
	self methodSelector = aMethodSelector ifTrue: [ ^ Array with: self ].

	self sons do: [ :each |
		| path |
		path := each
			        detectPathOfMethodSelector: aMethodSelector
			        maxDepth: aMaxDepth - 1.
		path ifNotEmpty: [ ^ (Array with: self) , path ] ].

	^ #(  )
]

{ #category : 'actions' }
StTallyModel >> inspectItem [
	self inspect
]

{ #category : 'event handling' }
StTallyModel >> keyDown: anEvent from: aTreeMorph [
	| c |
	c := anEvent keyCharacter.
	c = $b
		ifTrue: [self browseItem. ^ true].
	c = $i
		ifTrue: [self inspectItem. ^ true].
	^ false
]

{ #category : 'collecting leaves' }
StTallyModel >> leavesInto: aCollection fromSender: anObject [

	item leavesInto: aCollection fromSender: anObject.
	aCollection associationsDo: [ :assoc |
		assoc value: (assoc value asTallyModel
				 model: model;
				 yourself) ]
]

{ #category : 'menu' }
StTallyModel >> menu: menu shifted: b [
	(menu
		add: 'Browse (b)'
		target: self
		selector: #browseItem) icon: (self iconNamed: #browse).
	(menu
		add: 'Inspect (i)'
		target: self
		selector: #inspectItem) icon: (self iconNamed: #inspect)
]

{ #category : 'accessing' }
StTallyModel >> methodClassName [

	^ item methodClassName
]

{ #category : 'accessing' }
StTallyModel >> methodName [

	^ self methodClassName , '>>' , self methodSelector
]

{ #category : 'accessing' }
StTallyModel >> methodOrBlock [

	^ item ifNotNil: [ :theItem | theItem method ]
]

{ #category : 'accessing' }
StTallyModel >> methodSelector [

	^ item method ifNotNil: [ item method selector ] ifNil: [ 'nil' ]
]

{ #category : 'path' }
StTallyModel >> relativePath [

	| rootPath |
	rootPath := model tallyRoot path.

	rootPath doWithIndex: [ :each :index |
		self assert: each = (self path at: index) ].
	^ self path copyFrom: rootPath size to: self path size
]

{ #category : 'querying' }
StTallyModel >> reportString [

	^ (self weightToRoot printShowingDecimalPlaces: 1) , '% {'
	  , (self time printShowingDecimalPlaces: 1) , 'ms} ' , self methodName
]

{ #category : 'querying' }
StTallyModel >> sons [

	^ self sonsOver: 0
]

{ #category : 'accessing' }
StTallyModel >> sonsOver: minTally [
	^ (item sonsOver: minTally) collect: [ :each |
		  each asTallyModel
			  model: model;
			  yourself ]
]

{ #category : 'accessing' }
StTallyModel >> tally [
	^ item tally
]

{ #category : 'accessing' }
StTallyModel >> time [
	^ (self weight * self model totalTime / 100)
]

{ #category : 'accessing' }
StTallyModel >> weight [
	self tally isZero ifTrue: [ ^ 0 ].
	^ self tally asFloat / model totalTally * 100.0
]

{ #category : 'accessing' }
StTallyModel >> weightToRoot [
	self tally isZero ifTrue: [ ^ 0 ].
	model tallyRoot tally isZero ifTrue: [ self error: 'this shouldnt happen' ].
	^ self tally asFloat / model tallyRoot tally * 100.0
]
