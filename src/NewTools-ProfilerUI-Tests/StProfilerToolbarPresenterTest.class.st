"
I test `StProfilerToolbarPresenter`, the toolbar of the profiler showing the path of tally models from the root to the selected one, at the presenter level, without opening it.

## Responsibility:

- Check that the buttons it creates for a tally model (`newItemFrom:`) are created through it, so that they belong to it and use its application.
- Check that such a button shows the method of its tally model and keeps the tally model as its object.

## Collaborators: 

- `StProfilerToolbarButtonPresenter`: the buttons created by the toolbar.
- A stand-in for `StTallyModel`, answering only `methodName` (`newTallyModelNamed:`): a real tally model needs a profiling run. Its class is built in a private environment and compiled without logging, so nothing stays in the image.

## Internal Representation

- `toolbar`: the presenter under test.
- `tallyModel`: the stand-in tally model.
"
Class {
	#name : 'StProfilerToolbarPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'toolbar',
		'tallyModel'
	],
	#category : 'NewTools-ProfilerUI-Tests',
	#package : 'NewTools-ProfilerUI-Tests'
}

{ #category : 'helpers' }
StProfilerToolbarPresenterTest >> newTallyModelNamed: aString [
	"Answer a stand-in for a tally model (StTallyModel) answering aString as its methodName, the only message the toolbar sends when creating a button. Its class is built in a private environment with its own announcer and compiled without logging, so the test leaves no trace in the image."

	| environment class |
	environment := SystemEnvironment new.
	environment codeChangeAnnouncer: Announcer new.
	environment at: #FixedLayout put: FixedLayout.
	class := (Object << #StProfilerTallyModelStandIn)
		         environment: environment;
		         build.
	class
		compile: 'methodName ^ ' , aString printString
		classified: #fixture
		withStamp: nil
		logSource: false.
	^ class new
]

{ #category : 'running' }
StProfilerToolbarPresenterTest >> setUp [

	super setUp.
	toolbar := StProfilerToolbarPresenter new.
	tallyModel := self newTallyModelNamed: 'Foo>>bar'
]

{ #category : 'tests' }
StProfilerToolbarPresenterTest >> testNewItemIsOwnedByTheToolbar [

	self assert: (toolbar newItemFrom: tallyModel) owner identicalTo: toolbar
]

{ #category : 'tests' }
StProfilerToolbarPresenterTest >> testNewItemShowsTheMethodOfTheTallyModel [

	| item |
	item := toolbar newItemFrom: tallyModel.
	self assert: item label equals: 'Foo>>bar'.
	self assert: item object identicalTo: tallyModel
]
