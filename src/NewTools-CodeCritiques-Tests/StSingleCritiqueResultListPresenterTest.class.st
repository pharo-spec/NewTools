"
I test `StSingleCritiqueResultListPresenter`, the list of the critiques of one rule shown by `StCritiqueBrowserPresenter`, at the presenter level, without opening it.

## Responsibility:

- Check that its toolbar and source code presenters are created through it, so that they belong to it and use its application.
- Check that the source code is read only and has no syntax highlighting.

## Collaborators: 

- `StSingleCritiqueResultListPresenter`: created on its own; `StCritiqueBrowserPresenterTest` checks that the browser owns it.

## Internal Representation

- `resultList`: the presenter under test.
"
Class {
	#name : 'StSingleCritiqueResultListPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'resultList'
	],
	#category : 'NewTools-CodeCritiques-Tests',
	#package : 'NewTools-CodeCritiques-Tests'
}

{ #category : 'running' }
StSingleCritiqueResultListPresenterTest >> setUp [

	super setUp.
	resultList := StSingleCritiqueResultListPresenter new
]

{ #category : 'tests' }
StSingleCritiqueResultListPresenterTest >> testSourceCodeHasNoSyntaxHighlight [

	self deny: resultList sourceCodeModel hasSyntaxHighlight
]

{ #category : 'tests' }
StSingleCritiqueResultListPresenterTest >> testSourceCodeIsOwnedByTheResultList [

	self assert: resultList sourceCodeModel owner identicalTo: resultList
]

{ #category : 'tests' }
StSingleCritiqueResultListPresenterTest >> testSourceCodeIsReadOnly [

	self deny: resultList sourceCodeModel isEditable
]

{ #category : 'tests' }
StSingleCritiqueResultListPresenterTest >> testToolbarIsOwnedByTheResultList [

	self assert: resultList toolbarModel owner identicalTo: resultList
]
