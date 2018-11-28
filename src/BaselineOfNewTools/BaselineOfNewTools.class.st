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
			spec
				package: 'NewTools' with: [ spec requires: #('Spec') ];
				package: 'HelpCenter' with: [ spec requires: #('NewTools') ] ]
]

{ #category : #dependencies }
BaselineOfNewTools >> spec: spec [
	spec baseline: 'Spec' with: [ spec repository: 'github://pharo-spec/Spec:master/src' ]
]
