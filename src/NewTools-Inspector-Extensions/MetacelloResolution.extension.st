Extension { #name : 'MetacelloResolution' }

{ #category : '*NewTools-Inspector-Extensions' }
MetacelloResolution >> inspectionFindings: aBuilder [
	"The findings as a tree: errors, warnings and infos, then their kinds, then the findings, with how many each holds and the icon of their severity"

	<inspectorPresentationOrder: 0 title: 'Findings'>
	| groups icons severityOf |
	groups := (#( #error #warning #info ) collect: [ :severity |
			           (self descriptionOfSeverity: severity)
			           ->
				           (((findings select: [ :each | each severity = severity ]) groupedBy: [ :each | self descriptionOfKind: each kind ])
					            associations sort: [ :a :b | a key <= b key ]) ]) reject: [ :each | each value isEmpty ].
	icons := {
		         (#error -> #smallError).
		         (#warning -> #smallWarning).
		         (#info -> #smallInfo) } asDictionary.
	severityOf := [ :node |
		              (node isKindOf: Association)
			              ifTrue: [
					              node value first isAssociation
						              ifTrue: [ node value first value first severity ]
						              ifFalse: [ node value first severity ] ]
			              ifFalse: [ node severity ] ].
	^ aBuilder newTree
		  roots: groups;
		  children: [ :node |
				  (node isKindOf: Association)
					  ifTrue: [ node value ]
					  ifFalse: [ #(  ) ] ];
		  display: [ :node |
				  (node isKindOf: Association)
					  ifTrue: [
							  node key , ' (' , (node value first isAssociation
									   ifTrue: [ (node value inject: 0 into: [ :sum :each | sum + each value size ]) printString ]
									   ifFalse: [ node value size printString ]) , ')' ]
					  ifFalse: [ node text ] ];
		  displayIcon: [ :node | self iconNamed: (icons at: (severityOf value: node)) ];
		  expandRoots;
		  yourself
]
