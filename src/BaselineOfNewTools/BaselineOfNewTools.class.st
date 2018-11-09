Class {
	#name : #BaselineOfNewTools,
	#superclass : #BaselineOf,
	#category : #BaselineOfNewTools
}

{ #category : #baselines }
BaselineOfNewTools >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ "Dependencies"
			self spec: spec.

			"Packages"
			spec package: 'HelpCenter' with: [ spec requires: #('Spec') ] ]
]

{ #category : #accessing }
BaselineOfNewTools >> projectClass [
	^ [ self class environment at: #MetacelloCypressBaselineProject ]
		on: NotFound
		do: [ super projectClass ]
]

{ #category : #dependencies }
BaselineOfNewTools >> spec: spec [
	spec baseline: 'Spec' with: [ spec repository: 'github://pharo-spec/Spec:master/src' ]
]
