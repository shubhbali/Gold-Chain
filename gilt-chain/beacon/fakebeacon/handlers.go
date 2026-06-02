package fakebeacon

import (
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
	"strconv"
	"strings"
)

const MaxBlobsPerBlock = 6

var (
	versionMethod        = "/eth/v1/node/version"
	specMethod           = "/eth/v1/config/spec"
	genesisMethod        = "/eth/v1/beacon/genesis"
	sidecarsMethodPrefix = "/eth/v1/beacon/blob_sidecars/{slot}"
)

type versionResponse struct {
	Data versionData `json:"data"`
}

type versionData struct {
	Version string `json:"version"`
}

type specResponse struct {
	Data ReducedConfigData `json:"data"`
}

type errorResponse struct {
	Message string `json:"message"`
}

func writeJSON(w http.ResponseWriter, resp interface{}) {
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(resp)
}

func handleError(w http.ResponseWriter, message string, status int) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(errorResponse{Message: message})
}

func VersionMethod(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, &versionResponse{Data: versionData{Version: ""}})
}

func SpecMethod(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, &specResponse{Data: configSpec()})
}

func GenesisMethod(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, beaconGenesis())
}

func (s *Service) SidecarsMethod(w http.ResponseWriter, r *http.Request) {
	indices, err := parseIndices(r.URL)
	if err != nil {
		handleError(w, err.Error(), http.StatusBadRequest)
		return
	}
	segments := strings.Split(r.URL.Path, "/")
	slot, err := strconv.ParseUint(segments[len(segments)-1], 10, 64)
	if err != nil {
		handleError(w, "not a valid slot(timestamp)", http.StatusBadRequest)
		return
	}

	resp, err := beaconBlobSidecars(r.Context(), s.backend, slot, indices)
	if err != nil {
		handleError(w, err.Error(), http.StatusBadRequest)
		return
	}
	writeJSON(w, resp)
}

// parseIndices filters out invalid and duplicate blob indices
func parseIndices(url *url.URL) ([]int, error) {
	rawIndices := url.Query()["indices"]
	indices := make([]int, 0, MaxBlobsPerBlock)
	invalidIndices := make([]string, 0)
loop:
	for _, raw := range rawIndices {
		ix, err := strconv.Atoi(raw)
		if err != nil {
			invalidIndices = append(invalidIndices, raw)
			continue
		}
		if ix >= MaxBlobsPerBlock {
			invalidIndices = append(invalidIndices, raw)
			continue
		}
		for i := range indices {
			if ix == indices[i] {
				continue loop
			}
		}
		indices = append(indices, ix)
	}

	if len(invalidIndices) > 0 {
		return nil, fmt.Errorf("requested blob indices %v are invalid", invalidIndices)
	}
	return indices, nil
}
