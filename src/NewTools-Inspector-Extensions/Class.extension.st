Extension { #name : #Class }

{ #category : #'*NewTools-Inspector-Extensions' }
Class >> allReferencesInspection [

	<inspectorPresentationOrder: 20>
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

{ #category : #'*NewTools-Inspector-Extensions' }
Class >> classCommentInspection [
	"This provides an editable comment of the current class"

	<inspectorPresentationOrder: 20>
	^ TextPresenter new
		title: 'Comment';
		text: self comment;
		acceptBlock: [ :text | self comment: text stamp: Author changeStamp ]
]

{ #category : #'*NewTools-Inspector-Extensions' }
Class >> classDefinitionInspection [
	"This provides an editable comment of the current class"

	<inspectorPresentationOrder: 15>
	^ CodePresenter new
		title: 'Definition';
		text: self definition;
		disable
]
