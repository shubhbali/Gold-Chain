package types

// gilt module event types
const (
	EventTypeProposeSpan   = "propose-span"
	EventTypeBackfillSpans = "backfill-spans"

	AttributeKeySpanID           = "span-id"
	AttributeKeySpanStartBlock   = "start-block"
	AttributeKeySpanEndBlock     = "end-block"
	AttributesKeyLatestSpanId    = "latest-span-id"
	AttributesKeyLatestGiltSpanId = "latest-gilt-span-id"

	AttributeValueCategory = ModuleName
)
