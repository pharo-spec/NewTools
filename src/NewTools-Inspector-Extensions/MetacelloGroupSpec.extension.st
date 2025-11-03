Extension { #name : 'MetacelloGroupSpec' }

{ #category : '*NewTools-Inspector-Extensions' }
MetacelloGroupSpec >> inspectionIncludes: aBuilder [
	<inspectorPresentationOrder: 10 title: 'Include'>
	| specs |

	specs := self project version spec packageSpecsInLoadOrder 
		select: [ :each | self includes includes: each name ].
		
	^ aBuilder newTable
		addStyle: 'stList';
		addColumn: (SpStringTableColumn 
			title: 'Type' 
			evaluated: [ :aSpec | aSpec type ]) 
			beNotExpandable;
		addColumn: (SpStringTableColumn 
			title: 'Name' 
			evaluated: [ :aSpec | aSpec name ]);
		items: (specs sorted: #type ascending, #name ascending);
		yourself	

]

{ #category : '*NewTools-Inspector-Extensions' }
MetacelloGroupSpec >> type [

	^ 'group'
]
