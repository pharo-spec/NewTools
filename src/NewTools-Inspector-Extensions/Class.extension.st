Extension { #name : 'Class' }

{ #category : '*NewTools-Inspector-Extensions' }
Class >> inspectionAllReferences: aBuilder [
	<inspectorPresentationOrder: 920 title: 'All References'>
	| allReferences allClassesReferencing sortBlock treeTable childrenBlock |
	
	allReferences := SystemNavigation default allReferencesTo: self binding.
	sortBlock := [ :x :y | x name < y name ].
	
	"Roots: classes with references to self binding"	
	allClassesReferencing := (allReferences
		collect: [ :rbMethodDef | rbMethodDef methodClass ]) asSet asSortedCollection: sortBlock.
	
	"Children: references from selected class"
	childrenBlock := [ :aClass | 
		(allReferences	select: [ :rbMethodDef | 
				rbMethodDef methodClass == aClass ])	asSortedCollection: sortBlock ].
	
	treeTable := aBuilder newTreeTable.	
	treeTable addStyle: 'stList'.
	treeTable
		roots: allClassesReferencing;
		children: childrenBlock.
	treeTable addColumn: (SpStringTableColumn title: 'References' evaluated: #name).
	
	^ treeTable
]

{ #category : '*NewTools-Inspector-Extensions' }
Class >> inspectionClassComment: aBuilder [
	"This provides an editable comment of the current class"
	<inspectorPresentationOrder: 920 title: 'Comment'>
	
	^ aBuilder newText
		text: self comment;
		whenSubmitDo: [ :text | self comment: text stamp: '' ]
]

{ #category : '*NewTools-Inspector-Extensions' }
Class >> inspectionClassDefinition: aBuilder [
	"This provides an editable comment of the current class"
	<inspectorPresentationOrder: 915 title: 'Definition'>
	
	^ aBuilder newCode
		addStyle: 'stCode';
	  	beForObject: self;
	  	text: self definitionString;
	  	whenSubmitDo: [ :code | (Smalltalk compiler evaluate: code) fluidInstall ]
]
