Extension { #name : #Class }

{ #category : #'*NewTools-Inspector-Extensions' }
Class >> allReferencesInspection [

	<inspectorPresentationOrder: 2>
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
	
	treeTable := TreeTablePresenter new.	
	treeTable
		title: 'All References';
		roots: allClassesReferencing;
		children: childrenBlock.
	treeTable addColumn: (StringTableColumn title: 'References' evaluated: #name).
	^ treeTable
]
