package web3ext

// GiltJs gilt related apis
const GiltJs = `
web3._extend({
	property: 'gilt',
	methods: [
		new web3._extend.Method({
			name: 'getSnapshot',
			call: 'gilt_getSnapshot',
			params: 1,
			inputFormatter: [null]
		}),
		new web3._extend.Method({
			name: 'getAuthor',
			call: 'gilt_getAuthor',
			params: 1,
			inputFormatter: [null]
		}),
		new web3._extend.Method({
			name: 'getSnapshotProposer',
			call: 'gilt_getSnapshotProposer',
			params: 1,
			inputFormatter: [null]
		}),
		new web3._extend.Method({
			name: 'getSnapshotProposerSequence',
			call: 'gilt_getSnapshotProposerSequence',
			params: 1,
			inputFormatter: [null]
		}),
		new web3._extend.Method({
			name: 'getSnapshotAtHash',
			call: 'gilt_getSnapshotAtHash',
			params: 1
		}),
		new web3._extend.Method({
			name: 'getSigners',
			call: 'gilt_getSigners',
			params: 1,
			inputFormatter: [null]
		}),
		new web3._extend.Method({
			name: 'getSignersAtHash',
			call: 'gilt_getSignersAtHash',
			params: 1
		}),
		new web3._extend.Method({
			name: 'getCurrentProposer',
			call: 'gilt_getCurrentProposer',
			params: 0
		}),
		new web3._extend.Method({
			name: 'getCurrentValidators',
			call: 'gilt_getCurrentValidators',
			params: 0
		}),
		new web3._extend.Method({
			name: 'getRootHash',
			call: 'gilt_getRootHash',
			params: 2,
		}),
		new web3._extend.Method({
			name: 'getVoteOnHash',
			call: 'gilt_getVoteOnHash',
			params: 4,
		}),
		new web3._extend.Method({
			name: 'sendRawTransactionConditional',
			call: 'gilt_sendRawTransactionConditional',
			params: 2,
			inputFormatter: [null]
		}),
	]
});
`
