package core

import (
	"strings"
	"sync"
	"time"
)

type POSAValidatorLifecycle struct {
	mu         sync.RWMutex
	jailed     map[string]struct{}
	jailedTill map[string]uint64
	exited     map[string]struct{}
	slashCount map[string]uint64
	rewards    map[string]uint64
}

func NewPOSAValidatorLifecycle() *POSAValidatorLifecycle {
	return &POSAValidatorLifecycle{
		jailed:     make(map[string]struct{}),
		jailedTill: make(map[string]uint64),
		exited:     make(map[string]struct{}),
		slashCount: make(map[string]uint64),
		rewards:    make(map[string]uint64),
	}
}

func (l *POSAValidatorLifecycle) IsActive(validatorID string) bool {
	l.mu.RLock()
	defer l.mu.RUnlock()
	validatorID = strings.ToLower(validatorID)
	_, jailed := l.jailed[validatorID]
	_, exited := l.exited[validatorID]
	if jailed {
		if until := l.jailedTill[validatorID]; until > 0 && uint64(time.Now().Unix()) >= until {
			jailed = false
		}
	}
	return !jailed && !exited
}

func (l *POSAValidatorLifecycle) Jail(validatorID string) {
	l.JailFor(validatorID, 0)
}

func (l *POSAValidatorLifecycle) JailFor(validatorID string, seconds uint64) {
	l.mu.Lock()
	defer l.mu.Unlock()
	validatorID = strings.ToLower(validatorID)
	l.jailed[validatorID] = struct{}{}
	if seconds > 0 {
		l.jailedTill[validatorID] = uint64(time.Now().Unix()) + seconds
	} else {
		l.jailedTill[validatorID] = 0
	}
}

func (l *POSAValidatorLifecycle) Unjail(validatorID string) {
	l.mu.Lock()
	defer l.mu.Unlock()
	validatorID = strings.ToLower(validatorID)
	delete(l.jailed, validatorID)
	delete(l.jailedTill, validatorID)
}

func (l *POSAValidatorLifecycle) Exit(validatorID string) {
	l.mu.Lock()
	defer l.mu.Unlock()
	validatorID = strings.ToLower(validatorID)
	l.exited[validatorID] = struct{}{}
}

func (l *POSAValidatorLifecycle) AddSlash(validatorID string) {
	l.mu.Lock()
	defer l.mu.Unlock()
	validatorID = strings.ToLower(validatorID)
	l.slashCount[validatorID]++
}

func (l *POSAValidatorLifecycle) AddReward(validatorID string, amount uint64) {
	if amount == 0 {
		return
	}
	l.mu.Lock()
	defer l.mu.Unlock()
	validatorID = strings.ToLower(validatorID)
	l.rewards[validatorID] += amount
}

func (l *POSAValidatorLifecycle) Snapshot() (jailed []string, exited []string, slashCount map[string]uint64, rewards map[string]uint64) {
	l.mu.RLock()
	defer l.mu.RUnlock()
	jailed = make([]string, 0, len(l.jailed))
	for v := range l.jailed {
		jailed = append(jailed, v)
	}
	exited = make([]string, 0, len(l.exited))
	for v := range l.exited {
		exited = append(exited, v)
	}
	slashCount = make(map[string]uint64, len(l.slashCount))
	for v, c := range l.slashCount {
		slashCount[v] = c
	}
	rewards = make(map[string]uint64, len(l.rewards))
	for v, r := range l.rewards {
		rewards[v] = r
	}
	return
}

func (l *POSAValidatorLifecycle) SnapshotJailUntil() map[string]uint64 {
	l.mu.RLock()
	defer l.mu.RUnlock()
	out := make(map[string]uint64, len(l.jailedTill))
	for v, t := range l.jailedTill {
		out[v] = t
	}
	return out
}

func (l *POSAValidatorLifecycle) Load(jailed []string, jailedTill map[string]uint64, exited []string, slashCount map[string]uint64, rewards map[string]uint64) {
	l.mu.Lock()
	defer l.mu.Unlock()
	l.jailed = make(map[string]struct{}, len(jailed))
	l.jailedTill = make(map[string]uint64, len(jailed))
	l.exited = make(map[string]struct{}, len(exited))
	l.slashCount = make(map[string]uint64, len(slashCount))
	l.rewards = make(map[string]uint64, len(rewards))
	for _, v := range jailed {
		l.jailed[strings.ToLower(v)] = struct{}{}
		vid := strings.ToLower(v)
		l.jailedTill[vid] = jailedTill[vid]
	}
	for _, v := range exited {
		l.exited[strings.ToLower(v)] = struct{}{}
	}
	for v, c := range slashCount {
		l.slashCount[strings.ToLower(v)] = c
	}
	for v, r := range rewards {
		l.rewards[strings.ToLower(v)] = r
	}
}

func (l *POSAValidatorLifecycle) Status(validatorID string) map[string]interface{} {
	l.mu.RLock()
	defer l.mu.RUnlock()
	validatorID = strings.ToLower(validatorID)
	_, jailed := l.jailed[validatorID]
	_, exited := l.exited[validatorID]
	return map[string]interface{}{
		"validator":  validatorID,
		"active":     !jailed && !exited,
		"jailed":     jailed,
		"jailedTill": l.jailedTill[validatorID],
		"exited":     exited,
		"slashCount": l.slashCount[validatorID],
		"reward":     l.rewards[validatorID],
	}
}
