package main

import (
	"net/http"
	"os"
	"os/signal"
	"sync"
	"syscall"

	"log"
)

var once sync.Once

func setup() {
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM)

	fh, _ := os.CreateTemp("./logs/", "feuer_*.log")
	log.SetOutput(fh)
	log.SetFlags(0)

	go func() {
		<-c
		os.Remove(fh.Name())
		os.Exit(1)
	}()
}

func logMiddleware(next http.Handler) http.Handler {
	once.Do(setup)

	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Println("{\"path\": \"" + r.URL.Path + "\", \"status\": \"good\"}")
		next.ServeHTTP(w, r)
	})
}
