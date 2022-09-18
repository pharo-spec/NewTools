Extension { #name : #Object }

{ #category : #'*NewTools-Inspector-Extensions' }
Object >> asInspectorModel [

	^ StInspectorModel on: self
]

{ #category : #'*NewTools-Inspector-Extensions' }
Object >> defaultObjectInspectorClass [

	^ StObjectInspectorPresenter
]

{ #category : #'*NewTools-Inspector-Extensions' }
Object >> inspectionMeta [
	<inspectorPresentationOrder: 999 title: 'Meta'>

	^ StMetaBrowser on: self
]

{ #category : #'*NewTools-Inspector-Extensions' }
Object >> inspectionMetaContext: aContext [

	aContext withoutEvaluator
]

{ #category : #'*NewTools-Inspector-Extensions' }
Object >> inspectorNodes [
	"Answer a list of attributes as nodes"
	
	^ (StNodeCollector for: self) collectNodes
]

{ #category : #'*NewTools-Inspector-Extensions' }
Object >> stDisplayString [

	^ StObjectPrinter asTruncatedTextFrom: self
]

{ #category : #'*NewTools-Inspector-Extensions' }
Object >> stDisplayStringFull [

	^ StObjectPrinter asNonTruncatedTextFrom: self
]
