package parlia

import (
	"context"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/ethereum/go-ethereum/common"
)

func TestFetchStateSyncEventsDecodesQuotedNumericFields(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if got := r.URL.Query().Get("from_id"); got != "1" {
			t.Fatalf("wrong from_id query: got %s want 1", got)
		}
		w.Header().Set("Content-Type", "application/json")
		_, _ = w.Write([]byte(`{
			"event_records": [
				{
					"id": "1",
					"contract": "0x41e094035f04c4e960a42253b6f3cc33a77cc11c",
					"data": "AQID",
					"tx_hash": "0xfcdb42c266b287cd4c40c7291d0e8a460e2352192cd1530e7e78cac5ebd3b3d0",
					"log_index": "745",
					"bor_chain_id": "714",
					"record_time": "2026-03-28T07:11:04.060840651Z"
				}
			]
		}`))
	}))
	defer server.Close()

	engine := &Parlia{
		bridge: BridgeConfig{
			HeimdallURL:      server.URL,
			StateSyncTimeout: 5 * time.Second,
		},
	}

	to, err := time.Parse(time.RFC3339, "2026-03-28T07:18:04Z")
	if err != nil {
		t.Fatalf("parse cutoff time: %v", err)
	}

	events, err := engine.fetchStateSyncEvents(context.Background(), 1, to)
	if err != nil {
		t.Fatalf("fetchStateSyncEvents returned error: %v", err)
	}
	if len(events) != 1 {
		t.Fatalf("wrong event count: got %d want 1", len(events))
	}
	event := events[0]
	if event.ID != 1 {
		t.Fatalf("wrong event id: got %d want 1", event.ID)
	}
	if event.LogIndex != 745 {
		t.Fatalf("wrong event log index: got %d want 745", event.LogIndex)
	}
	if event.Contract != common.HexToAddress("0x41e094035f04c4e960a42253b6f3cc33a77cc11c") {
		t.Fatalf("wrong contract: got %s", event.Contract.Hex())
	}
	if event.TxHash != common.HexToHash("0xfcdb42c266b287cd4c40c7291d0e8a460e2352192cd1530e7e78cac5ebd3b3d0") {
		t.Fatalf("wrong tx hash: got %s", event.TxHash.Hex())
	}
	if event.ChainID != "714" {
		t.Fatalf("wrong chain id: got %s want 714", event.ChainID)
	}
	if string(event.Data) != "\x01\x02\x03" {
		t.Fatalf("wrong event data bytes: got %x want 010203", event.Data)
	}
}

func TestFetchStateSyncEventsSkipsRecordsAtOrAfterCutoff(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		_, _ = w.Write([]byte(`{
			"event_records": [
				{
					"id": "7",
					"contract": "0x41e094035f04c4e960a42253b6f3cc33a77cc11c",
					"data": "AQID",
					"tx_hash": "0xfcdb42c266b287cd4c40c7291d0e8a460e2352192cd1530e7e78cac5ebd3b3d0",
					"log_index": "745",
					"bor_chain_id": "714",
					"record_time": "2026-03-29T02:16:54Z"
				},
				{
					"id": "8",
					"contract": "0x41e094035f04c4e960a42253b6f3cc33a77cc11c",
					"data": "AQID",
					"tx_hash": "0x1cdb42c266b287cd4c40c7291d0e8a460e2352192cd1530e7e78cac5ebd3b3d0",
					"log_index": "746",
					"bor_chain_id": "714",
					"record_time": "2026-03-29T02:16:55Z"
				},
				{
					"id": "9",
					"contract": "0x41e094035f04c4e960a42253b6f3cc33a77cc11c",
					"data": "AQID",
					"tx_hash": "0x2cdb42c266b287cd4c40c7291d0e8a460e2352192cd1530e7e78cac5ebd3b3d0",
					"log_index": "747",
					"bor_chain_id": "714",
					"record_time": "2026-03-29T02:16:56Z"
				}
			]
		}`))
	}))
	defer server.Close()

	engine := &Parlia{
		bridge: BridgeConfig{
			HeimdallURL:      server.URL,
			StateSyncTimeout: 5 * time.Second,
		},
	}

	cutoff, err := time.Parse(time.RFC3339, "2026-03-29T02:16:55Z")
	if err != nil {
		t.Fatalf("parse cutoff time: %v", err)
	}

	events, err := engine.fetchStateSyncEvents(context.Background(), 7, cutoff)
	if err != nil {
		t.Fatalf("fetchStateSyncEvents returned error: %v", err)
	}
	if len(events) != 1 {
		t.Fatalf("wrong event count: got %d want 1", len(events))
	}
	if events[0].ID != 7 {
		t.Fatalf("wrong surviving event id: got %d want 7", events[0].ID)
	}
}
