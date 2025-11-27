"
This is an abstract class for to display nodes in a tree.
"
Class {
	#name : 'StNode',
	#superclass : 'Object',
	#instVars : [
		'treeModelParent',
		'cycle',
		'browser',
		'content',
		'parent'
	],
	#category : 'NewTools-DependencyAnalyser-UI-Nodes',
	#package : 'NewTools-DependencyAnalyser-UI',
	#tag : 'Nodes'
}

{ #category : 'testing' }
StNode class >> isAbstract [

	^ self == StNode
]

{ #category : 'building-menu' }
StNode >> addMenuActionsOn: anActionGroup [
	"overide this method to add contextual menu on nodes"
]

{ #category : 'browse-nautilus' }
StNode >> browseClass: classToBrowse [
	(Smalltalk tools toolNamed: #browser) openOnClass: classToBrowse
]

{ #category : 'accessing' }
StNode >> browser [
	^ browser
]

{ #category : 'accessing' }
StNode >> browser: anObject [
	browser := anObject
]

{ #category : 'private' }
StNode >> buildChildren [
	self flag: 'to remove'.

	^ self children value collect: [ :each || node |
		node := (each isKindOf: StNode)
			ifTrue: [ each ]
			ifFalse: [  (self childNodeClassFor: each) new
				content: each  ].
		node
			parentNode: self;
			yourself ]
]

{ #category : 'accessing' }
StNode >> children [
	^ #()
]

{ #category : 'accessing' }
StNode >> content [
	^ content
]

{ #category : 'accessing' }
StNode >> content: aDAPackage [
	content := aDAPackage
]

{ #category : 'accessing' }
StNode >> cycle: anObject [
	cycle := anObject
]

{ #category : 'testing' }
StNode >> isClassToDependencyNode [
	^ false
]

{ #category : 'testing' }
StNode >> isCycle [
	^ cycle
]

{ #category : 'testing' }
StNode >> isCycleNode [
	^ false
]

{ #category : 'testing' }
StNode >> isMethodImplementationNode [

	^ false
]

{ #category : 'testing' }
StNode >> isPackageNode [
 	^ false
]

{ #category : 'testing' }
StNode >> isReferenceNode [
	^ false
]

{ #category : 'displaying' }
StNode >> label [
	^ self content displayString
]

{ #category : 'accessing' }
StNode >> packageUnderAnalysis [

	^ self rootNode daPackage systemPackage
]

{ #category : 'accessing' }
StNode >> parentNode [
	^ parent
]

{ #category : 'accessing' }
StNode >> parentNode: aDANode [
	parent := aDANode
]

{ #category : 'private' }
StNode >> rootNode [
	| rootNode currentNode |
	currentNode := self.
	rootNode := currentNode parentNode.
	[ rootNode isNil ]
		whileFalse: [
			currentNode := rootNode.
			rootNode := currentNode parentNode ].
	^ currentNode
]

{ #category : 'browse-nautilus' }
StNode >> selectClass: aClass [
	| aBrowser |

	aBrowser := self rootNode browser.
	aBrowser selectClass: aClass
]

{ #category : 'browse-nautilus' }
StNode >> selectInBrowser [
	^ self subclassResponsibility
]

{ #category : 'browse-nautilus' }
StNode >> selectMethod: aMethod [
	| classToBrowse aBrowser compiledMethod |
	aBrowser := self rootNode browser.
	classToBrowse := aMethod methodClass.
	compiledMethod := classToBrowse>>aMethod selector.
	aBrowser selectMethod: compiledMethod
]

{ #category : 'browse-nautilus' }
StNode >> selectPackage: aPackage [
	| aBrowser |
	aBrowser := self rootNode browser.
	aBrowser selectPackage: aPackage
]

{ #category : 'browse-nautilus' }
StNode >> spawnNewBrowser [
	"do nothing by default"
]

{ #category : 'accessing' }
StNode >> treeModelParent [
	^ treeModelParent
]

{ #category : 'accessing' }
StNode >> treeModelParent: anObject [
	treeModelParent := anObject
]
